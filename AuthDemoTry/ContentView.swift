//
//  ContentView.swift
//  AuthDemoTry
//
//  Created by tilekbek kadyrov on 1/17/20.
//  Copyright © 2020 tilekbek kadyrov. All rights reserved.
//

import SwiftUI
import SwiftKeychainWrapper

struct ContentView: View {
    @EnvironmentObject var user: UserManager
    
    func getUser() {
        user.listen()
    }
    
    var body: some View {
        Group {
            if (user.user != nil) {
                Text("Welcome Back")
                Button(action: user.signOut, label: {
                    Text("Sign Out")
                })
            } else {
                AuthView()
            }
        }.onAppear(perform: getUser)
    }
}
