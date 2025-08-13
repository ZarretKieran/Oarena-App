//
//  HomeView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var userData = UserData.shared
    @EnvironmentObject var tabSwitcher: TabSwitcher
    @State private var showingWorkoutHistory = false
    @State private var showingTicketStore = false
    @State private var showingRaceDetail = false
    @State private var showingWorkoutDetail = false
    @State private var selectedWorkout: WorkoutData?
    @State private var selectedRace: RaceData?
    
    // Sample recent workouts data
    private let recentWorkouts: [WorkoutData] = [
        WorkoutData(
            workoutType: "2000m Row",
            date: "Yesterday, 2:30 PM",
            totalTime: "7:32.0",
            distance: "2000m",
            avgPace: "1:53.0",
            avgPower: "285W",
            avgSPM: "32",
            maxHeartRate: "185 bpm",
            calories: "312",
            ticketsEarned: 8,
            rankPointsGained: 12,
            timeAgo: "Yesterday"
        ),
        WorkoutData(
            workoutType: "5000m Steady State",
            date: "2 days ago, 7:00 AM",
            totalTime: "21:25.0",
            distance: "5000m",
            avgPace: "2:08.5",
            avgPower: "195W",
            avgSPM: "24",
            maxHeartRate: "165 bpm",
            calories: "485",
            ticketsEarned: 15,
            rankPointsGained: 18,
            timeAgo: "2 days ago"
        ),
        WorkoutData(
            workoutType: "20 Min Time Trial",
            date: "4 days ago, 6:15 PM",
            totalTime: "20:00.0",
            distance: "4850m",
            avgPace: "2:04.0",
            avgPower: "220W",
            avgSPM: "28",
            maxHeartRate: "178 bpm",
            calories: "420",
            ticketsEarned: 12,
            rankPointsGained: 15,
            timeAgo: "4 days ago"
        )
    ]
    
    // Get all featured races for home preview - should match Race tab
    private var previewRaces: [RaceData] {
        RaceData.sampleFeaturedRaces
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome & User Stats Card
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("What's up, \(userData.username)!")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oarenaPrimary)
                                    
                                    Text("Current Rank: \(userData.currentRank)")
                                        .font(.subheadline)
                                        .foregroundColor(.oarenaSecondary)
                                }
                                
                                Spacer()
                                
                                // Rank badge placeholder
                                Circle()
                                    .fill(Color.oarenaHighlight)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Text("G3")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    )
                            }
                            
                            Divider()
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("2k PR")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                    Text("7:15.2")
                                        .font(.headline)
                                        .foregroundColor(.oarenaPrimary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    Text("5k PR")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                    Text("18:42.8")
                                        .font(.headline)
                                        .foregroundColor(.oarenaPrimary)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Quick Start Actions Card
                    CardView {
                        VStack(spacing: 16) {
                            Text("Quick Start")
                                .font(.headline)
                                .foregroundColor(.oarenaPrimary)
                            
                            HStack(spacing: 12) {
                                Button(action: {
                                    // Navigate to Train tab and pre-fill "Just Row" (index 0)
                                    userData.setWorkoutType(0)
                                    tabSwitcher.switchToTab(1)
                                }) {
                                    HStack {
                                        Image(systemName: "figure.rowing")
                                        Text("Start Solo Row")
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.oarenaAccent)
                                    .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    // Navigate to Race tab
                                    tabSwitcher.switchToTab(2)
                                }) {
                                    HStack {
                                        Image(systemName: "flag.checkered")
                                        Text("Find a Race")
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.oarenaHighlight)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Featured Races Section
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Featured Races")
                                .font(.headline)
                                .foregroundColor(.oarenaPrimary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(previewRaces) { race in
                                        RacePreviewCard(race: race)
                                            .onTapGesture {
                                                selectedRace = race
                                                showingRaceDetail = true
                                            }
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Your Upcoming Races Section
                    if !userData.upcomingJoinedRaces.isEmpty {
                        CardView {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Your upcoming races")
                                        .font(.headline)
                                        .foregroundColor(.oarenaPrimary)
                                    
                                    Spacer()
                                    
                                    Button("View All") {
                                        // Navigate to My Races tab (upcoming section)
                                        tabSwitcher.switchToRaceTab(section: 2)
                                    }
                                    .font(.caption)
                                    .foregroundColor(.oarenaAccent)
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Array(userData.upcomingJoinedRaces.prefix(5))) { race in
                                            RacePreviewCard(race: race)
                                                .onTapGesture {
                                                    selectedRace = race
                                                    showingRaceDetail = true
                                                }
                                        }
                                    }
                                    .padding(.horizontal, 4)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Recent Workouts Cards
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Recent Workouts")
                                    .font(.headline)
                                    .foregroundColor(.oarenaPrimary)
                                
                                Spacer()
                                
                                Button("View All") {
                                    showingWorkoutHistory = true
                                }
                                .font(.caption)
                                .foregroundColor(.oarenaAccent)
                            }
                            
                            LazyVStack(spacing: 12) {
                                ForEach(recentWorkouts) { workout in
                                    WorkoutCard(workout: workout)
                                        .onTapGesture {
                                            selectedWorkout = workout
                                            showingWorkoutDetail = true
                                        }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                trailing: Button(action: {
                    showingTicketStore = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "ticket.fill")
                            .foregroundColor(.oarenaAction)
                        Text("\(userData.ticketCount)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.oarenaPrimary)
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.oarenaAction)
                            .font(.caption)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.oarenaAction.opacity(0.1))
                    .cornerRadius(16)
                }
            )
        }
        .sheet(isPresented: $showingWorkoutHistory) {
            WorkoutHistoryView()
        }
        .sheet(isPresented: $showingTicketStore) {
            TicketStoreView()
        }
        .sheet(isPresented: $showingRaceDetail) {
            if let race = selectedRace {
                RaceDetailView(race: race)
            }
        }
        .sheet(isPresented: $showingWorkoutDetail) {
            if let workout = selectedWorkout {
                WorkoutSummaryView(
                    workoutType: workout.workoutType,
                    date: workout.date,
                    totalTime: workout.totalTime,
                    distance: workout.distance,
                    avgPace: workout.avgPace,
                    avgPower: workout.avgPower,
                    avgSPM: workout.avgSPM,
                    maxHeartRate: workout.maxHeartRate,
                    calories: workout.calories,
                    ticketsEarned: workout.ticketsEarned,
                    rankPointsGained: workout.rankPointsGained
                )
            }
        }
    }
}

struct WorkoutCard: View {
    let workout: WorkoutData
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.workoutType)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.oarenaPrimary)
                
                Text(workout.summary)
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
                
                HStack {
                    Text(workout.timeAgo)
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                    
                    Text("Tap to view")
                        .font(.caption)
                        .foregroundColor(.oarenaAccent)
                        .italic()
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "ticket.fill")
                        .foregroundColor(.oarenaAction)
                        .font(.caption)
                    Text("\(workout.ticketsEarned)")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                }
                
                Text("Tickets")
                    .font(.caption2)
                    .foregroundColor(.oarenaSecondary)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle()) // Makes entire card tappable
    }
}

struct RacePreviewCard: View {
    let race: RaceData
    @ObservedObject private var userData = UserData.shared
    
    private var userRaceStatus: RaceUserStatus {
        userData.getUserRaceStatus(race.id)
    }
    
    private var hasJoined: Bool {
        userRaceStatus != .notJoined
    }
    
    var body: some View {
        CardView(backgroundColor: hasJoined ? Color.oarenaAccent.opacity(0.15) : Color.oarenaAccent.opacity(0.05)) {
            VStack(alignment: .leading, spacing: 10) {
                // Header with title and joined badge
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(race.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.oarenaPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Text("\(race.raceType) • \(race.format)")
                            .font(.caption)
                            .foregroundColor(.oarenaHighlight)
                    }
                    
                    Spacer()
                    
                    if userRaceStatus == .owner {
                        Text("OWNER")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.oarenaHighlight)
                            .cornerRadius(4)
                    } else if userRaceStatus == .joined {
                        Text("JOINED")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.oarenaAccent)
                            .cornerRadius(4)
                    }
                }
                
                // Workout type
                Text(race.workoutType)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.oarenaAccent)
                
                // Enhanced timing display
                VStack(alignment: .leading, spacing: 2) {
                    Text(race.timingLabel)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(race.raceType == "Live Race" ? .oarenaHighlight : .oarenaAccent)
                    
                    Text(race.timingDisplayText)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.oarenaPrimary)
                    
                    Text(race.countdownDisplayText)
                        .font(.caption2)
                        .foregroundColor(.oarenaSecondary)
                }
                
                // Race info row
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(race.rankDisplayText)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(race.rankColor)
                        
                        Text(race.participants)
                            .font(.caption2)
                            .foregroundColor(.oarenaSecondary)
                    }
                    
                    Spacer()
                }
                
                // Bottom row with entry fee and status
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "ticket.fill")
                            .foregroundColor(.oarenaAction)
                            .font(.caption)
                        Text("\(race.entryFee)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.oarenaPrimary)
                    }
                    
                    Spacer()
                    
                    Text(race.statusText)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(race.status == .upcoming ? Color.oarenaAccent : 
                                  race.status == .live ? Color.oarenaHighlight : Color.oarenaSecondary)
                        .cornerRadius(4)
                }
            }
        }
        .frame(width: 180, height: 220)
        .contentShape(Rectangle()) // Makes entire card tappable
        .opacity(hasJoined ? 0.8 : 1.0)
    }
}

#Preview {
    HomeView()
} 