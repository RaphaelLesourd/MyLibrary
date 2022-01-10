//
//  CommentSections.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

/// Comments ViewController TableView sections
enum CommentsSection: CaseIterable {
    case book
    case today
    case past
    
    var headerTitle: String {
        switch self {
        case .book:
            return ""
        case .today:
            return Text.SectionTitle.todayComment
        case .past:
            return Text.SectionTitle.pastComment
        }
    }
}
