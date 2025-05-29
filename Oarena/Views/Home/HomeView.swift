//
//  HomeView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var userData = UserData.shared
    @State private var showingWorkoutHistory = false
    @State private var showingTicketStore = false
    
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
                                    // Navigate to solo row
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
                                    // Navigate to find race
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
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Recent Activity Card
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Activity")
                                .font(.headline)
                                .foregroundColor(.oarenaPrimary)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Last Row")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                    Text("5000m • 20:00")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaPrimary)
                                    Text("Avg Split: 1:45/500m")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                }
                                
                                Spacer()
                                
                                Button("View History") {
                                    showingWorkoutHistory = true
                                }
                                .font(.caption)
                                .foregroundColor(.oarenaAccent)
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