//
//  Error.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//
import XCTest
@testable import MyLibrary

enum PresenterError: Swift.Error {
    typealias RawValue = NSError
    case fail
}
