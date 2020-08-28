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
        initialState = State(itemID: itemID)
    }

    // MARK: - Reactor

    var initialState: State

    struct State {
        let itemID: Int
        var comments: [CommentSection] = []
        var pageIndex: Int = 0
        var selectedIndexPath: IndexPath?
        var selectedText: String?
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var isLast: Bool = false
    }

    enum Action {
        case refresh
        case load
        case toggleComment(IndexPath)
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
        case updateSection(Int, Comment)
        case setSelectedIndexPath(IndexPath?)
        case setRefreshing(Bool)
        case setLoading(Bool)
        case setPageIndex(Int)
        case setLast(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat(
                refresh(),
                .just(Mutation.setPageIndex(0)),
                .just(Mutation.setLast(false))
            )
        case .load:
            guard !currentState.isLoading, !currentState.isLast else { return .empty() }
            let index = currentState.pageIndex + 1
            return Observable.concat(
                load(index: index),
                .just(Mutation.setPageIndex(0))
            )
        case let .toggleComment(indexPath):
            return toggleComment(indexPath: indexPath)
        case let .addComment(text):
            var commentID: Int?
            if let indexPath = currentState.selectedIndexPath {
                let section = indexPath.section
                let row = indexPath.row
                commentID = currentState.comments[section].items[row].item.commentID
            }
            let id = currentState.itemID
            let userID = provider.accountService.userID
            return provider.networkService
                .request(.commentAdd(id, commentID, userID, text), type: CommentEntity.self, #file, #function, #line)
                .map(Comment.init)
                .map { Mutation.addComment(commentID, $0) }
                .asObservable()
        case let .likeComment(indexPath):
            let section = indexPath.section
            let row = indexPath.row
            var comment = currentState.comments[section].items[row].item
            let id = comment.commentID
            return provider.networkService
                .request(.commentLike(id), type: Bool.self, #file, #function, #line)
                .map { isLiked -> Comment in
                    comment.isLiked = isLiked
                    if isLiked {
                        comment.likeCount += 1
                    } else {
                        comment.likeCount = max(comment.likeCount - 1, 0)
                    }
                    return comment
                }
                .map { Mutation.updateComment(indexPath, $0) }
                .asObservable()
        case let .deleteComment(indexPath):
            let section = indexPath.section
            let row = indexPath.row
            let id = currentState.comments[section].items[row].item.commentID
            return provider.networkService
                .request(.commentRemove(id), type: Bool.self, #file, #function, #line)
                .map { _ in Mutation.deleteComment(indexPath) }
                .asObservable()
        case let .selectIndexPath(indexPath):
            return .just(Mutation.setSelectedIndexPath(indexPath))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setComments(comments):
            state.comments = comments
        case let .addComment(id, comment):
            addComment(state: &state, id: id, comment: comment)
        case let .updateComment(indexPath, comment):
            updateComment(state: &state, indexPath: indexPath, comment: comment)
        case let .deleteComment(indexPath):
            deleteComment(state: &state, indexPath: indexPath)
        case let .updateSection(section, comment):
            updateSection(state: &state, section: section, comment: comment)
        case let .setSelectedIndexPath(indexPath):
            state.selectedIndexPath = indexPath
            state.selectedText = selectedText(for: indexPath)
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setPageIndex(index):
            state.pageIndex = index
        case let .setLast(isLast):
            state.isLast = isLast
        }
        return state
    }

    private func toggleComment(indexPath: IndexPath) -> Observable<Mutation> {
        let section = indexPath.section
        let row = indexPath.row
        var comment = currentState.comments[section].items[row].item
        let commentID = comment.commentID
        if comment.isExpanded {
            if comment.subcommentCount == comment.comments.count {
                comment.isExpanded = false
            } else {
                return provider.networkService
                    .request(.subcomments(commentID), type: [CommentEntity].self, #file, #function, #line)
                    .map { $0.map(Comment.init) }
                    .map { comments in
                        comment.subcommentCount = comments.count
                        comment.comments = comments
                        return comment
                    }
                    .map { Mutation.updateSection(indexPath.section, $0) }
                    .asObservable()
            }
        } else {
            comment.isExpanded = true
        }
        return .just(Mutation.updateSection(indexPath.section, comment))
    }

    private func addComment(state: inout State, id: Int?, comment: Comment) {
        if let id = id, let index = state.comments.firstIndex(where: { $0.id == id }) {
            state.comments[index].items.insert(.subcomment(comment), at: 1)
            state.comments[index].items[0].item.comments.insert(comment, at: 0)
            state.comments[index].items[0].item.subcommentCount += 1
        } else {
            let data = CommentSection(
                id: comment.commentID,
                items: [.comment(comment)]
            )
            state.comments.insert(data, at: 0)
        }
        state.selectedIndexPath = nil
    }

    private func updateComment(state: inout State, indexPath: IndexPath, comment: Comment) {
        let section = indexPath.section
        let row = indexPath.row
        if row == 0 {
            state.comments[section].items[row] = .comment(comment)
        } else {
            state.comments[section].items[row] = .subcomment(comment)
        }
    }

    private func deleteComment(state: inout State, indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if row == 0 {
            state.comments.remove(at: section)
        } else {
            state.comments[section].items.remove(at: row)
            state.comments[section].items[0].item.comments.remove(at: row - 1)
            state.comments[section].items[0].item.subcommentCount -= 1
        }
    }

    private func updateSection(state: inout State, section: Int, comment: Comment) {
        state.comments[section].items[0].item = comment
        if comment.isExpanded {
            let items = [.comment(comment)] + comment.comments.map(CommentSectionItem.subcomment)
            state.comments[section].items = items
        } else {
            let items = [CommentSectionItem.comment(comment)]
            state.comments[section].items = items
        }
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
            requestItems()
                .flatMap { items, isLast -> Observable<Mutation> in
                    Observable.concat(
                        .just(Mutation.setComments(items)),
                        .just(Mutation.setLast(isLast))
                    )
                }
                .observeOn(MainScheduler.asyncInstance),
            .just(Mutation.setRefreshing(false))
        )
    }

    private func load(
        index: Int
    ) -> Observable<Mutation> {
        let comments = currentState.comments
        return Observable.concat(
            .just(Mutation.setRefreshing(true)),
            requestItems(index: index)
                .flatMap { items, isLast -> Observable<Mutation> in
                    Observable.concat(
                        .just(Mutation.setComments(comments + items)),
                        .just(Mutation.setLast(isLast))
                    )
                }
                .observeOn(MainScheduler.asyncInstance),
            .just(Mutation.setRefreshing(false))
        )
    }

    private func requestItems(
        index: Int = 0
    ) -> Observable<([CommentSection], Bool)> {
        let id = currentState.itemID
        return provider.networkService
            .request(.comments(id, index), type: PageableList<CommentEntity>.self, #file, #function, #line)
            .map { response -> ([CommentSection], Bool) in
                let isLast = response.last
                let items = response.content
                    .map(Comment.init)
                    .map {
                        ($0.commentID, [CommentSectionItem.comment($0)] + $0.comments.map(CommentSectionItem.subcomment))
                    }
                    .map(CommentSection.init)
                return (items, isLast)
            }.asObservable()
    }
}
