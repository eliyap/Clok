//
//  DataTaskMonitor.swift
//  Clok
//
//  Created by Secret Asian Man 3 on 20.08.17.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/// boilerplate function that attaches to a `URLSession.DataTaskPublisher` and reports on the response code, then unwraps the `data`
/// can probably be build up over future projects to be more capable
let dataTaskMonitor = { (result: URLSession.DataTaskPublisher.Output) -> Data in
    let code = (result.response as? HTTPURLResponse)?.statusCode
        ?? -1
    if !(200...299).contains(code) {
        print(result.response)
        print("HTTP Error with Code: \(code)")
    }
    return result.data
}
