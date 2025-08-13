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
    @State private var selectedFilter = "Gold" // Set to user's current rank
    @State private var selectedAthleteClass = "OWM" // Default to Open Weight Men
    
    let scopes = ["Global", "Regional", "Friends", "Groups"]
    let filters = ["All Ranks", "Iron", "Bronze", "Silver", "Gold", "Platinum", "Diamond", "Elite"]
    let athleteClasses = ["OWM", "OWW", "LWM", "LWW"]
    let athleteClassNames = [
        "OWM": "Open Weight Men",
        "OWW": "Open Weight Women", 
        "LWM": "Lightweight Men",
        "LWW": "Lightweight Women"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Scope Selection (remains static)
                Picker("Leaderboard Scope", selection: $selectedScope) {
                    ForEach(0..<scopes.count, id: \.self) { index in
                        Text(scopes[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Athlete Class Selection
                HStack {
                    Text("Class:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.oarenaSecondary)
                    
                    Picker("Athlete Class", selection: $selectedAthleteClass) {
                        ForEach(athleteClasses, id: \.self) { athleteClass in
                            Text(athleteClass).tag(athleteClass)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
                
                // Search and Filter (remains static)
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
                        ForEach(filters, id: \.self) { filter in
                            Button(filter) {
                                selectedFilter = filter
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedFilter)
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
                
                // Scrollable Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Rank Tiers Display (now scrollable)
                        RankTiersDisplay(selectedAthleteClass: selectedAthleteClass)
                            .padding(.horizontal)
                        
                        // Current user at top (highlighted)
                        CurrentUserRankRow(athleteClass: selectedAthleteClass)
                            .padding(.horizontal)
                        
                        // Other users
                        LazyVStack(spacing: 8) {
                            ForEach(1..<50) { index in
                                LeaderboardRow(rank: index + 1, isCurrentUser: false, athleteClass: selectedAthleteClass)
                                    .padding(.horizontal)
                            }
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
        ("Iron", Color.gray.opacity(0.8), "hammer.fill"),
        ("Bronze", Color.orange, "shield.fill"),
        ("Silver", Color.gray, "star.fill"),
        ("Gold", Color.yellow, "crown.fill"),
        ("Platinum", Color.blue, "diamond.fill"),
        ("Diamond", Color.cyan, "diamond"),
        ("Elite", Color.purple, "flame.fill")
    ]
    
    // Get user's current rank and division from UserData
    @ObservedObject private var userData = UserData.shared
    @State private var showRankingInfo = false
    
    let selectedAthleteClass: String
    
    private var currentRankIndex: Int {
        let baseRank = userData.baseRank
        return rankTiers.firstIndex { $0.0 == baseRank } ?? 2
    }
    
    private var currentDivision: String? {
        // Extract division from currentRank (e.g., "Gold III" -> "III")
        let components = userData.currentRank.components(separatedBy: " ")
        return components.count > 1 ? components[1] : nil
    }
    
    private var currentRankTier: (String, Color, String) {
        let tier = rankTiers[currentRankIndex]
        return (tier.0, tier.1, tier.2)
    }
    
    var body: some View {
        Button(action: {
            showRankingInfo = true
        }) {
            CardView {
                VStack(spacing: 16) {
                    // Header with info button
                    HStack {
                        Text("Your Current Rank")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.oarenaPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "info.circle")
                            .font(.subheadline)
                            .foregroundColor(.oarenaAccent)
                    }
                    
                    // Current rank display (large and prominent)
                    VStack(spacing: 12) {
                        // Main rank circle (larger than before)
                        ZStack {
                            Circle()
                                .fill(currentRankTier.1)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: currentRankTier.2)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                            
                            // Current rank indicator ring
                            Circle()
                                .stroke(Color.oarenaHighlight, lineWidth: 4)
                                .frame(width: 95, height: 95)
                        }
                        
                        // Rank name and division
                        VStack(spacing: 4) {
                            Text(currentRankTier.0)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.oarenaPrimary)
                            
                            if let division = currentDivision {
                                Text("Division \(division)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaSecondary)
                            }
                        }
                        
                        // Division progress (only for non-Elite ranks)
                        if currentRankIndex < rankTiers.count - 1 {
                            VStack(spacing: 8) {
                                Text("Division Progress")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaSecondary)
                                
                                // Division dots (6 divisions: VI, V, IV, III, II, I)
                                HStack(spacing: 4) {
                                    ForEach(1...6, id: \.self) { divisionNumber in
                                        let divisionRoman = romanNumeral(for: 7 - divisionNumber) // VI=1, V=2, ..., I=6
                                        let isCurrentDivision = currentDivision == divisionRoman
                                        let isPastDivision = (currentDivision != nil) && 
                                            (romanNumeralValue(currentDivision!) >= romanNumeralValue(divisionRoman))
                                        
                                        VStack(spacing: 2) {
                                            Circle()
                                                .fill(isCurrentDivision ? Color.oarenaHighlight : 
                                                      (isPastDivision ? Color.oarenaAccent.opacity(0.6) : 
                                                       Color.oarenaSecondary.opacity(0.3)))
                                                .frame(width: isCurrentDivision ? 10 : 8, 
                                                       height: isCurrentDivision ? 10 : 8)
                                            
                                            Text(divisionRoman)
                                                .font(.caption2)
                                                .fontWeight(isCurrentDivision ? .bold : .medium)
                                                .foregroundColor(isCurrentDivision ? .oarenaHighlight : 
                                                                (isPastDivision ? .oarenaAccent : .oarenaSecondary.opacity(0.7)))
                                        }
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }
                        
                        // Tap instruction
                        Text("Tap to view rank progression")
                            .font(.caption)
                            .foregroundColor(.oarenaAccent)
                            .padding(.top, 4)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showRankingInfo) {
            RankingSystemInfoView(athleteClass: selectedAthleteClass)
        }
    }
    
    private func romanNumeral(for number: Int) -> String {
        switch number {
        case 1: return "VI"
        case 2: return "V"  
        case 3: return "IV"
        case 4: return "III"
        case 5: return "II"
        case 6: return "I"
        default: return ""
        }
    }
    
    private func romanNumeralValue(_ numeral: String) -> Int {
        switch numeral {
        case "VI": return 1
        case "V": return 2
        case "IV": return 3
        case "III": return 4
        case "II": return 5
        case "I": return 6
        default: return 0
        }
    }
}

struct CurrentUserRankRow: View {
    @ObservedObject private var userData = UserData.shared
    
    let athleteClass: String
    
    // Get class-specific sample times for Gold III rank
    private var sampleTimes: (String, String) {
        switch athleteClass {
        case "OWM": return ("6:30.2", "17:58.4")
        case "OWW": return ("7:15.2", "20:13.8") 
        case "LWM": return ("6:45.2", "18:43.1")
        case "LWW": return ("7:30.8", "20:58.6")
        default: return ("6:30.2", "17:58.4")
        }
    }
    
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
                        VStack(alignment: .leading) {
                            Text("Zarret (You)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.oarenaPrimary)
                            
                            Text(athleteClass)
                                .font(.caption)
                                .foregroundColor(.oarenaSecondary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.oarenaAccent.opacity(0.2))
                                .cornerRadius(4)
                        }
                        
                        Spacer()
                        
                        // Rank badge with division
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.yellow) // Gold color
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Image(systemName: "crown.fill")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                            
                            Text("III")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.oarenaPrimary)
                        }
                    }
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("2k PR")
                                .font(.caption)
                                .foregroundColor(.oarenaSecondary)
                            Text(sampleTimes.0)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaPrimary)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("5k PR")
                                .font(.caption)
                                .foregroundColor(.oarenaSecondary)
                            Text(sampleTimes.1)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaPrimary)
                        }
                    }
                }
                
                Spacer()
                
                // DP Score
                VStack(alignment: .trailing) {
                    Text("1,485 DP")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.oarenaHighlight)
                    
                    Text("Dominance Points")
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
    let athleteClass: String
    
    // Sample data with new 7-tier system
    private let sampleNames = ["Alex_Rower", "FastPacer", "WaterWarrior", "RowMaster", "StrokeAce", "PowerPuller", "SpeedDemon", "AquaAthlete", "EliteRower", "DiamondStroke", "PlatinumPace", "GoldRush", "SilverBolt", "BronzeBeast", "IronWill"]
    
    private let rankTiers = [
        ("Iron", Color.gray.opacity(0.8), "hammer.fill"),
        ("Bronze", Color.orange, "shield.fill"),
        ("Silver", Color.gray, "star.fill"),
        ("Gold", Color.yellow, "crown.fill"),
        ("Platinum", Color.blue, "diamond.fill"),
        ("Diamond", Color.cyan, "diamond"),
        ("Elite", Color.purple, "flame.fill")
    ]
    
    private let divisions = ["VI", "V", "IV", "III", "II", "I"]
    
    // Generate rank for this row
    private var userRank: (String, String, Color, String) {
        let tierIndex = min(rank / 6, rankTiers.count - 1)
        let divisionIndex = rank % 6
        let tier = rankTiers[tierIndex]
        let division = tierIndex == rankTiers.count - 1 ? "" : divisions[divisionIndex] // Elite has no divisions
        
        return (tier.0, division, tier.1, tier.2)
    }
    
    // Generate athlete class specific base times
    private func getBaseTimes(for athleteClass: String) -> (Int, Int) {
        switch athleteClass {
        case "OWM": return (360, 990)  // 6:00 2k, 16:30 5k base times for Elite
        case "OWW": return (405, 1125) // 6:45 2k, 18:45 5k base times for Elite  
        case "LWM": return (375, 1035) // 6:15 2k, 17:15 5k base times for Elite
        case "LWW": return (420, 1170) // 7:00 2k, 19:30 5k base times for Elite
        default: return (360, 990)
        }
    }
    
    // Get athlete class for this row (simulate mixed leaderboard)
    private var rowAthleteClass: String {
        let classes = ["OWM", "OWW", "LWM", "LWW"]
        return classes[rank % classes.count]
    }
    
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
                    VStack(alignment: .leading) {
                        Text(sampleNames[rank % sampleNames.count])
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.oarenaPrimary)
                        
                        Text(rowAthleteClass)
                            .font(.caption2)
                            .foregroundColor(.oarenaSecondary)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.oarenaAccent.opacity(0.15))
                            .cornerRadius(3)
                    }
                    
                    Spacer()
                    
                    // Rank badge with proper 7-tier system
                    HStack(spacing: 2) {
                        Circle()
                            .fill(userRank.2)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Image(systemName: userRank.3)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                        
                        if !userRank.1.isEmpty {
                            Text(userRank.1)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    // Generate realistic times based on rank and athlete class
                    let baseTimes = getBaseTimes(for: rowAthleteClass)
                    let baseTime2k = baseTimes.0 + rank * 2 // Add 2 seconds per rank
                    let baseTime5k = baseTimes.1 + rank * 6 // Add 6 seconds per rank
                    
                    Text("2k: \(formatTime(baseTime2k))")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                    
                    Text("5k: \(formatTime(baseTime5k))")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                }
            }
            
            Spacer()
            
            // DP Score and position indicators
            VStack(alignment: .trailing) {
                Text("\(1500 - rank * 5) DP")
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
    
    // Helper function to format time in mm:ss.s format
    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        let tenths = Int.random(in: 0...9)
        return String(format: "%d:%02d.%d", minutes, seconds, tenths)
    }
}

struct RankingSystemInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var userData = UserData.shared
    
    @State private var selectedAthleteClass: String
    
    // Initialize with the passed athlete class
    init(athleteClass: String) {
        self._selectedAthleteClass = State(initialValue: athleteClass)
    }
    
    // Get athlete class full name
    private var athleteClassName: String {
        switch selectedAthleteClass {
        case "OWM": return "Open Weight Men"
        case "OWW": return "Open Weight Women"
        case "LWM": return "Lightweight Men"
        case "LWW": return "Lightweight Women"
        default: return "Open Weight Men"
        }
    }
    
    // All rank tiers with their properties
    private let rankTiers = [
        ("Iron", Color.gray.opacity(0.8), "hammer.fill"),
        ("Bronze", Color.orange, "shield.fill"),
        ("Silver", Color.gray, "star.fill"),
        ("Gold", Color.yellow, "crown.fill"),
        ("Platinum", Color.blue, "diamond.fill"),
        ("Diamond", Color.cyan, "diamond"),
        ("Elite", Color.purple, "flame.fill")
    ]
    
    private let divisions = ["VI", "V", "IV", "III", "II", "I"]
    
    // Complete time requirements for all athlete classes and all ranks
    private func getTimeRequirement(rank: String, division: String, athleteClass: String) -> (String, String) {
        // Based on Ranked_System.md time tables
        switch athleteClass {
        case "OWM":
            return getOWMTimes(rank: rank, division: division)
        case "OWW":
            return getOWWTimes(rank: rank, division: division)
        case "LWM":
            return getLWMTimes(rank: rank, division: division)
        case "LWW":
            return getLWWTimes(rank: rank, division: division)
        default:
            return getOWMTimes(rank: rank, division: division)
        }
    }
    
    // Open Weight Men times
    private func getOWMTimes(rank: String, division: String) -> (String, String) {
        switch rank {
        case "Iron":
            switch division {
            case "VI": return ("9:20.0", "26:38.0")
            case "V": return ("9:00.0", "25:34.0")
            case "IV": return ("8:42.0", "24:43.0")
            case "III": return ("8:26.0", "23:58.0")
            case "II": return ("8:12.0", "23:20.0")
            case "I": return ("8:00.0", "22:48.0")
            default: return ("9:20.0", "26:38.0")
            }
        case "Bronze":
            switch division {
            case "VI": return ("7:51.0", "22:19.0")
            case "V": return ("7:42.0", "21:50.0")
            case "IV": return ("7:34.0", "21:24.0")
            case "III": return ("7:26.0", "20:58.0")
            case "II": return ("7:19.0", "20:36.0")
            case "I": return ("7:12.0", "20:14.0")
            default: return ("7:51.0", "22:19.0")
            }
        case "Silver":
            switch division {
            case "VI": return ("7:06.0", "19:55.0")
            case "V": return ("7:00.0", "19:36.0")
            case "IV": return ("6:55.0", "19:20.0")
            case "III": return ("6:50.0", "19:04.0")
            case "II": return ("6:46.0", "18:51.0")
            case "I": return ("6:42.0", "18:38.0")
            default: return ("7:06.0", "19:55.0")
            }
        case "Gold":
            switch division {
            case "VI": return ("6:39.0", "18:28.0")
            case "V": return ("6:36.0", "18:18.0")
            case "IV": return ("6:33.0", "18:08.0")
            case "III": return ("6:30.0", "17:58.0")
            case "II": return ("6:28.0", "17:52.0")
            case "I": return ("6:26.0", "17:46.0")
            default: return ("6:39.0", "18:28.0")
            }
        case "Platinum":
            switch division {
            case "VI": return ("6:24.0", "17:40.0")
            case "V": return ("6:22.0", "17:34.0")
            case "IV": return ("6:20.0", "17:28.0")
            case "III": return ("6:18.0", "17:22.0")
            case "II": return ("6:17.0", "17:19.0")
            case "I": return ("6:16.0", "17:16.0")
            default: return ("6:24.0", "17:40.0")
            }
        case "Diamond":
            switch division {
            case "VI": return ("6:15.0", "17:13.0")
            case "V": return ("6:14.0", "17:10.0")
            case "IV": return ("6:13.0", "17:07.0")
            case "III": return ("6:12.0", "17:04.0")
            case "II": return ("6:11.0", "17:01.0")
            case "I": return ("6:10.0", "16:58.0")
            default: return ("6:15.0", "17:13.0")
            }
        case "Elite":
            return ("6:00.0", "16:32.0")
        default:
            return ("9:20.0", "26:38.0")
        }
    }
    
    // Open Weight Women times (OWM + 45 seconds 2k, + 2:15 5k)
    private func getOWWTimes(rank: String, division: String) -> (String, String) {
        switch rank {
        case "Iron":
            switch division {
            case "VI": return ("10:05.0", "28:53.0")
            case "V": return ("9:45.0", "27:49.0")
            case "IV": return ("9:27.0", "26:58.0")
            case "III": return ("9:11.0", "26:13.0")
            case "II": return ("8:57.0", "25:35.0")
            case "I": return ("8:45.0", "25:03.0")
            default: return ("10:05.0", "28:53.0")
            }
        case "Bronze":
            switch division {
            case "VI": return ("8:36.0", "24:34.0")
            case "V": return ("8:27.0", "24:05.0")
            case "IV": return ("8:19.0", "23:39.0")
            case "III": return ("8:11.0", "23:13.0")
            case "II": return ("8:04.0", "22:51.0")
            case "I": return ("7:57.0", "22:29.0")
            default: return ("8:36.0", "24:34.0")
            }
        case "Silver":
            switch division {
            case "VI": return ("7:51.0", "22:10.0")
            case "V": return ("7:45.0", "21:51.0")
            case "IV": return ("7:40.0", "21:35.0")
            case "III": return ("7:35.0", "21:19.0")
            case "II": return ("7:31.0", "21:06.0")
            case "I": return ("7:27.0", "20:53.0")
            default: return ("7:51.0", "22:10.0")
            }
        case "Gold":
            switch division {
            case "VI": return ("7:24.0", "20:43.0")
            case "V": return ("7:21.0", "20:33.0")
            case "IV": return ("7:18.0", "20:23.0")
            case "III": return ("7:15.0", "20:13.0")
            case "II": return ("7:13.0", "20:07.0")
            case "I": return ("7:11.0", "20:01.0")
            default: return ("7:24.0", "20:43.0")
            }
        case "Platinum":
            switch division {
            case "VI": return ("7:09.0", "19:55.0")
            case "V": return ("7:07.0", "19:49.0")
            case "IV": return ("7:05.0", "19:43.0")
            case "III": return ("7:03.0", "19:37.0")
            case "II": return ("7:02.0", "19:34.0")
            case "I": return ("7:01.0", "19:31.0")
            default: return ("7:09.0", "19:55.0")
            }
        case "Diamond":
            switch division {
            case "VI": return ("7:00.0", "19:28.0")
            case "V": return ("6:59.0", "19:25.0")
            case "IV": return ("6:58.0", "19:22.0")
            case "III": return ("6:57.0", "19:19.0")
            case "II": return ("6:56.0", "19:16.0")
            case "I": return ("6:55.0", "19:13.0")
            default: return ("7:00.0", "19:28.0")
            }
        case "Elite":
            return ("6:45.0", "18:47.0")
        default:
            return ("10:05.0", "28:53.0")
        }
    }
    
    // Lightweight Men times (OWM + 15 seconds 2k, + 45 seconds 5k)
    private func getLWMTimes(rank: String, division: String) -> (String, String) {
        switch rank {
        case "Iron":
            switch division {
            case "VI": return ("9:35.0", "27:23.0")
            case "V": return ("9:15.0", "26:19.0")
            case "IV": return ("8:57.0", "25:28.0")
            case "III": return ("8:41.0", "24:43.0")
            case "II": return ("8:27.0", "24:05.0")
            case "I": return ("8:15.0", "23:33.0")
            default: return ("9:35.0", "27:23.0")
            }
        case "Bronze":
            switch division {
            case "VI": return ("8:06.0", "23:04.0")
            case "V": return ("7:57.0", "22:35.0")
            case "IV": return ("7:49.0", "22:09.0")
            case "III": return ("7:41.0", "21:43.0")
            case "II": return ("7:34.0", "21:21.0")
            case "I": return ("7:27.0", "20:59.0")
            default: return ("8:06.0", "23:04.0")
            }
        case "Silver":
            switch division {
            case "VI": return ("7:21.0", "20:40.0")
            case "V": return ("7:15.0", "20:21.0")
            case "IV": return ("7:10.0", "20:05.0")
            case "III": return ("7:05.0", "19:49.0")
            case "II": return ("7:01.0", "19:36.0")
            case "I": return ("6:57.0", "19:23.0")
            default: return ("7:21.0", "20:40.0")
            }
        case "Gold":
            switch division {
            case "VI": return ("6:54.0", "19:13.0")
            case "V": return ("6:51.0", "19:03.0")
            case "IV": return ("6:48.0", "18:53.0")
            case "III": return ("6:45.0", "18:43.0")
            case "II": return ("6:43.0", "18:37.0")
            case "I": return ("6:41.0", "18:31.0")
            default: return ("6:54.0", "19:13.0")
            }
        case "Platinum":
            switch division {
            case "VI": return ("6:39.0", "18:25.0")
            case "V": return ("6:37.0", "18:19.0")
            case "IV": return ("6:35.0", "18:13.0")
            case "III": return ("6:33.0", "18:07.0")
            case "II": return ("6:32.0", "18:04.0")
            case "I": return ("6:31.0", "18:01.0")
            default: return ("6:39.0", "18:25.0")
            }
        case "Diamond":
            switch division {
            case "VI": return ("6:30.0", "17:58.0")
            case "V": return ("6:29.0", "17:55.0")
            case "IV": return ("6:28.0", "17:52.0")
            case "III": return ("6:27.0", "17:49.0")
            case "II": return ("6:26.0", "17:46.0")
            case "I": return ("6:25.0", "17:43.0")
            default: return ("6:30.0", "17:58.0")
            }
        case "Elite":
            return ("6:15.0", "17:17.0")
        default:
            return ("9:35.0", "27:23.0")
        }
    }
    
    // Lightweight Women times (OWM + 60 seconds 2k, + 3 minutes 5k)
    private func getLWWTimes(rank: String, division: String) -> (String, String) {
        switch rank {
        case "Iron":
            switch division {
            case "VI": return ("10:20.0", "29:38.0")
            case "V": return ("10:00.0", "28:34.0")
            case "IV": return ("9:42.0", "27:43.0")
            case "III": return ("9:26.0", "26:58.0")
            case "II": return ("9:12.0", "26:20.0")
            case "I": return ("9:00.0", "25:48.0")
            default: return ("10:20.0", "29:38.0")
            }
        case "Bronze":
            switch division {
            case "VI": return ("8:51.0", "25:19.0")
            case "V": return ("8:42.0", "24:50.0")
            case "IV": return ("8:34.0", "24:24.0")
            case "III": return ("8:26.0", "23:58.0")
            case "II": return ("8:19.0", "23:36.0")
            case "I": return ("8:12.0", "23:14.0")
            default: return ("8:51.0", "25:19.0")
            }
        case "Silver":
            switch division {
            case "VI": return ("8:06.0", "22:55.0")
            case "V": return ("8:00.0", "22:36.0")
            case "IV": return ("7:55.0", "22:20.0")
            case "III": return ("7:50.0", "22:04.0")
            case "II": return ("7:46.0", "21:51.0")
            case "I": return ("7:42.0", "21:38.0")
            default: return ("8:06.0", "22:55.0")
            }
        case "Gold":
            switch division {
            case "VI": return ("7:39.0", "21:28.0")
            case "V": return ("7:36.0", "21:18.0")
            case "IV": return ("7:33.0", "21:08.0")
            case "III": return ("7:30.0", "20:58.0")
            case "II": return ("7:28.0", "20:52.0")
            case "I": return ("7:26.0", "20:46.0")
            default: return ("7:39.0", "21:28.0")
            }
        case "Platinum":
            switch division {
            case "VI": return ("7:24.0", "20:40.0")
            case "V": return ("7:22.0", "20:34.0")
            case "IV": return ("7:20.0", "20:28.0")
            case "III": return ("7:18.0", "20:22.0")
            case "II": return ("7:17.0", "20:19.0")
            case "I": return ("7:16.0", "20:16.0")
            default: return ("7:24.0", "20:40.0")
            }
        case "Diamond":
            switch division {
            case "VI": return ("7:15.0", "20:13.0")
            case "V": return ("7:14.0", "20:10.0")
            case "IV": return ("7:13.0", "20:07.0")
            case "III": return ("7:12.0", "20:04.0")
            case "II": return ("7:11.0", "20:01.0")
            case "I": return ("7:10.0", "19:58.0")
            default: return ("7:15.0", "20:13.0")
            }
        case "Elite":
            return ("7:00.0", "19:32.0")
        default:
            return ("10:20.0", "29:38.0")
        }
    }
    
    // Generate all 37 tiers for the timeline with times
    private var allTiers: [(String, String, Color, String, Int, String, String)] {
        var tiers: [(String, String, Color, String, Int, String, String)] = []
        var tierNumber = 1
        
        // Generate all rank divisions (Iron VI through Diamond I)
        for (rankIndex, rank) in rankTiers.enumerated() {
            if rankIndex < rankTiers.count - 1 { // Not Elite
                for division in divisions {
                    let times = getTimeRequirement(rank: rank.0, division: division, athleteClass: selectedAthleteClass)
                    tiers.append((rank.0, division, rank.1, rank.2, tierNumber, times.0, times.1))
                    tierNumber += 1
                }
            }
        }
        
        // Add Elite (no divisions)
        let eliteRank = rankTiers.last!
        let eliteTimes = getTimeRequirement(rank: eliteRank.0, division: "", athleteClass: selectedAthleteClass)
        tiers.append((eliteRank.0, "", eliteRank.1, eliteRank.2, tierNumber, eliteTimes.0, eliteTimes.1))
        
        return tiers.reversed() // Elite at top, Iron VI at bottom
    }
    
    // Get user's current position in the timeline
    private var currentUserTierIndex: Int {
        let baseRank = userData.baseRank
        let division = userData.currentRank.components(separatedBy: " ").count > 1 ? 
                      userData.currentRank.components(separatedBy: " ")[1] : ""
        
        return allTiers.firstIndex { tier in
            tier.0 == baseRank && (tier.1 == division || (tier.1.isEmpty && division.isEmpty))
        } ?? 0
    }

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How Rankings Work")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.oarenaPrimary)
                            
                            Text("Oarena uses a performance-gated ranking system with 37 progression tiers")
                                .font(.subheadline)
                                .foregroundColor(.oarenaSecondary)
                            
                            // Interactive Athlete Class Selector
                            HStack {
                                Text("Viewing for:")
                                    .font(.subheadline)
                                    .foregroundColor(.oarenaSecondary)
                                
                                Menu {
                                    Button("Open Weight Men") { selectedAthleteClass = "OWM" }
                                    Button("Open Weight Women") { selectedAthleteClass = "OWW" }
                                    Button("Lightweight Men") { selectedAthleteClass = "LWM" }
                                    Button("Lightweight Women") { selectedAthleteClass = "LWW" }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(athleteClassName)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                    }
                                    .foregroundColor(.oarenaAccent)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.oarenaAccent.opacity(0.1))
                                    .cornerRadius(6)
                                }
                            }
                            .padding(.top, 8)
                        }
                        
                        // Rank Progression Timeline
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Your Rank Journey", icon: "map.fill")
                            
                            InfoCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Complete Progression Path")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.oarenaPrimary)
                                    
                                    Text("Track your journey through all 37 progression tiers with time requirements for \(athleteClassName). Your current position is highlighted.")
                                        .font(.body)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    // Timeline Container
                                    ScrollView(.vertical, showsIndicators: false) {
                                        VStack(spacing: 0) {
                                            ForEach(Array(allTiers.enumerated()), id: \.element.4) { index, tier in
                                                RankTimelineRow(
                                                    tier: tier,
                                                    isCurrentRank: index == currentUserTierIndex,
                                                    isPastRank: index > currentUserTierIndex,
                                                    isFutureRank: index < currentUserTierIndex,
                                                    isLastItem: index == allTiers.count - 1
                                                )
                                                .id(tier.4) // Use tier number as ID for scrolling
                                            }
                                        }
                                        .padding(.vertical, 8)
                                    }
                                    .frame(maxHeight: 400) // Limit height to make it scrollable
                                }
                            }
                        }
                        
                        // Core Principle Section
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Core Principle", icon: "target")
                            
                            InfoCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Performance Gates")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.oarenaPrimary)
                                    
                                    Text("Your rank is **primarily determined by your verified erg times**. Faster times unlock higher ranks - no amount of training alone can bypass performance requirements.")
                                        .font(.body)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    Text("Dominance Points")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.oarenaPrimary)
                                        .padding(.top, 8)
                                    
                                    Text("DP fine-tune your position within unlocked performance tiers through training consistency and race performance.")
                                        .font(.body)
                                        .foregroundColor(.oarenaSecondary)
                                }
                            }
                        }
                        
                        // DP System Section
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Dominance Points (DP)", icon: "star.fill")
                            
                            InfoCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    DPMethodCard(
                                        title: "Training Consistency",
                                        amount: "+5-15 DP daily",
                                        description: "Diminishing returns after 7-day streaks",
                                        bonus: "+25 DP weekly streak bonus",
                                        limitation: "Max +200 DP per rank from training"
                                    )
                                    
                                    Divider()
                                    
                                    DPMethodCard(
                                        title: "Race Performance",
                                        amount: "+50-200 DP (wins)",
                                        description: "Based on opponent rank differential",
                                        bonus: "+50 DP for new personal bests",
                                        limitation: "-25-100 DP for losses"
                                    )
                                }
                            }
                        }
                        
                        // Example Section
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Example", icon: "lightbulb.fill")
                            
                            InfoCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    let exampleTime = selectedAthleteClass == "OWM" ? "8:30" : 
                                                    selectedAthleteClass == "OWW" ? "9:15" :
                                                    selectedAthleteClass == "LWM" ? "8:45" : "9:30"
                                    let maxRank = "Iron II"
                                    let nextTime = selectedAthleteClass == "OWM" ? "7:51" :
                                                 selectedAthleteClass == "OWW" ? "8:36" :
                                                 selectedAthleteClass == "LWM" ? "8:06" : "8:51"
                                    
                                    Text("A \(athleteClassName.lowercased()) rower with a \(exampleTime) 2k time can reach \(maxRank) maximum. No amount of training alone can reach Bronze - they need a \(nextTime) 2k time first.")
                                        .font(.body)
                                        .foregroundColor(.oarenaSecondary)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(Color.oarenaAccent.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .onAppear {
                    // Auto-scroll to user's current rank with slight delay for smooth animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            proxy.scrollTo(allTiers[currentUserTierIndex].4, anchor: .center)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.oarenaAccent)
                }
            }
        }
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.oarenaAccent)
                .font(.title3)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.oarenaPrimary)
        }
    }
}

struct InfoCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
    }
}

struct DPMethodCard: View {
    let title: String
    let amount: String
    let description: String
    let bonus: String
    let limitation: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.oarenaPrimary)
                
                Spacer()
                
                Text(amount)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.oarenaHighlight)
            }
            
            Text(description)
                .font(.body)
                .foregroundColor(.oarenaSecondary)
            
            if !bonus.isEmpty {
                Text("• \(bonus)")
                    .font(.caption)
                    .foregroundColor(.oarenaAccent)
            }
            
            if !limitation.isEmpty {
                Text("• \(limitation)")
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
            }
        }
    }
}

struct RankTimelineRow: View {
    let tier: (String, String, Color, String, Int, String, String) // (rank, division, color, icon, tierNumber, 2kTime, 5kTime)
    let isCurrentRank: Bool
    let isPastRank: Bool
    let isFutureRank: Bool
    let isLastItem: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Timeline visual elements (left side)
            VStack(spacing: 0) {
                // Connection line from above (except for first item)
                if tier.4 < 37 { // Not the first item (Elite)
                    Rectangle()
                        .fill(isPastRank ? Color.oarenaAccent : Color.oarenaSecondary.opacity(0.3))
                        .frame(width: 3, height: 20)
                }
                
                // Rank circle/badge
                ZStack {
                    Circle()
                        .fill(isCurrentRank ? tier.2 : 
                              (isPastRank ? tier.2.opacity(0.8) : tier.2.opacity(0.3)))
                        .frame(width: isCurrentRank ? 50 : 40, height: isCurrentRank ? 50 : 40)
                        .overlay(
                            Image(systemName: tier.3)
                                .font(isCurrentRank ? .title3 : .subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    // Special current rank indicator
                    if isCurrentRank {
                        Circle()
                            .stroke(Color.oarenaHighlight, lineWidth: 3)
                            .frame(width: 60, height: 60)
                    }
                }
                
                // Connection line to below (except for last item)
                if !isLastItem {
                    Rectangle()
                        .fill(isPastRank ? Color.oarenaAccent : Color.oarenaSecondary.opacity(0.3))
                        .frame(width: 3, height: 20)
                }
            }
            .frame(width: 60) // Fixed width for timeline column
            
            // Rank information (right side)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    // Rank name and division
                    VStack(alignment: .leading, spacing: 2) {
                        Text(tier.0)
                            .font(isCurrentRank ? .headline : .subheadline)
                            .fontWeight(isCurrentRank ? .bold : .semibold)
                            .foregroundColor(isCurrentRank ? .oarenaPrimary : 
                                           (isPastRank ? .oarenaPrimary : .oarenaSecondary))
                        
                        if !tier.1.isEmpty { // Has division
                            Text("Division \(tier.1)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(isCurrentRank ? .oarenaHighlight : 
                                               (isPastRank ? .oarenaAccent : .oarenaSecondary.opacity(0.7)))
                        }
                    }
                    
                    Spacer()
                    
                    // Tier number indicator
                    Text("#\(tier.4)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.oarenaSecondary.opacity(0.7))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.oarenaSecondary.opacity(0.1))
                        .cornerRadius(4)
                }
                
                // Time requirements
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("2k Time")
                            .font(.caption2)
                            .foregroundColor(.oarenaSecondary.opacity(0.8))
                        Text(tier.5) // 2k time
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(isCurrentRank ? .oarenaHighlight : 
                                           (isPastRank ? .oarenaAccent : .oarenaSecondary))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("5k Time")
                            .font(.caption2)
                            .foregroundColor(.oarenaSecondary.opacity(0.8))
                        Text(tier.6) // 5k time
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(isCurrentRank ? .oarenaHighlight : 
                                           (isPastRank ? .oarenaAccent : .oarenaSecondary))
                    }
                    
                    Spacer()
                }
                .padding(.top, 2)
                
                // Current rank status indicators
                if isCurrentRank {
                    HStack(spacing: 8) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundColor(.oarenaHighlight)
                        
                        Text("Current Rank")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.oarenaHighlight)
                        
                        Spacer()
                    }
                    .padding(.top, 2)
                } else if isPastRank {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.oarenaAccent)
                        
                        Text("Achieved")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.oarenaAccent)
                        
                        Spacer()
                    }
                    .padding(.top, 2)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isCurrentRank ? Color.oarenaAccent.opacity(0.1) : 
                          (isPastRank ? Color.oarenaAccent.opacity(0.05) : Color.clear))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isCurrentRank ? Color.oarenaHighlight.opacity(0.3) : Color.clear, 
                           lineWidth: isCurrentRank ? 2 : 0)
            )
            
            Spacer()
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    LeaderboardView()
} 