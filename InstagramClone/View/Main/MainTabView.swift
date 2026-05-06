//
//  MainTabView.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//


import FirebaseAuth
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, .none)   // keep selected icon solid
                    Text("Home")
                }
                .tag(0)

            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)

            PostCreationView()
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("Post")
                }
                .tag(2)

            NotificationsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "heart.fill" : "heart")
                    Text("Activity")
                }
                .tag(3)

            ProfileView(uid: Auth.auth().currentUser?.uid ?? "")
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.circle.fill" : "person.circle")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.igPink)   // selected tab colour
        .onAppear {
            // Customise the tab bar appearance globally
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
