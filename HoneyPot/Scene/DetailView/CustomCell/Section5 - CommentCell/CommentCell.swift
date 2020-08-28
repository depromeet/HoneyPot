//
//  CommentCell.swift
//  Depromeet8th4
//
//  Created by Yeojaeng on 2020/08/03.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentedTime: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var thumbsUpCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    weak var delegate: UIViewController?

    @IBAction func tappedMoreButton(_: UIButton) {
        presentActionSheet()
    }

    func presentActionSheet() {
        let actionSheet: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "대댓글 쓰기", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        delegate!.present(actionSheet, animated: true, completion: nil)
    }
}
