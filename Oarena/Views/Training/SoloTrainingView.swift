//
//  SoloTrainingView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct SoloTrainingView: View {
    @ObservedObject private var userData = UserData.shared
    @State private var selectedWorkoutType = 0
    @State private var distance = ""
    @State private var time = ""
    @State private var intervalDistance = ""
    @State private var intervalTime = ""
    @State private var intervalRest = ""
    @State private var intervalCount = ""
    @State private var isPM5Connected = false
    @State private var showingWorkoutHistory = false
    @State private var showingTicketStore = false
    
    let workoutTypes = ["Just Row", "Single Distance", "Single Time", "Intervals: Distance", "Intervals: Time"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // PM5 Connection Status
                    PM5ConnectionStatusCard(isConnected: $isPM5Connected)
                        .padding(.horizontal)
                    
                    // Setup Workout Card
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Start a New Solo Row")
                                .font(.headline)
                                .foregroundColor(.oarenaPrimary)
                            
                            // Workout Type Selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Workout Type")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaSecondary)
                                
                                // Workout Type Buttons Grid
                                VStack(spacing: 12) {
                                    // First row: Just Row, Single Distance, Single Time
                                    HStack(spacing: 12) {
                                        WorkoutTypeButton(
                                            title: "Just Row",
                                            subtitle: "Open rowing",
                                            index: 0,
                                            selectedIndex: selectedWorkoutType,
                                            action: { selectedWorkoutType = 0 }
                                        )
                                        
                                        WorkoutTypeButton(
                                            title: "Single Distance",
                                            subtitle: "Set meters",
                                            index: 1,
                                            selectedIndex: selectedWorkoutType,
                                            action: { selectedWorkoutType = 1 }
                                        )
                                        
                                        WorkoutTypeButton(
                                            title: "Single Time",
                                            subtitle: "Set duration",
                                            index: 2,
                                            selectedIndex: selectedWorkoutType,
                                            action: { selectedWorkoutType = 2 }
                                        )
                                    }
                                    
                                    // Second row: Interval types (centered)
                                    HStack(spacing: 12) {
                                        Spacer()
                                        
                                        WorkoutTypeButton(
                                            title: "Intervals: Distance",
                                            subtitle: "Distance sets",
                                            index: 3,
                                            selectedIndex: selectedWorkoutType,
                                            action: { selectedWorkoutType = 3 }
                                        )
                                        
                                        WorkoutTypeButton(
                                            title: "Intervals: Time",
                                            subtitle: "Time sets",
                                            index: 4,
                                            selectedIndex: selectedWorkoutType,
                                            action: { selectedWorkoutType = 4 }
                                        )
                                        
                                        Spacer()
                                    }
                                }
                            }
                            
                            // Parameters based on workout type
                            if selectedWorkoutType == 1 { // Single Distance
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Distance (meters)")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    TextField("e.g., 2000", text: $distance)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.numberPad)
                                }
                            } else if selectedWorkoutType == 2 { // Single Time
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Time (minutes)")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    TextField("e.g., 20", text: $time)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.numberPad)
                                }
                            } else if selectedWorkoutType == 3 { // Intervals: Distance
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Interval Configuration")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    HStack(spacing: 12) {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("Distance (m)")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                            TextField("500", text: $intervalDistance)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("Rest (min)")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                            TextField("2", text: $intervalRest)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("Sets")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                            TextField("5", text: $intervalCount)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                        }
                                    }
                                }
                            } else if selectedWorkoutType == 4 { // Intervals: Time
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Interval Configuration")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    HStack(spacing: 12) {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("Time (min)")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                            TextField("4", text: $intervalTime)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("Rest (min)")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                            TextField("2", text: $intervalRest)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("Sets")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                            TextField("5", text: $intervalCount)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                        }
                                    }
                                }
                            }
                            
                            // Start Button
                            Button(action: {
                                // Start rowing
                            }) {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text("Start Rowing")
                                }
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isPM5Connected ? Color.oarenaAccent : Color.gray)
                                .cornerRadius(12)
                            }
                            .disabled(!isPM5Connected)
                        }
                    }
                    .padding(.horizontal)
                    
                    // PM5 Connection Prompt (if disconnected)
                    if !isPM5Connected {
                        CardView(backgroundColor: Color.oarenaHighlight.opacity(0.1)) {
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.oarenaHighlight)
                                    .font(.title2)
                                
                                Text("Connect PM5 to Start Training")
                                    .font(.headline)
                                    .foregroundColor(.oarenaPrimary)
                                
                                Text("Make sure your PM5 is turned on and Bluetooth is enabled")
                                    .font(.subheadline)
                                    .foregroundColor(.oarenaSecondary)
                                    .multilineTextAlignment(.center)
                                
                                Button("Connect PM5") {
                                    // Navigate to PM5 connection
                                }
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.oarenaHighlight)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Recent Solo Workouts
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Recent Solo Workouts")
                                    .font(.headline)
                                    .foregroundColor(.oarenaPrimary)
                                
                                Spacer()
                                
                                Button("View All") {
                                    showingWorkoutHistory = true
                                }
                                .font(.caption)
                                .foregroundColor(.oarenaAccent)
                            }
                            
                            LazyVStack(spacing: 8) {
                                ForEach(0..<3) { index in
                                    WorkoutPreviewRow()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .navigationTitle("Train")
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
    }
}

struct PM5ConnectionStatusCard: View {
    @Binding var isConnected: Bool
    
    var body: some View {
        Button(action: {
            // Toggle connection for demo
            isConnected.toggle()
        }) {
            HStack {
                Circle()
                    .fill(isConnected ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
                
                Text(isConnected ? "PM5 Connected" : "PM5 Disconnected")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.oarenaPrimary)
                
                Spacer()
                
                if !isConnected {
                    Text("Tap to Connect")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

struct WorkoutPreviewRow: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("5000m Row")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.oarenaPrimary)
                
                Text("20:15 • 1:45/500m avg")
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
                
                Text("Yesterday")
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                HStack(spacing: 4) {
                    Image(systemName: "ticket.fill")
                        .foregroundColor(.oarenaAction)
                        .font(.caption)
                    Text("15")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                }
                
                Text("Tickets Earned")
                    .font(.caption2)
                    .foregroundColor(.oarenaSecondary)
            }
        }
        .padding(.vertical, 8)
    }
}

struct WorkoutTypeButton: View {
    let title: String
    let subtitle: String
    let index: Int
    let selectedIndex: Int
    let action: () -> Void
    
    var isSelected: Bool {
        index == selectedIndex
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .oarenaPrimary)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .oarenaSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 75)
            .padding(.horizontal, 8)
            .background(isSelected ? Color.oarenaAccent : Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.oarenaAccent : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SoloTrainingView()
} 