//
//  CollectionExistCheck.swift
//  Form Identifier
//
//  Checks if a specific index of an array exists before accessing it.
//
//  https://stackoverflow.com/questions/37222811/how-do-i-catch-index-out-of-range-in-swift
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
