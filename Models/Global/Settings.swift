//  Credentials.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import Foundation
import Combine

final class Credentials: ObservableObject {
    
    init(user: User?){
        self.user = user
    }
    
    @Published var user: User?
    var cancellable: AnyCancellable? = nil
}

extension Credentials {
    func fetchUser(
        auth: String,
        completion: ((User) -> Void)? = nil
    ) -> Void {
        #if DEBUG
        print("Now logging in...")
        #endif
        cancellable = URLSession.shared.dataTaskPublisher(for: formRequest(
            url: NetworkConstants.userDataURL,
            auth: auth
        ))
            .map { $0.data }
            .decode(type: User?.self, decoder: JSONDecoder())
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                guard let user = $0 else { return }
                self.user = user
                /// save user's credentials in iOS Keychain
                try! saveKeys(user: user)
                
                /// execute completion block, if any
                if let completion = completion {
                    completion(user)
                }
            })
    }
}
