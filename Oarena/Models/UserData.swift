//
//  UserData.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

class UserData: ObservableObject {
    @Published var ticketCount: Int = 150
    @Published var username: String = "Zarret"
    @Published var currentRank: String = "Gold III"
    
    // Navigation state
    @Published var selectedWorkoutType: Int = 0 // For training tab pre-fill
    
    // Singleton instance for shared access
    static let shared = UserData()
    
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
    
    func setWorkoutType(_ type: Int) {
        selectedWorkoutType = type
    }
} 