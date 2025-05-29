//
//  MainTabView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
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
        .environmentObject(TabSwitcher(selectedTab: $selectedTab))
    }
}

class TabSwitcher: ObservableObject {
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }
    
    func switchToTab(_ tab: Int) {
        selectedTab = tab
    }
} 