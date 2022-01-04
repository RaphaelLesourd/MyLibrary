//
//  UserCellPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/01/2022.
//

protocol UserCellPresenter {
    func setData(with user: UserModel, completion: @escaping (UserCellData) -> Void)
}
