//
//  CommentSections.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

enum CommentsSection: CaseIterable {
    case book
    case today
    case past
    
    var headerTitle: String {
        switch self {
        case .book, .past:
            return ""
        case .today:
            return Text.SectionTitle.todayComment
        }
    }
}
