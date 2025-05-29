//
//  WorkoutData.swift
//  Oarena
//
//  Created by AI Assistant
//

import Foundation

struct WorkoutData: Identifiable {
    let id = UUID()
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
    let timeAgo: String
    
    // Summary info for card display
    var summary: String {
        if workoutType.contains("Just Row") {
            return "\(totalTime) • \(avgPace)/500m avg"
        } else {
            return "\(distance) • \(totalTime) • \(avgPace)/500m avg"
        }
    }
}

// Sample workout data
extension WorkoutData {
    static let sampleWorkouts: [WorkoutData] = [
        WorkoutData(
            workoutType: "5000m Distance Row",
            date: "Today, 2:30 PM",
            totalTime: "20:15.3",
            distance: "5000m",
            avgPace: "2:01.5",
            avgPower: "185W",
            avgSPM: "24",
            maxHeartRate: "168 bpm",
            calories: "325",
            ticketsEarned: 15,
            rankPointsGained: 25,
            timeAgo: "2 hours ago"
        ),
        WorkoutData(
            workoutType: "2000m Distance Row",
            date: "Yesterday, 6:00 PM",
            totalTime: "7:45.2",
            distance: "2000m",
            avgPace: "1:56.3",
            avgPower: "205W",
            avgSPM: "26",
            maxHeartRate: "175 bpm",
            calories: "165",
            ticketsEarned: 12,
            rankPointsGained: 30,
            timeAgo: "Yesterday"
        ),
        WorkoutData(
            workoutType: "30 Minute Just Row",
            date: "2 days ago, 7:30 AM",
            totalTime: "30:00.0",
            distance: "7,254m",
            avgPace: "2:04.1",
            avgPower: "175W",
            avgSPM: "22",
            maxHeartRate: "162 bpm",
            calories: "385",
            ticketsEarned: 18,
            rankPointsGained: 20,
            timeAgo: "2 days ago"
        ),
        WorkoutData(
            workoutType: "4x500m Intervals",
            date: "3 days ago, 5:15 PM",
            totalTime: "12:30.5",
            distance: "2000m",
            avgPace: "1:52.8",
            avgPower: "220W",
            avgSPM: "28",
            maxHeartRate: "182 bpm",
            calories: "195",
            ticketsEarned: 20,
            rankPointsGained: 35,
            timeAgo: "3 days ago"
        ),
        WorkoutData(
            workoutType: "10000m Distance Row",
            date: "1 week ago, 10:00 AM",
            totalTime: "42:18.7",
            distance: "10000m",
            avgPace: "2:07.9",
            avgPower: "165W",
            avgSPM: "20",
            maxHeartRate: "158 bpm",
            calories: "520",
            ticketsEarned: 25,
            rankPointsGained: 40,
            timeAgo: "1 week ago"
        )
    ]
} 