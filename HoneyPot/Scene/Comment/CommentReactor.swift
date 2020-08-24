//
//  CommentReactor.swift
//  Development
//
//  Created by Soso on 2020/08/19.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import ReactorKit

final class CommentReactor: Reactor {
    let provider: ServiceProviderType

    init(provider: ServiceProviderType, itemID: Int) {
        self.provider = provider
        self.initialState = State(itemID: itemID)
    }
    // MARK: - Reactor
    var initialState: State

    struct State {
        let itemID: Int
        var comments: [CommentSection] = []
        var pageIndex: Int = 0
        var selectedIndexPath: IndexPath?
        var selectedText: String?
        var isRefreshing = false
        var isLoading = false
    }
    enum Action {
        case refresh
        case load
        case addComment(String)
        case likeComment(IndexPath)
        case deleteComment(IndexPath)
        case selectIndexPath(IndexPath?)
    }
    enum Mutation {
        case setComments([CommentSection])
        case addComment(Int?, Comment)
        case updateComment(IndexPath, Comment)
        case deleteComment(IndexPath)
        case setSelectedIndexPath(IndexPath?)
        case setRefreshing(Bool)
        case setLoading(Bool)
        case setPageIndex(Int)
    }
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat(
                refresh(),
                .just(Mutation.setPageIndex(0))
            )
        case .load:
            guard !currentState.isLoading else { return .empty() }
            let index = currentState.pageIndex + 1
            return Observable.concat(
                load(index: index),
                .just(Mutation.setPageIndex(0))
            )
        case .addComment(let text):
            var commentID: Int?
            if let indexPath = currentState.selectedIndexPath {
                let section = indexPath.section
                let row = indexPath.row
                commentID = currentState.comments[section].items[row].item.commentId
            }
            let id = currentState.itemID
            let userID = provider.accountService.userID
            return provider.networkService
                .request(.commentAdd(id, commentID, userID, text), type: CommentEntity.self)
                .map(Comment.init)
                .map { Mutation.addComment(commentID, $0) }
                .asObservable()
        case .likeComment(let indexPath):
            let section = indexPath.section
            let row = indexPath.row
            var comment = currentState.comments[section].items[row].item
            let id = comment.commentId
            return provider.networkService
                .request(.commentLike(id), type: Bool.self)
                .map({ isLiked -> Comment in
                    comment.isLiked = isLiked
                    if isLiked {
                        comment.likeCount += 1
                    } else {
                        comment.likeCount = max(comment.likeCount - 1, 0)
                    }
                    return comment
                })
                .map { Mutation.updateComment(indexPath, $0) }
                .asObservable()
        case .deleteComment(let indexPath):
            let section = indexPath.section
            let row = indexPath.row
            let id = currentState.comments[section].items[row].item.commentId
            return provider.networkService
                .request(.commentRemove(id), type: Bool.self)
                .map { _ in Mutation.deleteComment(indexPath) }
                .asObservable()
        case .selectIndexPath(let indexPath):
            return .just(Mutation.setSelectedIndexPath(indexPath))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setComments(let comments):
            state.comments = comments
        case .addComment(let id, let comment):
            addComment(state: &state, id: id, comment: comment)
        case .updateComment(let indexPath, let comment):
            let section = indexPath.section
            let row = indexPath.row
            if row == 0 {
                state.comments[section].items[row] = .comment(comment)
            } else {
                state.comments[section].items[row] = .subcomment(comment)
            }
        case .deleteComment(let indexPath):
            let section = indexPath.section
            let row = indexPath.row
            if row == 0 {
                state.comments.remove(at: section)
            } else {
                state.comments[section].items.remove(at: row)
                state.comments[section].items[0].item.comments.remove(at: row - 1)
                state.comments[section].items[0].item.subcommentCount -= 1
            }
        case .setSelectedIndexPath(let indexPath):
            state.selectedIndexPath = indexPath
            state.selectedText = selectedText(for: indexPath)
        case .setRefreshing(let isRefreshing):
            state.isRefreshing = isRefreshing
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setPageIndex(let index):
            state.pageIndex = index
        }
        return state
    }

    private func addComment(state: inout State, id: Int?, comment: Comment) {
        if let id = id, let index = state.comments.firstIndex(where: { $0.id == id }) {
            state.comments[index].items.insert(.subcomment(comment), at: 1)
            state.comments[index].items[0].item.comments.insert(comment, at: 0)
            state.comments[index].items[0].item.subcommentCount += 1
        } else {
            let data = CommentSection(
                id: comment.commentId,
                items: [.comment(comment)])
            state.comments.insert(data, at: 0)
        }
        state.selectedIndexPath = nil
    }
    private func selectedText(for indexPath: IndexPath?) -> String? {
        if let indexPath = indexPath {
            let section = indexPath.section
            let row = indexPath.row
            let name = currentState.comments[section].items[row].item.author.name
            return "\(name)님에게 대댓글 남기는중"
        } else {
            return nil
        }
    }
    private func refresh(
    ) -> Observable<Mutation> {
        return Observable.concat(
            .just(Mutation.setRefreshing(true)),
            requestItems().map({ Mutation.setComments($0) })
                .observeOn(MainScheduler.asyncInstance),
            .just(Mutation.setRefreshing(false))
        )
    }
    private func load(
        index: Int
    ) -> Observable<Mutation> {
        let comments = currentState.comments
        return Observable.concat(
            .just(Mutation.setLoading(true)),
            requestItems(index: index)
                .map({ Mutation.setComments(comments + $0) })
                .observeOn(MainScheduler.asyncInstance),
            .just(Mutation.setLoading(false))
        )
    }
    private func requestItems(
        index: Int = 0
    ) -> Observable<[CommentSection]> {
        let id = currentState.itemID
        return provider.networkService
            .request(.comments(id, index), type: PageableList<CommentEntity>.self)
            .map({ response -> [CommentSection] in
                return response.content
                    .map(Comment.init)
                    .map({
                        ($0.commentId, [CommentSectionItem.comment($0)] + $0.comments.map(CommentSectionItem.subcomment))
                    })
                    .map(CommentSection.init)
            }).asObservable()
    }
}
