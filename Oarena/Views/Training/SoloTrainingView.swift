//
//  SoloTrainingView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct SoloTrainingView: View {
    @ObservedObject private var userData = UserData.shared
    @State private var distance = ""
    @State private var timeMinutes = ""
    @State private var timeSeconds = ""
    @State private var intervalDistance = ""
    @State private var intervalTimeMinutes = ""
    @State private var intervalTimeSeconds = ""
    @State private var intervalRestMinutes = ""
    @State private var intervalRestSeconds = ""
    @State private var intervalCount = ""
    @ObservedObject private var pm5 = PM5BluetoothManager.shared
    @State private var showPM5Picker = false
    @State private var showingWorkoutHistory = false
    @State private var showingTicketStore = false
    @State private var selectedWorkout: WorkoutData?
    @State private var showingWorkoutDetail = false
    
    let workoutTypes = ["Just Row", "Single Distance", "Single Time", "Intervals: Distance", "Intervals: Time"]
    let recentWorkouts = Array(WorkoutData.sampleWorkouts.prefix(3)) // Show first 3 workouts
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // PM5 Connection Status
                    PM5ConnectionStatusCard(isConnected: .constant(pm5.isConnected), onTap: { showPM5Picker = true })
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
                                            selectedIndex: userData.selectedWorkoutType,
                                            action: { userData.setWorkoutType(0) }
                                        )
                                        
                                        WorkoutTypeButton(
                                            title: "Single Distance",
                                            subtitle: "Set meters",
                                            index: 1,
                                            selectedIndex: userData.selectedWorkoutType,
                                            action: { userData.setWorkoutType(1) }
                                        )
                                        
                                        WorkoutTypeButton(
                                            title: "Single Time",
                                            subtitle: "Set duration",
                                            index: 2,
                                            selectedIndex: userData.selectedWorkoutType,
                                            action: { userData.setWorkoutType(2) }
                                        )
                                    }
                                    
                                    // Second row: Interval types (centered)
                                    HStack(spacing: 12) {
                                        Spacer()
                                        
                                        WorkoutTypeButton(
                                            title: "Intervals: Distance",
                                            subtitle: "Distance sets",
                                            index: 3,
                                            selectedIndex: userData.selectedWorkoutType,
                                            action: { userData.setWorkoutType(3) }
                                        )
                                        
                                        WorkoutTypeButton(
                                            title: "Intervals: Time",
                                            subtitle: "Time sets",
                                            index: 4,
                                            selectedIndex: userData.selectedWorkoutType,
                                            action: { userData.setWorkoutType(4) }
                                        )
                                        
                                        Spacer()
                                    }
                                }
                            }
                            
                            // Parameters based on workout type
                            if userData.selectedWorkoutType == 1 { // Single Distance
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Distance (meters)")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    TextField("e.g., 2000", text: $distance)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.numberPad)
                                }
                            } else if userData.selectedWorkoutType == 2 { // Single Time
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Duration")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    HStack(spacing: 8) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Minutes")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                            TextField("20", text: $timeMinutes)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        Text(":")
                                            .font(.title2)
                                            .foregroundColor(.oarenaSecondary)
                                            .padding(.top, 20)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Seconds")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                            TextField("00", text: $timeSeconds)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        Spacer()
                                    }
                                }
                            } else if userData.selectedWorkoutType == 3 { // Intervals: Distance
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Interval Configuration")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    // Distance and Sets row
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
                                            Text("Sets")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                            TextField("5", text: $intervalCount)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                        }
                                    }
                                    
                                    // Rest time row with minutes and seconds
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Rest Time")
                                            .font(.caption)
                                            .foregroundColor(.oarenaSecondary)
                                        
                                        HStack(spacing: 8) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Min")
                                                    .font(.caption2)
                                                    .foregroundColor(.oarenaSecondary)
                                                TextField("2", text: $intervalRestMinutes)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .keyboardType(.numberPad)
                                            }
                                            
                                            Text(":")
                                                .font(.headline)
                                                .foregroundColor(.oarenaSecondary)
                                                .padding(.top, 16)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Sec")
                                                    .font(.caption2)
                                                    .foregroundColor(.oarenaSecondary)
                                                TextField("30", text: $intervalRestSeconds)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .keyboardType(.numberPad)
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            } else if userData.selectedWorkoutType == 4 { // Intervals: Time
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Interval Configuration")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    // Sets
                                    HStack(spacing: 12) {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("Sets")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                            TextField("5", text: $intervalCount)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.numberPad)
                                        }
                                        Spacer()
                                    }
                                    
                                    // Interval duration with minutes and seconds
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Interval Duration")
                                            .font(.caption)
                                            .foregroundColor(.oarenaSecondary)
                                        
                                        HStack(spacing: 8) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Min")
                                                    .font(.caption2)
                                                    .foregroundColor(.oarenaSecondary)
                                                TextField("4", text: $intervalTimeMinutes)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .keyboardType(.numberPad)
                                            }
                                            
                                            Text(":")
                                                .font(.headline)
                                                .foregroundColor(.oarenaSecondary)
                                                .padding(.top, 16)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Sec")
                                                    .font(.caption2)
                                                    .foregroundColor(.oarenaSecondary)
                                                TextField("00", text: $intervalTimeSeconds)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .keyboardType(.numberPad)
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                    
                                    // Rest time with minutes and seconds
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Rest Time")
                                            .font(.caption)
                                            .foregroundColor(.oarenaSecondary)
                                        
                                        HStack(spacing: 8) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Min")
                                                    .font(.caption2)
                                                    .foregroundColor(.oarenaSecondary)
                                                TextField("2", text: $intervalRestMinutes)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .keyboardType(.numberPad)
                                            }
                                            
                                            Text(":")
                                                .font(.headline)
                                                .foregroundColor(.oarenaSecondary)
                                                .padding(.top, 16)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Sec")
                                                    .font(.caption2)
                                                    .foregroundColor(.oarenaSecondary)
                                                TextField("30", text: $intervalRestSeconds)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .keyboardType(.numberPad)
                                            }
                                            
                                            Spacer()
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
                                    .background(pm5.isConnected ? Color.oarenaAccent : Color.gray)
                                .cornerRadius(12)
                            }
                            .disabled(!pm5.isConnected)
                        }
                    }
                    .padding(.horizontal)
                    
                    // PM5 Connection Prompt (if disconnected)
                    if !pm5.isConnected {
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
                            
                            LazyVStack(spacing: 12) {
                                ForEach(recentWorkouts) { workout in
                                    WorkoutPreviewRow(workout: workout)
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
        .sheet(isPresented: $showPM5Picker) { PM5DevicePickerSheet() }
        .sheet(isPresented: $showingWorkoutHistory) {
            WorkoutHistoryView()
        }
        .sheet(isPresented: $showingTicketStore) {
            TicketStoreView()
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
        .onTapGesture {
            // Dismiss keyboard when tapping outside text fields
            hideKeyboard()
        }
        .gesture(
            DragGesture()
                .onEnded { dragValue in
                    // Dismiss keyboard when swiping down
                    if dragValue.translation.height > 50 {
                        hideKeyboard()
                    }
                }
        )
    }
    
    // Function to dismiss keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct PM5ConnectionStatusCard: View {
    @Binding var isConnected: Bool
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { onTap?() }) {
            HStack {
                Circle()
                    .fill(isConnected ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
                
                Text(isConnected ? "PM5 Connected" : "PM5 Disconnected")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.oarenaPrimary)
                
                Spacer()
                
                Text("Tap to Connect")
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
                
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