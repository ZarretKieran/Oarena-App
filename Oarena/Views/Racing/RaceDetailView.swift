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
    @State private var showingInsufficientTickets = false
    @State private var showingRankRequirementAlert = false
    @State private var showingJoinSuccess = false
    
    let race: RaceData
    
    var hasEnoughTickets: Bool {
        userData.ticketCount >= race.entryFee
    }
    
    var meetsRankRequirement: Bool {
        userData.meetsRankRequirement(race.rankRequirement)
    }
    
    var hasJoinedRace: Bool {
        userData.hasJoinedRace(race.id)
    }
    
    var canJoinRace: Bool {
        hasEnoughTickets && meetsRankRequirement && !hasJoinedRace
    }
    
    var joinButtonText: String {
        if hasJoinedRace {
            return "Already Joined"
        } else if !meetsRankRequirement {
            return "Rank Requirement Not Met"
        } else if !hasEnoughTickets {
            return "Insufficient Tickets"
        } else {
            return race.status == .live ? "Join Race Now" : "Join Race"
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Card
                    CardView(backgroundColor: Color.oarenaAccent.opacity(0.05)) {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(race.title)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oarenaPrimary)
                                    
                                    HStack {
                                        Text("\(race.raceType) • \(race.format)")
                                            .font(.subheadline)
                                            .foregroundColor(.oarenaHighlight)
                                        
                                        Spacer()
                                        
                                        if race.isFeatured {
                                            Text("FEATURED")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.oarenaHighlight)
                                                .cornerRadius(4)
                                        }
                                    }
                                    
                                    Text(race.workoutType)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaAccent)
                                }
                            }
                            
                            Divider()
                            
                            // Race timing info
                            VStack(alignment: .leading, spacing: 8) {
                                // Enhanced timing display
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Image(systemName: race.raceType == "Live Race" ? "play.circle" : "calendar")
                                            .foregroundColor(race.raceType == "Live Race" ? .oarenaHighlight : .oarenaAccent)
                                        
                                        Text(race.timingLabel)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(race.raceType == "Live Race" ? .oarenaHighlight : .oarenaAccent)
                                        
                                        Spacer()
                                        
                                        Text(race.statusText)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 3)
                                            .background(race.status == .upcoming ? Color.oarenaAccent : 
                                                      race.status == .live ? Color.oarenaHighlight : Color.oarenaSecondary)
                                            .cornerRadius(4)
                                    }
                                    
                                    Text(race.timingDisplayText)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oarenaPrimary)
                                    
                                    Text(race.countdownDisplayText)
                                        .font(.subheadline)
                                        .foregroundColor(.oarenaSecondary)
                                }
                                
                                HStack {
                                    Image(systemName: "person.2")
                                        .foregroundColor(.oarenaSecondary)
                                    Text(race.participants)
                                        .font(.subheadline)
                                        .foregroundColor(.oarenaSecondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Dedicated Timing Card
                    CardView(backgroundColor: race.raceType == "Live Race" ? 
                             Color.oarenaHighlight.opacity(0.1) : Color.oarenaAccent.opacity(0.1)) {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: race.raceType == "Live Race" ? "play.circle.fill" : "calendar.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(race.raceType == "Live Race" ? .oarenaHighlight : .oarenaAccent)
                                
                                Text(race.timingLabel)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(race.raceType == "Live Race" ? .oarenaHighlight : .oarenaAccent)
                                
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(race.timingDisplayText)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.oarenaPrimary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(race.countdownDisplayText)
                                    .font(.subheadline)
                                    .foregroundColor(.oarenaSecondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if race.raceType == "Async Race" && race.status == .live {
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.orange)
                                            .font(.caption)
                                        Text("Submit your result before the deadline!")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.orange)
                                    }
                                    .padding(.top, 4)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Dedicated Rank Requirement Card (if user doesn't meet requirement)
                    if !meetsRankRequirement && race.rankRequirement != nil {
                        CardView(backgroundColor: Color.red.opacity(0.1)) {
                            VStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.title2)
                                        .foregroundColor(.red)
                                    
                                    Text("Rank Requirement Not Met")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                    
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("This race requires \(race.rankRequirement!)+ rank")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaPrimary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("Your current rank: \(userData.currentRank)")
                                        .font(.subheadline)
                                        .foregroundColor(.oarenaSecondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("Keep training to improve your rank and unlock this race!")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Prize and Entry Info
                    CardView {
                        HStack(spacing: 0) {
                            VStack(spacing: 16) {
                                VStack(spacing: 4) {
                                    Text("Entry Fee")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "ticket.fill")
                                            .foregroundColor(.oarenaAction)
                                            .font(.subheadline)
                                        Text("\(race.entryFee)")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.oarenaPrimary)
                                    }
                                }
                                
                                VStack(spacing: 4) {
                                    Text(race.rankRequirement != nil ? "Rank Requirement" : "Eligibility")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    VStack(spacing: 6) {
                                            Text(race.rankDisplayText)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(
                                                    race.rankColor
                                                )
                                        
                                        if let requirement = race.rankRequirement {
                                            Text("Minimum: \(requirement) Rank")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                        } else {
                                            Text("No rank requirement")
                                                .font(.caption)
                                                .foregroundColor(.oarenaSecondary)
                                        }
                                    }
                                    
                                    // Eligibility status
                                    HStack(spacing: 4) {
                                        Image(systemName: meetsRankRequirement ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .font(.caption)
                                            .foregroundColor(meetsRankRequirement ? .green : .red)
                                        
                                        Text(race.rankRequirement != nil ? 
                                             (meetsRankRequirement ? "You are eligible" : "Rank requirement not met") :
                                             "Open to everyone")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(race.rankRequirement != nil ? 
                                                           (meetsRankRequirement ? .green : .red) : .oarenaAccent)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 8) {
                                VStack(spacing: 4) {
                                    Text("Total Prize Pool")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "trophy.fill")
                                            .foregroundColor(.oarenaHighlight)
                                            .font(.subheadline)
                                        Text("\(race.prizePool)")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.oarenaPrimary)
                                    }
                                }
                                
                                VStack(spacing: 4) {
                                    Text("Created by")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                    
                                    Text(race.createdBy)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaAccent)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Description
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.oarenaPrimary)
                            
                            Text(race.description)
                                .font(.subheadline)
                                .foregroundColor(.oarenaSecondary)
                                .lineLimit(nil)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Race Rules
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Race Rules")
                                .font(.headline)
                                .foregroundColor(.oarenaPrimary)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                RuleItem(text: "Complete the full distance/time as specified")
                                RuleItem(text: "Must use PM5 connected device for verification")
                                RuleItem(text: race.raceType == "Live Race" ? 
                                        "All participants race simultaneously" : 
                                        "Complete anytime during the race window")
                                RuleItem(text: "No false starts or restarts allowed")
                                RuleItem(text: "Winners receive tickets based on placement")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Join Button
                    if (race.status == .upcoming || race.status == .live) && !hasJoinedRace {
                        Button(action: {
                            if canJoinRace {
                                showingJoinConfirmation = true
                            } else if !meetsRankRequirement {
                                showingRankRequirementAlert = true
                            } else {
                                showingInsufficientTickets = true
                            }
                        }) {
                            HStack {
                                Image(systemName: race.status == .live ? "play.fill" : "person.badge.plus")
                                Text(joinButtonText)
                            }
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                canJoinRace ? 
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.oarenaAccent, Color.oarenaAccent.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ) :
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red.opacity(0.7), Color.red.opacity(0.5)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(
                                color: canJoinRace ? Color.oarenaAccent.opacity(0.3) : Color.red.opacity(0.2), 
                                radius: canJoinRace ? 8 : 4, 
                                x: 0, 
                                y: 4
                            )
                        }
                        .disabled(!canJoinRace)
                        .opacity(canJoinRace ? 1.0 : 0.8)
                        .padding(.horizontal)
                    }
                    
                    // Already Joined Status
                    if hasJoinedRace {
                        CardView(backgroundColor: Color.oarenaAccent.opacity(0.1)) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.oarenaAccent)
                                    .font(.title2)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("You've Joined This Race")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oarenaPrimary)
                                    
                                    Text("Check 'My Races' tab to see race details and start when ready.")
                                        .font(.subheadline)
                                        .foregroundColor(.oarenaSecondary)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .navigationTitle("Race Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .alert("Join Race?", isPresented: $showingJoinConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Join") {
                if userData.joinRace(race) {
                    showingJoinSuccess = true
                }
            }
        } message: {
            Text("Entry fee: \(race.entryFee) tickets\nYou will have \(userData.ticketCount - race.entryFee) tickets remaining.")
        }
        .alert("Successfully Joined!", isPresented: $showingJoinSuccess) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("You've joined \(race.title). Check your 'My Races' tab to view details and start when ready.")
        }
        .alert("Insufficient Tickets", isPresented: $showingInsufficientTickets) {
            Button("OK") { }
            Button("Buy Tickets") {
                // Open ticket store
            }
        } message: {
            Text("You need \(race.entryFee) tickets to join this race. You currently have \(userData.ticketCount) tickets.")
        }
        .alert("Rank Requirement Not Met", isPresented: $showingRankRequirementAlert) {
            Button("OK") { }
        } message: {
            Text(userData.getRankRequirementExplanation(race.rankRequirement))
        }
    }
}

struct RuleItem: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.oarenaAccent)
                .font(.caption)
                .padding(.top, 2)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.oarenaSecondary)
                .lineLimit(nil)
        }
    }
}

#Preview {
    RaceDetailView(race: RaceData.sampleFeaturedRaces[0])
} 