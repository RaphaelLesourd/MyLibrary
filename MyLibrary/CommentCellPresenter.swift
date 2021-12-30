//
//  CommentCellPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/12/2021.
//

protocol CommentCellPresenter {
    func configure(_ cell: CommentTableViewCell, with comment: CommentModel)
    func setUserDetails(for cell: CommentTableViewCell, with user: UserModel)
}
