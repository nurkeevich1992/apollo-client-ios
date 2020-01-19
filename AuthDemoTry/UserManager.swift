//
//  UserManager.swift
//  AuthDemoTry
//
//  Created by tilekbek kadyrov on 1/18/20.
//  Copyright © 2020 tilekbek kadyrov. All rights reserved.
//

import SwiftUI
import SwiftKeychainWrapper
import Combine

class UserManager: ObservableObject {
    var didChange = PassthroughSubject<UserManager, Never>()
    
    @Published var user: User? { didSet { self.didChange.send(self) } }
    
    func listen() {
        NetworkManager.shared.apollo.fetch(query: UserQuery()) { (result) in
            switch result {
                case .failure(_):
                    self.user = nil
                    return
                case .success(let resultData):
                    guard let user = resultData.data?.me else {
                        self.user = nil
                        return
                    }
                
                    self.user = User(uid: user.id, email: user.email, phone: user.phone, name: user.name)
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, phone: String) {
        NetworkManager.shared.apollo.perform(mutation: SignUpMutation(name: name, email: email, password: password, phone: phone)) { (result) in
            switch result {
                case .failure(let errors):
                    print(errors.localizedDescription)
                case .success(let resultData):
                    guard let user = resultData.data?.signup else {
                        print("Error occured while signing up.")
                        return
                    }
                    KeychainWrapper.standard.set(user.token, forKey: "token")
                    self.user = User(uid: user.user.id, email: user.user.email, phone: user.user.phone, name: user.user.name)
            }
        }
    }
    
    func signIn(email: String, password: String) {
        NetworkManager.shared.apollo.perform(mutation: SignInMutation(email: email, password: password)) { (result) in
            switch result {
                case .failure(let errors):
                    print(errors.localizedDescription)
                case .success(let resultData):
                    guard let user = resultData.data?.login else {
                        print("Error occured while signing in.")
                        return
                    }
                    KeychainWrapper.standard.set(user.token, forKey: "token")
                    self.user = User(uid: user.user.id, email: user.user.email, phone: user.user.phone, name: user.user.name)
            }
        }
    }
    
    func signOut() {
        KeychainWrapper.standard.removeAllKeys()
        self.user = nil
    }
}

struct User {
    var uid: String
    var email: String?
    var phone: String
    var name: String
    
    init(uid: String, email: String?, phone: String, name: String) {
        self.uid = uid
        self.email = email
        self.phone = phone
        self.name = name
    }
}
