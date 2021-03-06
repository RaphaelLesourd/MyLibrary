//
//  CategoryActionTypes.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//
import UIKit

/// TableViews swipe actions
enum CellSwipeActionType {
    case delete
    case edit
    
    var title: String {
        switch self {
        case .delete:
            return Text.ButtonTitle.delete
        case .edit:
            return Text.ButtonTitle.edit
        }
    }
    
    var color: UIColor {
        switch self {
        case .delete:
            return .systemRed
        case .edit:
            return .systemOrange
        }
    }
    
    var icon: UIImage {
        switch self {
        case .delete:
            return Images.ContextMenuIcon.trashCircleIcon
        case .edit:
            return Images.ContextMenuIcon.editCircleIcon
        }
    }
}
