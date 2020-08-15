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
    func loginWith(auth: String) -> Void {
        cancellable = URLSession.shared.dataTaskPublisher(for: formRequest(
            url: userDataURL,
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
            })
    }
}
