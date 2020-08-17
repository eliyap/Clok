//
//  DecoderExtension.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//  https://stackoverflow.com/questions/52555913/save-complex-json-to-core-data-in-swift

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

extension JSONDecoder {
    convenience init(context: NSManagedObjectContext) {
        self.init()
        self.userInfo[.context] = context
    }
}

/// allow `JSONDecoder` to be initialized with a specified `DateDecodingStrategy`
/// for use in `Combine`'s `.decode(type: X, decoder: Y)`
extension JSONDecoder {
    convenience init(dateStrategy: JSONDecoder.DateDecodingStrategy) {
        self.init()
        self.dateDecodingStrategy = dateStrategy
    }
}
