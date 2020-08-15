//
//  LoginWith.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

extension LoginView {
    func loginWith(auth: String) -> Void {
        let request = formRequest(
            url: userDataURL,
            auth: auth
        )
        
        cred.cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: User?.self, decoder: JSONDecoder())
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                /// save user's credentials in iOS Keychain
                guard let user = $0 else { return }
                cred.user = user
                try! saveKeys(user: user)
            })
    }
}
