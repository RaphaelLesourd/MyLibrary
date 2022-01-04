//
//  Array+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 05/12/2021.
//

extension Array {
    /// Split a given array in an array of arrays with each array of user defined size
    ///  - Parameters:
    ///   - size: Int to set the size of each arrays contained in the main array
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
