//
//  UserCellConfigure.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/01/2022.
//

protocol UserCellConfigure {
    func setData(with user: UserModel, completion: @escaping (UserCellData) -> Void)
}
