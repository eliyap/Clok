//
//  DataFetcher.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 27/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

public class DataFetcher : ObservableObject{
    
    var cancellable : Set<AnyCancellable> = Set()
    
    static let shared = DataFetcher()
    
}
