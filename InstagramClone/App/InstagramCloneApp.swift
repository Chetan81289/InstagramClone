//
//  InstagramCloneApp.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI
import FirebaseCore 

@main
struct InstagramCloneApp: App {
    @StateObject var authVM = AuthViewModel()
    init() {
           FirebaseApp.configure()
       }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
        }
    }
}
