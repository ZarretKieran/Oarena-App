//
//  MainTabView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            SoloTrainingView()
                .tabItem {
                    Image(systemName: "oar.2.crossed")
                    Text("Train")
                }
                .tag(1)
            
            RaceHubView()
                .tabItem {
                    Image(systemName: "flag.checkered")
                    Text("Race")
                }
                .tag(2)
            
            LeaderboardView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Rankings")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.oarenaAccent)
    }
} 