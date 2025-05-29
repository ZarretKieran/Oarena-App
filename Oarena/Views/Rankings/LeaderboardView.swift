//
//  LeaderboardView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct LeaderboardView: View {
    @State private var selectedScope = 0
    @State private var searchText = ""
    @State private var selectedFilter = 0
    
    let scopes = ["Global", "Regional", "Friends", "Groups"]
    let filters = ["All Ranks", "Bronze", "Silver", "Gold", "Platinum", "Elite"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Scope Selection
                Picker("Leaderboard Scope", selection: $selectedScope) {
                    ForEach(0..<scopes.count, id: \.self) { index in
                        Text(scopes[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Rank Tiers Display
                RankTiersDisplay()
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                
                // Search and Filter
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.oarenaSecondary)
                        
                        TextField("Search users...", text: $searchText)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Menu {
                        ForEach(0..<filters.count, id: \.self) { index in
                            Button(filters[index]) {
                                selectedFilter = index
                            }
                        }
                    } label: {
                        HStack {
                            Text(filters[selectedFilter])
                                .font(.caption)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .foregroundColor(.oarenaAccent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.oarenaAccent.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Leaderboard List
                ScrollView {
                    LazyVStack(spacing: 8) {
                        // Current user at top (highlighted)
                        CurrentUserRankRow()
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                        
                        // Other users
                        ForEach(1..<50) { index in
                            LeaderboardRow(rank: index + 1, isCurrentUser: false)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Rankings")
            .navigationBarTitleDisplayMode(.large)
        }
        .searchable(text: $searchText, prompt: "Search users")
    }
}

struct RankTiersDisplay: View {
    let rankTiers = [
        ("Bronze", Color.orange, "B"),
        ("Silver", Color.gray, "S"),
        ("Gold", Color.yellow, "G"),
        ("Platinum", Color.blue, "P"),
        ("Elite", Color.purple, "E")
    ]
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Rank Tiers")
                    .font(.headline)
                    .foregroundColor(.oarenaPrimary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<rankTiers.count, id: \.self) { index in
                            let tier = rankTiers[index]
                            VStack(spacing: 8) {
                                Circle()
                                    .fill(tier.1)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text(tier.2)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(index == 2 ? Color.oarenaHighlight : Color.clear, lineWidth: 3) // Highlight Gold (current user)
                                    )
                                
                                Text(tier.0)
                                    .font(.caption)
                                    .fontWeight(index == 2 ? .bold : .medium) // Bold for current tier
                                    .foregroundColor(index == 2 ? .oarenaHighlight : .oarenaSecondary)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
    }
}

struct CurrentUserRankRow: View {
    var body: some View {
        CardView(backgroundColor: Color.oarenaAccent.opacity(0.1)) {
            HStack(spacing: 12) {
                // Rank number
                Text("#15")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.oarenaHighlight)
                    .frame(width: 50, alignment: .leading)
                
                // Avatar
                Circle()
                    .fill(Color.oarenaAccent)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("Z")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                // User info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Zarret (You)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.oarenaPrimary)
                        
                        // Rank badge
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text("G")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("2k PR")
                                .font(.caption)
                                .foregroundColor(.oarenaSecondary)
                            Text("7:15.2")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaPrimary)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("5k PR")
                                .font(.caption)
                                .foregroundColor(.oarenaSecondary)
                            Text("18:42.8")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaPrimary)
                        }
                    }
                }
                
                Spacer()
                
                // RP Score
                VStack(alignment: .trailing) {
                    Text("1,485 RP")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.oarenaHighlight)
                    
                    Text("Rank Points")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                }
            }
        }
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let isCurrentUser: Bool
    
    // Sample data
    private let sampleNames = ["Alex_Rower", "FastPacer", "WaterWarrior", "RowMaster", "StrokeAce", "PowerPuller", "SpeedDemon", "AquaAthlete"]
    private let sampleTiers = [("B", Color.orange), ("S", Color.gray), ("G", Color.yellow), ("P", Color.blue), ("E", Color.purple)]
    
    var body: some View {
        HStack(spacing: 12) {
            // Rank number
            Text("#\(rank)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.oarenaSecondary)
                .frame(width: 40, alignment: .leading)
            
            // Avatar
            Circle()
                .fill(Color.oarenaAccent.opacity(0.7))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(sampleNames[rank % sampleNames.count].prefix(1)))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            // User info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(sampleNames[rank % sampleNames.count])
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.oarenaPrimary)
                    
                    // Rank badge
                    let tier = sampleTiers[rank % sampleTiers.count]
                    Circle()
                        .fill(tier.1)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Text(tier.0)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
                
                HStack(spacing: 12) {
                    Text("2k: 7:\(String(format: "%02d", 20 + rank % 40)).5")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                    
                    Text("5k: 1\(8 + rank % 3):\(String(format: "%02d", rank % 60)).2")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                }
            }
            
            Spacer()
            
            // RP Score
            VStack(alignment: .trailing) {
                Text("\(1500 - rank * 5) RP")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.oarenaPrimary)
                
                if rank <= 3 {
                    Image(systemName: rank == 1 ? "crown.fill" : rank == 2 ? "medal.fill" : "trophy.fill")
                        .foregroundColor(rank == 1 ? .yellow : rank == 2 ? .gray : .orange)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    LeaderboardView()
} 