//
//  RaceDetailView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct RaceDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var userData = UserData.shared
    @State private var showingJoinConfirmation = false
    
    // Race data - in a real app this would be passed in
    let raceName: String
    let raceMode: String
    let raceFormat: String
    let workoutType: String
    let entryFee: Int
    let maxParticipants: Int
    let currentParticipants: Int
    let startTime: String
    let prizePool: Int
    let raceDescription: String
    
    init(raceName: String = "Elite 2k Championship",
         raceMode: String = "Regatta",
         raceFormat: String = "Live",
         workoutType: String = "2000m Distance",
         entryFee: Int = 50,
         maxParticipants: Int = 32,
         currentParticipants: Int = 24,
         startTime: String = "1h 30m",
         prizePool: Int = 1200,
         raceDescription: String = "Join the elite rowers in this championship 2k race. Test your speed and endurance against the best!") {
        self.raceName = raceName
        self.raceMode = raceMode
        self.raceFormat = raceFormat
        self.workoutType = workoutType
        self.entryFee = entryFee
        self.maxParticipants = maxParticipants
        self.currentParticipants = currentParticipants
        self.startTime = startTime
        self.prizePool = prizePool
        self.raceDescription = raceDescription
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Race Header
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(raceName)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oarenaPrimary)
                                    
                                    Text("\(raceFormat) Race • \(raceMode)")
                                        .font(.subheadline)
                                        .foregroundColor(.oarenaHighlight)
                                }
                                
                                Spacer()
                                
                                Text("FEATURED")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.oarenaHighlight)
                                    .cornerRadius(4)
                            }
                            
                            Divider()
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Workout")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                    Text(workoutType)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaPrimary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Starts in")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                    Text(startTime)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaPrimary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Participants
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Participants")
                                    .font(.headline)
                                    .foregroundColor(.oarenaPrimary)
                                
                                Spacer()
                                
                                Text("\(currentParticipants) / \(maxParticipants)")
                                    .font(.subheadline)
                                    .foregroundColor(.oarenaSecondary)
                            }
                            
                            ProgressView(value: Double(currentParticipants), total: Double(maxParticipants))
                                .tint(.oarenaAccent)
                            
                            Text("Race will start when \(maxParticipants) participants join or at the scheduled time.")
                                .font(.caption)
                                .foregroundColor(.oarenaSecondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Prize Structure
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Prize Structure")
                                .font(.headline)
                                .foregroundColor(.oarenaPrimary)
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("🥇 1st Place")
                                        .font(.subheadline)
                                        .foregroundColor(.oarenaPrimary)
                                    Spacer()
                                    HStack {
                                        Image(systemName: "ticket.fill")
                                            .foregroundColor(.oarenaAction)
                                        Text("\(Int(Double(prizePool) * 0.5))")
                                            .fontWeight(.medium)
                                            .foregroundColor(.oarenaPrimary)
                                    }
                                }
                                
                                HStack {
                                    Text("🥈 2nd Place")
                                        .font(.subheadline)
                                        .foregroundColor(.oarenaPrimary)
                                    Spacer()
                                    HStack {
                                        Image(systemName: "ticket.fill")
                                            .foregroundColor(.oarenaAction)
                                        Text("\(Int(Double(prizePool) * 0.3))")
                                            .fontWeight(.medium)
                                            .foregroundColor(.oarenaPrimary)
                                    }
                                }
                                
                                HStack {
                                    Text("🥉 3rd Place")
                                        .font(.subheadline)
                                        .foregroundColor(.oarenaPrimary)
                                    Spacer()
                                    HStack {
                                        Image(systemName: "ticket.fill")
                                            .foregroundColor(.oarenaAction)
                                        Text("\(Int(Double(prizePool) * 0.2))")
                                            .fontWeight(.medium)
                                            .foregroundColor(.oarenaPrimary)
                                    }
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total Prize Pool")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaPrimary)
                                Spacer()
                                HStack {
                                    Image(systemName: "ticket.fill")
                                        .foregroundColor(.oarenaAction)
                                    Text("\(prizePool)")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oarenaPrimary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Description
                    if !raceDescription.isEmpty {
                        CardView {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.headline)
                                    .foregroundColor(.oarenaPrimary)
                                
                                Text(raceDescription)
                                    .font(.subheadline)
                                    .foregroundColor(.oarenaSecondary)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Join Button
                    VStack(spacing: 12) {
                        HStack {
                            Text("Entry Fee:")
                                .font(.subheadline)
                                .foregroundColor(.oarenaSecondary)
                            
                            HStack {
                                Image(systemName: "ticket.fill")
                                    .foregroundColor(.oarenaAction)
                                Text("\(entryFee) Tickets")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaPrimary)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            if userData.ticketCount >= entryFee {
                                showingJoinConfirmation = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "flag.checkered")
                                Text("Join Race (\(entryFee) Tickets)")
                            }
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(userData.ticketCount >= entryFee ? Color.oarenaAccent : Color.gray)
                            .cornerRadius(12)
                        }
                        .disabled(userData.ticketCount < entryFee)
                        .padding(.horizontal)
                        
                        if userData.ticketCount < entryFee {
                            Text("Not enough tickets to join this race")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .navigationTitle("Race Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .alert("Join Race", isPresented: $showingJoinConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Join") {
                if userData.spendTickets(entryFee) {
                    // Race joined successfully
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to join \(raceName) for \(entryFee) tickets?")
        }
    }
}

#Preview {
    RaceDetailView()
} 