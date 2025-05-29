//
//  WorkoutHistoryView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct WorkoutHistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedFilter = 0
    @State private var searchText = ""
    @State private var selectedWorkout: WorkoutData?
    @State private var showingWorkoutDetail = false
    
    let filterOptions = ["All", "Solo Rows", "Races", "This Week", "This Month"]
    
    // Using actual workout data
    var allWorkouts: [WorkoutData] {
        WorkoutData.sampleWorkouts
    }
    
    var filteredWorkouts: [WorkoutData] {
        let filtered = allWorkouts.filter { workout in
            if searchText.isEmpty {
                return true
            }
            return workout.workoutType.localizedCaseInsensitiveContains(searchText) ||
                   workout.summary.localizedCaseInsensitiveContains(searchText)
        }
        
        switch selectedFilter {
        case 1: // Solo Rows
            return filtered.filter { $0.workoutType.contains("Solo") || $0.workoutType.contains("Row") }
        case 2: // Races
            return filtered.filter { $0.workoutType.contains("Race") }
        case 3: // This Week (simplified - showing first 7 workouts)
            return Array(filtered.prefix(7))
        case 4: // This Month (simplified - showing first 15 workouts)
            return Array(filtered.prefix(15))
        default: // All
            return filtered
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter and Search Section
                VStack(spacing: 12) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.oarenaSecondary)
                        
                        TextField("Search workouts...", text: $searchText)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Filter Buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(0..<filterOptions.count, id: \.self) { index in
                                FilterButton(
                                    title: filterOptions[index],
                                    isSelected: selectedFilter == index,
                                    action: { selectedFilter = index }
                                )
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Summary Stats Card
                CardView {
                    VStack(spacing: 12) {
                        Text("Activity Summary")
                            .font(.headline)
                            .foregroundColor(.oarenaPrimary)
                        
                        HStack {
                            StatSummaryItem(title: "Total Workouts", value: "\(allWorkouts.count)", icon: "figure.rowing")
                            Spacer()
                            StatSummaryItem(title: "This Week", value: "\(min(7, allWorkouts.count))", icon: "calendar.day.timeline.leading")
                            Spacer()
                            StatSummaryItem(title: "Avg/Week", value: "3.2", icon: "chart.line.uptrend.xyaxis")
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Workout List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredWorkouts) { workout in
                            WorkoutHistoryCard(workout: workout)
                                .padding(.horizontal)
                                .onTapGesture {
                                    selectedWorkout = workout
                                    showingWorkoutDetail = true
                                }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Workout History")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
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

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .oarenaAccent)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.oarenaAccent : Color.oarenaAccent.opacity(0.1))
                .cornerRadius(16)
        }
    }
}

struct StatSummaryItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.oarenaAccent)
                .font(.title3)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.oarenaPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.oarenaSecondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct WorkoutHistoryCard: View {
    let workout: WorkoutData
    
    var isRace: Bool {
        workout.workoutType.contains("Race")
    }
    
    var body: some View {
        CardView(backgroundColor: isRace ? Color.oarenaHighlight.opacity(0.05) : Color(.systemBackground)) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with workout type and date
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(workout.workoutType)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.oarenaPrimary)
                            
                            if isRace {
                                Text("• 3rd Place")
                                    .font(.caption)
                                    .foregroundColor(.oarenaHighlight)
                            }
                        }
                        
                        Text(workout.timeAgo)
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Image(systemName: "ticket.fill")
                                .foregroundColor(.oarenaAction)
                                .font(.caption)
                            Text(isRace ? "+\(workout.ticketsEarned)" : "\(workout.ticketsEarned)")
                                .font(.caption)
                                .foregroundColor(isRace ? .green : .oarenaSecondary)
                                .fontWeight(.medium)
                        }
                        
                        if isRace && workout.rankPointsGained > 0 {
                            Text("+\(workout.rankPointsGained) RP")
                                .font(.caption)
                                .foregroundColor(.green)
                                .fontWeight(.medium)
                        }
                    }
                }
                
                // Performance metrics
                HStack {
                    MetricItem(title: "Distance", value: "\(workout.distance)m")
                    Spacer()
                    MetricItem(title: "Time", value: workout.totalTime)
                    Spacer()
                    MetricItem(title: "Avg Split", value: workout.avgPace)
                }
                
                // Additional details for races
                if isRace {
                    Divider()
                    HStack {
                        Text("Elite Championship")
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                        
                        Spacer()
                        
                        Text("24 participants")
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                    }
                }
                
                // Add tap indicator
                HStack {
                    Spacer()
                    Text("Tap to view details")
                        .font(.caption)
                        .foregroundColor(.oarenaAccent)
                        .italic()
                }
            }
        }
        .contentShape(Rectangle()) // Makes entire card tappable
    }
}

struct MetricItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundColor(.oarenaSecondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.oarenaPrimary)
        }
    }
}

#Preview {
    WorkoutHistoryView()
} 