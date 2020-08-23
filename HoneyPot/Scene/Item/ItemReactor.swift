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
        self.initialState = State(itemID: itemID, isSharePopUpHidden: hasClosed)
    }
    // MARK: - Reactor
    var initialState: State

    struct State {
        let itemID: Int
        var bannerURL: String?
        var contentURL: String?
        var title: String?
        var category: String?
        var priceOriginal: String?
        var pricePercent: String?
        var priceDiscount: String?
        var discountUntil: String?
        var discounts: [DiscountEntity]?
        var percent: Double = 0
        var participants: Int?
        var deadline: String?
        var sellerName: String?
        var numberOfReview: String?
        var comments: [CommentEntity]?
        var commentText: String?
        var isLiked: Bool = false
        var isClosed: Bool = false
        var isParticipating: Bool = false
        var isSharePopUpHidden: Bool
    }
    enum Action {
        case refresh
        case likePost
        case likeComment(Int)
        case toggleSharePopUp
    }
    enum Mutation {
        case setItem(PostEntity)
        case setLike(Bool)
        case setComment(CommentEntity)
        case setSharePopUpHidden(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return provider.networkService
                .request(.post(currentState.itemID), type: PostEntity.self)
                .asObservable()
                .map { Mutation.setItem($0) }
        case .likePost:
            return provider.networkService
                .request(.postLike(currentState.itemID), type: Bool.self)
                .asObservable()
                .map { Mutation.setLike($0) }
        case .likeComment(let id):
            guard var comment = currentState.comments?.first(where: { $0.commentId == id }) else { return .empty() }
            return provider.networkService
                .request(.commentLike(id), type: Bool.self)
                .asObservable()
                .map({ isLiked in
                    comment.liked = isLiked
                    return Mutation.setComment(comment)
                })
        case .toggleSharePopUp:
            provider.flagService.set(value: true, forKey: .hasClosedSharePopup)
            return .just(Mutation.setSharePopUpHidden(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setItem(let post):
            state.bannerURL = post.bannerUrl
            state.contentURL = post.contentUrl
            state.comments = post.comments
            if post.comments.isEmpty {
                state.commentText = "가장 먼저 댓글을 남겨보세요"
            } else {
                state.commentText = "\(post.comments.count)"
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
            } else {
                state.pricePercent = nil
                state.priceDiscount = priceOriginal
            }
            if description.isClosed,
                let date = description.deadlineDate {
                let next = date.addingTimeInterval(60*60*24)
                let calendar = Calendar(identifier: .gregorian)
                let month = calendar.component(.month, from: next)
                let day = calendar.component(.day, from: next)
                state.discountUntil = "\(month)월 \(day)일 출고 예정"
            } else if let next = description.nextDiscount {
                let percent = next.discountPercent
                let number = next.numberOfPeople - description.participants
                state.discountUntil = "\(percent)% 할인까지 \(number)명!"
            } else {
                state.discountUntil = nil
            }
            if let total =  description.discounts.last?.numberOfPeople {
                let current = Double(description.participants) / Double(total)
                state.percent = max(min(current, 1), 0)
            }
            state.participants = description.participants
            state.deadline = formattedDate(date: description.deadlineDate)
            let seller = post.seller
            state.sellerName = seller.name
            state.numberOfReview = "\(seller.numberOfReview)개의 후기"
            state.isLiked = true
            state.isClosed = description.isClosed
            state.isParticipating = false
        case .setLike(let isLiked):
            state.isLiked = isLiked
        case .setComment(let comment):
            if var comments = state.comments,
                let index = comments.firstIndex(of: comment) {
                comments[index] = comment
                state.comments = comments
            }
        case .setSharePopUpHidden(let isHidden):
            state.isSharePopUpHidden = isHidden
        }
        return state
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
