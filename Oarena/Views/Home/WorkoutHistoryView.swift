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
    
    let filterOptions = ["All", "Solo Rows", "Races", "This Week", "This Month"]
    
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
                            StatSummaryItem(title: "Total Workouts", value: "87", icon: "figure.rowing")
                            Spacer()
                            StatSummaryItem(title: "This Week", value: "5", icon: "calendar.day.timeline.leading")
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
                        ForEach(0..<20) { index in
                            WorkoutHistoryCard(workoutIndex: index)
                                .padding(.horizontal)
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
    let workoutIndex: Int
    
    // Sample data arrays for variety
    private let workoutTypes = ["Solo Row", "Race", "Solo Row", "Training", "Race"]
    private let distances = ["2000m", "5000m", "10000m", "6000m", "2000m"]
    private let times = ["7:15.2", "20:15.8", "42:30.1", "24:45.0", "7:22.1"]
    private let splits = ["1:48/500m", "1:45/500m", "1:52/500m", "1:51/500m", "1:50/500m"]
    private let dates = ["Today", "Yesterday", "2 days ago", "3 days ago", "5 days ago"]
    private let tickets = [25, 15, 30, 20, 35]
    
    var isRace: Bool {
        workoutTypes[workoutIndex % workoutTypes.count] == "Race"
    }
    
    var body: some View {
        CardView(backgroundColor: isRace ? Color.oarenaHighlight.opacity(0.05) : Color(.systemBackground)) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with workout type and date
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(workoutTypes[workoutIndex % workoutTypes.count])
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.oarenaPrimary)
                            
                            if isRace {
                                Text("• 3rd Place")
                                    .font(.caption)
                                    .foregroundColor(.oarenaHighlight)
                            }
                        }
                        
                        Text(dates[workoutIndex % dates.count])
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Image(systemName: "ticket.fill")
                                .foregroundColor(.oarenaAction)
                                .font(.caption)
                            Text(isRace ? "+\(tickets[workoutIndex % tickets.count])" : "\(tickets[workoutIndex % tickets.count])")
                                .font(.caption)
                                .foregroundColor(isRace ? .green : .oarenaSecondary)
                                .fontWeight(.medium)
                        }
                        
                        if isRace {
                            Text("+12 RP")
                                .font(.caption)
                                .foregroundColor(.green)
                                .fontWeight(.medium)
                        }
                    }
                }
                
                // Performance metrics
                HStack {
                    MetricItem(title: "Distance", value: distances[workoutIndex % distances.count])
                    Spacer()
                    MetricItem(title: "Time", value: times[workoutIndex % times.count])
                    Spacer()
                    MetricItem(title: "Avg Split", value: splits[workoutIndex % splits.count])
                }
                
                // Additional details for races
                if isRace {
                    Divider()
                    HStack {
                        Text("Elite 2k Sprint Championship")
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                        
                        Spacer()
                        
                        Text("24 participants")
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                    }
                }
            }
        }
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