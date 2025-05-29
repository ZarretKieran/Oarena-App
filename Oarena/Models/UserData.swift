//
//  UserData.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

enum RaceUserStatus {
    case notJoined
    case joined 
    case owner
}

class UserData: ObservableObject {
    @Published var ticketCount: Int = 150
    @Published var username: String = "Zarret"
    @Published var currentRank: String = "Gold III"
    @Published var joinedRaces: [RaceData] = [] // Track joined races
    @Published var createdRaces: [String] = [] // Track race IDs that user created
    
    // Navigation state
    @Published var selectedWorkoutType: Int = 0 // For training tab pre-fill
    
    // Singleton instance for shared access
    static let shared = UserData()
    
    // Rank hierarchy for comparison
    private let rankHierarchy: [String] = [
        "Bronze", "Silver", "Gold", "Plat", "Elite"
    ]
    
    private init() {}
    
    func spendTickets(_ amount: Int) -> Bool {
        if ticketCount >= amount {
            ticketCount -= amount
            return true
        }
        return false
    }
    
    func earnTickets(_ amount: Int) {
        ticketCount += amount
    }
    
    func addTickets(_ amount: Int) {
        ticketCount += amount
        // Ensure tickets don't go below 0
        if ticketCount < 0 {
            ticketCount = 0
        }
    }
    
    func setWorkoutType(_ type: Int) {
        selectedWorkoutType = type
    }
    
    // Race joining functionality
    func joinRace(_ race: RaceData) -> Bool {
        // Check if already joined
        if hasJoinedRace(race.id) {
            return false
        }
        
        // Check if user can afford and meets requirements
        guard spendTickets(race.entryFee), meetsRankRequirement(race.rankRequirement) else {
            return false
        }
        
        // Add to joined races
        joinedRaces.append(race)
        return true
    }
    
    func hasJoinedRace(_ raceId: String) -> Bool {
        return joinedRaces.contains { $0.id == raceId }
    }
    
    // Get joined races by status
    var upcomingJoinedRaces: [RaceData] {
        return joinedRaces.filter { $0.status == .upcoming }
    }
    
    var liveJoinedRaces: [RaceData] {
        return joinedRaces.filter { $0.status == .live }
    }
    
    // Get the base rank (without tier number) from currentRank
    var baseRank: String {
        // Extract base rank from "Gold III" -> "Gold"
        let components = currentRank.components(separatedBy: " ")
        return components.first ?? "Bronze"
    }
    
    // Check if user meets rank requirement for a race
    func meetsRankRequirement(_ requiredRank: String?) -> Bool {
        // If no rank requirement, race is open to all
        guard let requiredRank = requiredRank else {
            return true
        }
        
        guard let userRankIndex = rankHierarchy.firstIndex(of: baseRank),
              let requiredRankIndex = rankHierarchy.firstIndex(of: requiredRank) else {
            return false
        }
        
        return userRankIndex >= requiredRankIndex
    }
    
    // Get explanation for rank requirement not met
    func getRankRequirementExplanation(_ requiredRank: String?) -> String {
        guard let requiredRank = requiredRank else {
            return "This race is open to all ranks."
        }
        return "Requires \(requiredRank)+ rank. You are currently \(currentRank)."
    }
    
    // Race creation tracking
    func addCreatedRace(_ raceId: String) {
        if !createdRaces.contains(raceId) {
            createdRaces.append(raceId)
        }
    }
    
    func hasCreatedRace(_ raceId: String) -> Bool {
        return createdRaces.contains(raceId)
    }
    
    // Check if user is owner vs just joined
    func getUserRaceStatus(_ raceId: String) -> RaceUserStatus {
        if hasCreatedRace(raceId) {
            return .owner
        } else if hasJoinedRace(raceId) {
            return .joined
        } else {
            return .notJoined
        }
    }
} 