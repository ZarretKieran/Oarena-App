//
//  WorkoutSummaryView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct WorkoutSummaryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var userData = UserData.shared
    
    // Workout data - in a real app this would be passed in
    let workoutType: String
    let date: String
    let totalTime: String
    let distance: String
    let avgPace: String
    let avgPower: String
    let avgSPM: String
    let maxHeartRate: String
    let calories: String
    let ticketsEarned: Int
    let rankPointsGained: Int
    
    init(workoutType: String = "5000m Distance Row",
         date: String = "Today, 2:30 PM",
         totalTime: String = "20:15.3",
         distance: String = "5000m",
         avgPace: String = "2:01.5",
         avgPower: String = "185W",
         avgSPM: String = "24",
         maxHeartRate: String = "168 bpm",
         calories: String = "325",
         ticketsEarned: Int = 15,
         rankPointsGained: Int = 25) {
        self.workoutType = workoutType
        self.date = date
        self.totalTime = totalTime
        self.distance = distance
        self.avgPace = avgPace
        self.avgPower = avgPower
        self.avgSPM = avgSPM
        self.maxHeartRate = maxHeartRate
        self.calories = calories
        self.ticketsEarned = ticketsEarned
        self.rankPointsGained = rankPointsGained
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Workout Header
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(workoutType)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oarenaPrimary)
                                    
                                    Text(date)
                                        .font(.subheadline)
                                        .foregroundColor(.oarenaSecondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "figure.rowing")
                                    .font(.title)
                                    .foregroundColor(.oarenaAccent)
                            }
                            
                            Divider()
                            
                            // Key Metrics Grid
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Total Time")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                    Text(totalTime)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaPrimary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    Text("Distance")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                    Text(distance)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaPrimary)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Performance Metrics
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Performance Metrics")
                                .font(.headline)
                                .foregroundColor(.oarenaPrimary)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                MetricCard(title: "Avg Pace", value: avgPace, icon: "speedometer")
                                MetricCard(title: "Avg Power", value: avgPower, icon: "bolt.fill")
                                MetricCard(title: "Avg SPM", value: avgSPM, icon: "waveform.path.ecg")
                                MetricCard(title: "Max HR", value: maxHeartRate, icon: "heart.fill")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Calories & Rewards
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Workout Results")
                                .font(.headline)
                                .foregroundColor(.oarenaPrimary)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "flame.fill")
                                            .foregroundColor(.orange)
                                        Text("Calories Burned")
                                            .font(.subheadline)
                                            .foregroundColor(.oarenaSecondary)
                                    }
                                    Text(calories)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oarenaPrimary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 8) {
                                    HStack {
                                        Image(systemName: "ticket.fill")
                                            .foregroundColor(.oarenaAction)
                                        Text("Tickets Earned")
                                            .font(.subheadline)
                                            .foregroundColor(.oarenaSecondary)
                                    }
                                    Text("+\(ticketsEarned)")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oarenaAction)
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.oarenaAccent)
                                Text("Rank Points")
                                    .font(.subheadline)
                                    .foregroundColor(.oarenaSecondary)
                                
                                Spacer()
                                
                                Text("+\(rankPointsGained) RP")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.oarenaAccent)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Workout Calculation Info
                    CardView(backgroundColor: Color.oarenaAccent.opacity(0.05)) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.oarenaAccent)
                                Text("How Rewards Are Calculated")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaPrimary)
                            }
                            
                            Text("Tickets are earned based on workout volume and intensity. Longer, more intense workouts earn more tickets. Rank Points reflect your performance relative to your current rank tier.")
                                .font(.caption)
                                .foregroundColor(.oarenaSecondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .navigationTitle("Workout Summary")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.oarenaAccent)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
                
                Spacer()
            }
            
            HStack {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.oarenaPrimary)
                Spacer()
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    WorkoutSummaryView()
} 