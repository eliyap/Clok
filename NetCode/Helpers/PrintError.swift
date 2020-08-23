//
//  PrintError.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

/**
 print any errors that are encountered,
 then return `nil`.
 Note: unlike `replaceErrorWith(nil)`, this prints the issue to console instead of suppressing it
 */
func printAndReturnNil<T>(error: Error) -> AnyPublisher<T?, Never> {
    #if DEBUG
    print(error)
    #endif
    return Just(nil)
        .eraseToAnyPublisher()
}
