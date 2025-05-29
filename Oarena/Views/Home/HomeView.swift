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
    @State private var selectedWorkout: WorkoutData?
    @State private var showingWorkoutDetail = false
    
    let recentWorkouts = Array(WorkoutData.sampleWorkouts.prefix(4)) // Show first 4 workouts
    
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
                    
                    // Upcoming Races Card
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Upcoming Races")
                                .font(.headline)
                                .foregroundColor(.oarenaPrimary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(0..<3) { index in
                                        RacePreviewCard()
                                            .onTapGesture {
                                                showingRaceDetail = true
                                            }
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
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
            RaceDetailView()
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
            // Workout icon
            Circle()
                .fill(Color.oarenaAccent.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "figure.rowing")
                        .foregroundColor(.oarenaAccent)
                        .font(.caption)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.workoutType)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.oarenaPrimary)
                
                Text(workout.summary)
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
                
                Text(workout.timeAgo)
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
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
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("2k Sprint Challenge")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.oarenaPrimary)
            
            Text("Live Race")
                .font(.caption)
                .foregroundColor(.oarenaHighlight)
            
            Text("Starts in 2h 15m")
                .font(.caption)
                .foregroundColor(.oarenaSecondary)
            
            HStack {
                Image(systemName: "ticket.fill")
                    .foregroundColor(.oarenaAction)
                    .font(.caption)
                Text("25 Tickets")
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
            }
        }
        .padding(12)
        .frame(width: 140)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.oarenaAccent.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    HomeView()
} 