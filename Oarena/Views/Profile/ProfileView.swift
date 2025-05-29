//
//  ProfileView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct ProfileView: View {
    @State private var ticketBalance = 150
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    @State private var showingStore = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // User Summary Card
                    CardView {
                        VStack(spacing: 16) {
                            HStack {
                                // Avatar
                                Circle()
                                    .fill(Color.oarenaAccent)
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Text("Z")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    )
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Zarret")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oarenaPrimary)
                                    
                                    HStack {
                                        Text("Gold III")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.oarenaSecondary)
                                        
                                        Circle()
                                            .fill(Color.yellow)
                                            .frame(width: 24, height: 24)
                                            .overlay(
                                                Text("G3")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                            )
                                    }
                                    
                                    HStack {
                                        Image(systemName: "ticket.fill")
                                            .foregroundColor(.oarenaAction)
                                        Text("\(ticketBalance) Tickets")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.oarenaPrimary)
                                    }
                                }
                                
                                Spacer()
                            }
                            
                            Button(action: {
                                showingEditProfile = true
                            }) {
                                HStack {
                                    Image(systemName: "person.crop.circle")
                                    Text("Edit Profile")
                                }
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaAccent)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.oarenaAccent.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Key Performance Stats Card
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Personal Records")
                                .font(.headline)
                                .foregroundColor(.oarenaPrimary)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                StatItem(title: "500m", time: "1:32.5")
                                StatItem(title: "1k", time: "3:18.7")
                                StatItem(title: "2k", time: "7:15.2")
                                StatItem(title: "5k", time: "18:42.8")
                                StatItem(title: "10k", time: "38:25.1")
                                StatItem(title: "30min", distance: "7,850m")
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Overall Summary")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaSecondary)
                                
                                HStack {
                                    OverallStatItem(title: "Total Distance", value: "425,680m")
                                    Spacer()
                                    OverallStatItem(title: "Total Time", value: "142h 35m")
                                    Spacer()
                                    OverallStatItem(title: "Workouts", value: "87")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Race History Section
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Race History")
                                    .font(.headline)
                                    .foregroundColor(.oarenaPrimary)
                                
                                Spacer()
                                
                                NavigationLink("View All") {
                                    RaceHistoryView()
                                }
                                .font(.caption)
                                .foregroundColor(.oarenaAccent)
                            }
                            
                            LazyVStack(spacing: 8) {
                                ForEach(0..<3) { index in
                                    RaceHistoryRow()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Solo Workout History Section
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Recent Solo Workouts")
                                    .font(.headline)
                                    .foregroundColor(.oarenaPrimary)
                                
                                Spacer()
                                
                                NavigationLink("View All") {
                                    WorkoutLogView()
                                }
                                .font(.caption)
                                .foregroundColor(.oarenaAccent)
                            }
                            
                            LazyVStack(spacing: 8) {
                                ForEach(0..<3) { index in
                                    WorkoutHistoryRow()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Settings & Store Section
                    CardView {
                        VStack(spacing: 12) {
                            Button(action: {
                                showingSettings = true
                            }) {
                                HStack {
                                    Image(systemName: "gearshape.fill")
                                        .foregroundColor(.oarenaSecondary)
                                    Text("Settings")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                }
                                .padding(.vertical, 8)
                            }
                            
                            Divider()
                            
                            Button(action: {
                                showingStore = true
                            }) {
                                HStack {
                                    Image(systemName: "cart.fill")
                                        .foregroundColor(.oarenaAction)
                                    Text("Shop (Get More Tickets)")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingStore) {
            StoreView()
        }
    }
}

struct StatItem: View {
    let title: String
    let time: String?
    let distance: String?
    
    init(title: String, time: String) {
        self.title = title
        self.time = time
        self.distance = nil
    }
    
    init(title: String, distance: String) {
        self.title = title
        self.time = nil
        self.distance = distance
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.oarenaSecondary)
            
            Text(time ?? distance ?? "")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.oarenaPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct OverallStatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
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

struct RaceHistoryRow: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Elite 2k Sprint")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.oarenaPrimary)
                
                Text("2nd Place • Live Race")
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
                
                Text("3 days ago")
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                HStack {
                    Image(systemName: "ticket.fill")
                        .foregroundColor(.oarenaAction)
                        .font(.caption)
                    Text("+125")
                        .font(.caption)
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                }
                
                Text("+15 RP")
                    .font(.caption)
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }
        }
        .padding(.vertical, 8)
    }
}

struct WorkoutHistoryRow: View {
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
                HStack {
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

// Placeholder views for navigation
struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Edit Profile")
                    .font(.headline)
                    .padding()
                
                // Edit profile form would go here
                
                Spacer()
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .font(.headline)
                    .padding()
                
                // Settings form would go here
                
                Spacer()
            }
            .navigationBarItems(
                leading: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct StoreView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Ticket Store")
                    .font(.headline)
                    .padding()
                
                // Store interface would go here
                
                Spacer()
            }
            .navigationBarItems(
                leading: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct RaceHistoryView: View {
    var body: some View {
        VStack {
            Text("Race History")
                .font(.headline)
                .padding()
            
            // Full race history would go here
            
            Spacer()
        }
        .navigationTitle("Race History")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct WorkoutLogView: View {
    var body: some View {
        VStack {
            Text("Workout Log")
                .font(.headline)
                .padding()
            
            // Full workout log would go here
            
            Spacer()
        }
        .navigationTitle("Workout Log")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    ProfileView()
} 