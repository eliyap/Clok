//
//  GetCredentials.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

func getKey() throws -> (String, String, String, Int) {
    let query = [kSecClass: kSecClassInternetPassword,
                 kSecAttrServer: service,
                 kSecReturnAttributes: true,
                 kSecReturnData: true
        ] as CFDictionary

    var result: AnyObject?
    let status = SecItemCopyMatching(query, &result)
    
    guard status == 0 else {
        throw KeychainError.unhandledError(code: status)
    }
    
    // convert and return data
    let dic = result as! NSDictionary
    let email = dic[kSecAttrAccount] as! String
    let keyData = dic[kSecValueData] as! Data
    let fullName = dic[kSecAttrCreator] as! String
    let token = String(data: keyData, encoding: .utf8)!
    let chosenWID = dic[kSecAttrPort] as! Int
    
    return (email, fullName, token, chosenWID)
}
