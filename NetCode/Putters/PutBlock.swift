//
//  PutBlock.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension NetworkConstants {
    static let putHandler = { (data: Data?, response: URLResponse?, error: Error?) -> Void in
        if let error = error {
            #if DEBUG
            print("Error making PUT request: \(error.localizedDescription)")
            #endif
            return
        }
        
        if let responseCode = (response as? HTTPURLResponse)?.statusCode, let data = data {
            guard responseCode == 200 else {
                #if DEBUG
                print("Invalid response code: \(responseCode) with data:")
                do {
                    print(try JSONSerialization.jsonObject(with: data, options: []))
                } catch {
                    print(JSONSerialization.isValidJSONObject(data))
                    print("Could not decode response.")
                }
                
                #endif
                return
            }
        }
    }
}
