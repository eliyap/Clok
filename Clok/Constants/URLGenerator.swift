//
//  URLGenerator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension NetworkConstants {
    static func url(for entry: TimeEntryLike) -> URL {
        URL(string: "\(Self.API_URL)/time_entries/\(entry.id)\(Self.agentSuffix)")!
    }
}
