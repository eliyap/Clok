//
//  SortedArrayInsert.swift
//  Clok
//
//  Credit to @vadian, https://stackoverflow.com/a/55395494
//

import Foundation


extension RandomAccessCollection { // the predicate version is not required to conform to Comparable
    /// binary search through sorted array to find insertion point for new value
    func insertionIndex(for predicate: (Element) -> Bool) -> Index {
        var slice : SubSequence = self[...]

        while !slice.isEmpty {
            let middle = slice.index(slice.startIndex, offsetBy: slice.count / 2)
            if predicate(slice[middle]) {
                slice = slice[index(after: middle)...]
            } else {
                slice = slice[..<middle]
            }
        }
        return slice.startIndex
    }
}
