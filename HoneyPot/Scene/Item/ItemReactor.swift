//
//  ItemReactor.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/13.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import ReactorKit

final class ItemReactor: Reactor {
    let provider: ServiceProviderType

    init(provider: ServiceProviderType, itemID: Int) {
        self.provider = provider
        let hasClosed = provider.flagService.value(forKey: .hasClosedSharePopup)
        initialState = State(itemID: itemID, isSharePopUpHidden: hasClosed)
    }

    // MARK: - Reactor

    var initialState: State

    struct State {
        let itemID: Int
        var bannerURL: String?
        var contentURL: String?
        var sellerURL: String?
        var title: String?
        var category: String?
        var priceOriginal: String?
        var pricePercent: String?
        var priceDiscount: String?
        var isDiscounted: Bool = true
        var discountUntil: String?
        var discounts: [DiscountEntity]?
        var percent: Double = 0
        var participants: Int?
        var deadline: String?
        var sellerName: String?
        var numberOfReview: String?
        var comments: [Comment] = []
        var commentText: String?
        var isButtonViewAllHidden: Bool = true
        var isLiked: Bool = false
        var isClosed: Bool = false
        var isParticipating: Bool = false
        var isSharePopUpHidden: Bool
    }

    enum Action {
        case refresh
        case likePost
        case likeComment(Int)
        case participate
        case toggleSharePopUp
    }

    enum Mutation {
        case setItem(PostEntity)
        case setLike(Bool)
        case setParticipate(Bool)
        case setComment(Comment)
        case setSharePopUpHidden(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return provider.networkService
                .request(.post(currentState.itemID), type: PostEntity.self, #file, #function, #line)
                .asObservable()
                .map { Mutation.setItem($0) }
        case .likePost:
            return provider.networkService
                .request(.postLike(currentState.itemID), type: Bool.self, #file, #function, #line)
                .asObservable()
                .map { Mutation.setLike($0) }
        case let .likeComment(id):
            guard var comment = currentState.comments.first(where: { $0.commentID == id }) else { return .empty() }
            return provider.networkService
                .request(.commentLike(id), type: Bool.self, #file, #function, #line)
                .asObservable()
                .map { isLiked in
                    comment.isLiked = isLiked
                    if isLiked {
                        comment.likeCount += 1
                    } else {
                        comment.likeCount = max(comment.likeCount - 1, 0)
                    }
                    return Mutation.setComment(comment)
                }
        case .participate:
            return provider.networkService
                .request(.participate(currentState.itemID), type: Bool.self, #file, #function, #line)
                .asObservable()
                .map { Mutation.setParticipate($0) }
        case .toggleSharePopUp:
            provider.flagService.set(value: true, forKey: .hasClosedSharePopup)
            return .just(Mutation.setSharePopUpHidden(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setItem(post):
            setItem(state: &state, post: post)
        case let .setLike(isLiked):
            state.isLiked = isLiked
        case let .setParticipate(isParticipating):
            state.isParticipating = isParticipating
            if isParticipating, let participants = state.participants {
                state.participants = participants + 1
            }
        case let .setComment(comment):
            if let index = state.comments.firstIndex(where: { $0.commentID == comment.commentID }) {
                state.comments[index] = comment
            }
        case let .setSharePopUpHidden(isHidden):
            state.isSharePopUpHidden = isHidden
        }
        return state
    }

    private func setItem(state: inout State, post: PostEntity) {
        state.bannerURL = post.bannerUrl
        state.contentURL = post.contentUrl
        state.isLiked = post.wished
        state.comments = post.comments.map(Comment.init)
        if post.commentsCnt == 0 {
            state.commentText = "가장 먼저 댓글을 남겨보세요"
            state.isButtonViewAllHidden = true
        } else {
            state.commentText = "\(post.commentsCnt)"
            state.isButtonViewAllHidden = false
        }
        let description = post.description
        state.title = description.title
        state.category = description.category
        state.discounts = description.discounts
        let priceOriginal = formattedPrice(price: description.price)
        state.priceOriginal = priceOriginal
        if let percent = description.nowDiscount?.discountPercent {
            state.pricePercent = "\(percent)%"
            let ratio = (Double(percent) / 100.0)
            let price = Double(description.price) * (1 - ratio)
            state.priceDiscount = formattedPrice(price: Int(price))
            state.isDiscounted = true
        } else {
            state.pricePercent = nil
            state.priceDiscount = priceOriginal
            state.isDiscounted = false
        }
        if description.isClosed,
            let date = description.deadlineDate
        {
            let next = date.addingTimeInterval(60 * 60 * 24)
            let calendar = Calendar(identifier: .gregorian)
            let month = calendar.component(.month, from: next)
            let day = calendar.component(.day, from: next)
            state.discountUntil = "\(month)월 \(day)일 출고 예정"
        } else if let next = description.nextDiscount {
            let percent = next.discountPercent
            let number = next.numberOfPeople - description.participants
            state.discountUntil = "\(percent)% 할인까지 \(number)명!"
        } else if description.participants >= description.numberOfGoal {
            state.discountUntil = "최고 할인율 달성!"
        } else {
            state.discountUntil = nil
        }
        if let total = description.discounts.last?.numberOfPeople {
            let current = Double(description.participants) / Double(total)
            state.percent = max(min(current, 1), 0)
        }
        state.participants = description.participants
        state.deadline = formattedDate(date: description.deadlineDate)
        let seller = post.seller
        state.sellerName = seller.name
        state.numberOfReview = "\(seller.numberOfReview)개의 후기"
        state.isClosed = description.isClosed
        state.isParticipating = post.participated
        state.sellerURL = seller.thumbnail
    }

    private func formattedPrice(price: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        formatter.numberStyle = .decimal
        return formatter.string(from: .init(value: price))
    }

    private func formattedDate(date: Date?) -> String? {
        guard let date = date else { return nil }
        let interval = Int(round(date.timeIntervalSinceNow))
        let minute = 60
        let hour = minute * 60
        let day = hour * 24

        let numberOfDaysLeft = interval / day
        let numberOfHoursLeft = interval % day / hour
        let numberOfMinutesLeft = interval % day % hour / minute

        if numberOfDaysLeft > 0 {
            return "\(numberOfDaysLeft)일 \(numberOfHoursLeft)시간"
        } else if numberOfHoursLeft > 0 {
            return "\(numberOfHoursLeft)시간 \(numberOfMinutesLeft)분"
        } else {
            return "\(numberOfMinutesLeft)분"
        }
    }
}
