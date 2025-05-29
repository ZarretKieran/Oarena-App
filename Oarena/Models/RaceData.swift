//
//  RaceData.swift
//  Oarena
//
//  Created by AI Assistant
//

import Foundation

struct RaceData: Identifiable, Codable {
    let id: String
    let title: String
    let raceType: String // "Live Race", "Async Race"
    let format: String // "Regatta", "Duel", "Tournament"
    let workoutType: String // "2000m", "5000m", "20 min", etc.
    let startTime: String // "Starts in 1h 30m", "Started 2h ago", etc.
    let participants: String // "24 / 32 participants"
    let entryFee: Int // Tickets required to join
    let prizePool: Int // Total prize in tickets
    let description: String
    let timeRemaining: String
    let status: RaceStatus
    let isFeatured: Bool
    let rankRequirement: String? // "Bronze", "Silver", "Gold", "Plat", "Elite", or nil for open races
    let createdBy: String // Username who created the race
    let specificStartDateTime: String // "Today 8:00 PM", "Tomorrow 2:00 PM"
    let specificDeadlineDateTime: String // "Sunday 11:59 PM", "Dec 15 9:00 AM"
    
    enum RaceStatus: Codable {
        case upcoming, live, completed
    }
    
    var statusText: String {
        switch status {
        case .upcoming:
            return "UPCOMING"
        case .live:
            return "IN ACTION"
        case .completed:
            return "COMPLETED"
        }
    }
    
    var statusColor: String {
        switch status {
        case .upcoming:
            return "oarenaAccent"
        case .live:
            return "oarenaHighlight"
        case .completed:
            return "oarenaSecondary"
        }
    }
    
    var rankDisplayText: String {
        if let rank = rankRequirement {
            return "Open to: \(rank)+"
        } else {
            return "Open to: All Ranks"
        }
    }
    
    var rankColor: String {
        guard let requirement = rankRequirement else {
            return "oarenaAccent" // Use accent color for open races
        }
        
        switch requirement {
        case "Bronze":
            return "brown"
        case "Silver":
            return "gray"
        case "Gold":
            return "yellow"
        case "Plat":
            return "cyan"
        case "Elite":
            return "purple"
        default:
            return "oarenaSecondary"
        }
    }
    
    // Computed properties for clear timing display
    var timingLabel: String {
        if raceType == "Live Race" {
            return status == .upcoming ? "Live Start" : "Started At"
        } else {
            return status == .live ? "Deadline" : "Submission Window"
        }
    }
    
    var timingDisplayText: String {
        if raceType == "Live Race" {
            return specificStartDateTime
        } else {
            return specificDeadlineDateTime
        }
    }
    
    var countdownDisplayText: String {
        if raceType == "Live Race" {
            return status == .upcoming ? "Starts \(timeRemaining)" : "Started \(timeRemaining) ago"
        } else {
            return status == .live ? "Deadline in \(timeRemaining)" : "Opens in \(timeRemaining)"
        }
    }
    
    static let sampleFeaturedRaces: [RaceData] = [
        RaceData(
            id: "Elite 2k Championship",
            title: "Elite 2k Championship",
            raceType: "Live Race",
            format: "Regatta",
            workoutType: "2000m",
            startTime: "Starts in 1h 30m",
            participants: "24 / 32 participants",
            entryFee: 50,
            prizePool: 1200,
            description: "The ultimate test of speed and endurance. Elite rowers compete for the championship title in this high-stakes 2000m sprint.",
            timeRemaining: "1h 30m",
            status: .upcoming,
            isFeatured: true,
            rankRequirement: "Elite",
            createdBy: "OarenaOfficial",
            specificStartDateTime: "Today 8:00 PM",
            specificDeadlineDateTime: "N/A"
        ),
        
        RaceData(
            id: "Weekend Warriors 5k",
            title: "Weekend Warriors 5k",
            raceType: "Async Race",
            format: "Tournament",
            workoutType: "5000m",
            startTime: "Started 2h ago",
            participants: "156 / 200 participants",
            entryFee: 25,
            prizePool: 2000,
            description: "Perfect for weekend fitness enthusiasts! Complete your 5k anytime this weekend and compete for amazing prizes.",
            timeRemaining: "1d 22h",
            status: .live,
            isFeatured: true,
            rankRequirement: "Silver",
            createdBy: "FitnessGuru42",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Sunday 11:59 PM"
        ),
        
        RaceData(
            id: "Community Open 10k",
            title: "Community Open 10k",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "10000m",
            startTime: "Starts in 2h 45m",
            participants: "89 / 150 participants",
            entryFee: 30,
            prizePool: 1500,
            description: "Open to all rowers! Join our inclusive community race where everyone is welcome. Whether you're a beginner or experienced, come row together in this friendly 10k challenge.",
            timeRemaining: "2h 45m",
            status: .upcoming,
            isFeatured: true,
            rankRequirement: nil,
            createdBy: "CommunityManager",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Monday 6:00 PM"
        ),
        
        RaceData(
            id: "Beginner's Sprint Duel",
            title: "Beginner's Sprint Duel",
            raceType: "Live Race",
            format: "Duel",
            workoutType: "1000m",
            startTime: "Starts in 45m",
            participants: "6 / 8 participants",
            entryFee: 15,
            prizePool: 80,
            description: "New to racing? This is the perfect introduction! 1000m sprint with other beginners in a friendly competition.",
            timeRemaining: "45m",
            status: .upcoming,
            isFeatured: true,
            rankRequirement: "Bronze",
            createdBy: "RowingCoach",
            specificStartDateTime: "Today 7:15 PM",
            specificDeadlineDateTime: "N/A"
        ),
        
        RaceData(
            id: "30-Minute Endurance Challenge",
            title: "30-Minute Endurance Challenge",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "30 minutes",
            startTime: "Starts in 3h 15m",
            participants: "42 / 50 participants",
            entryFee: 35,
            prizePool: 850,
            description: "How far can you row in 30 minutes? Test your endurance against rowers worldwide in this distance accumulation challenge.",
            timeRemaining: "3h 15m",
            status: .upcoming,
            isFeatured: true,
            rankRequirement: "Gold",
            createdBy: "EnduranceKing",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Dec 15 9:00 AM"
        ),
        
        RaceData(
            id: "Lightning Speed 500m",
            title: "Lightning Speed 500m",
            raceType: "Live Race",
            format: "Tournament",
            workoutType: "500m",
            startTime: "Starts in 20m",
            participants: "12 / 16 participants",
            entryFee: 20,
            prizePool: 200,
            description: "Pure explosive power! The shortest race with the highest intensity. Show off your lightning speed in this 500m all-out sprint.",
            timeRemaining: "20m",
            status: .upcoming,
            isFeatured: true,
            rankRequirement: "Plat",
            createdBy: "SprintMaster",
            specificStartDateTime: "Today 6:50 PM",
            specificDeadlineDateTime: "N/A"
        )
    ]
    
    static var sampleAllRaces: [RaceData] = [
        // Featured races are included in all races
        sampleFeaturedRaces[0], // Elite 2k Championship
        sampleFeaturedRaces[1], // Weekend Warriors 5k  
        sampleFeaturedRaces[2], // Community Open 10k
        sampleFeaturedRaces[3], // Beginner's Sprint Duel
        sampleFeaturedRaces[4], // 30-Minute Endurance Challenge
        sampleFeaturedRaces[5], // Lightning Speed 500m
        
        // Additional Global Races - Representing a worldwide race platform
        
        // Elite/Professional Level Races
        RaceData(
            id: "World Championship Qualifier",
            title: "World Championship Qualifier",
            raceType: "Live Race",
            format: "Tournament",
            workoutType: "2000m",
            startTime: "Starts in 2h 15m",
            participants: "48 / 64 participants",
            entryFee: 75,
            prizePool: 2500,
            description: "Qualify for the World Championship! Top 8 finishers advance to the global finals.",
            timeRemaining: "2h 15m",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Elite",
            createdBy: "WorldRowing",
            specificStartDateTime: "Today 9:30 PM",
            specificDeadlineDateTime: "N/A"
        ),
        
        RaceData(
            id: "International Open 6k",
            title: "International Open 6k",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "6000m",
            startTime: "Ends in 3d 4h",
            participants: "287 / 500 participants",
            entryFee: 60,
            prizePool: 8500,
            description: "Global competition with rowers from 45+ countries. Huge prize pool!",
            timeRemaining: "3d 4h",
            status: .live,
            isFeatured: false,
            rankRequirement: "Plat",
            createdBy: "GlobalRowing",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Friday 8:00 PM"
        ),
        
        // Platinum/Gold Level Races
        RaceData(
            id: "Masters Tournament 5k",
            title: "Masters Tournament 5k",
            raceType: "Live Race",
            format: "Tournament",
            workoutType: "5000m",
            startTime: "Starts in 4h 30m",
            participants: "32 / 32 participants",
            entryFee: 45,
            prizePool: 800,
            description: "Experienced rowers compete in this prestigious masters event.",
            timeRemaining: "4h 30m",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Gold",
            createdBy: "MastersClub",
            specificStartDateTime: "Today 10:45 PM",
            specificDeadlineDateTime: "N/A"
        ),
        
        RaceData(
            id: "Speed Demon 750m",
            title: "Speed Demon 750m",
            raceType: "Live Race",
            format: "Duel",
            workoutType: "750m",
            startTime: "Starts in 1h 45m",
            participants: "14 / 16 participants",
            entryFee: 30,
            prizePool: 350,
            description: "Fast and furious! Short distance, maximum intensity sprint.",
            timeRemaining: "1h 45m",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Plat",
            createdBy: "SpeedDevil",
            specificStartDateTime: "Today 8:00 PM",
            specificDeadlineDateTime: "N/A"
        ),
        
        RaceData(
            id: "Golden Hour 4k",
            title: "Golden Hour 4k",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "4000m",
            startTime: "Ends in 1d 12h",
            participants: "95 / 120 participants",
            entryFee: 40,
            prizePool: 1200,
            description: "Row your best 4k during the golden hour - sunrise or sunset!",
            timeRemaining: "1d 12h",
            status: .live,
            isFeatured: false,
            rankRequirement: "Gold",
            createdBy: "SunriseRower",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Tomorrow 6:00 PM"
        ),
        
        // Silver Level Races
        RaceData(
            id: "Silver Standard 3k",
            title: "Silver Standard 3k",
            raceType: "Async Race",
            format: "Tournament",
            workoutType: "3000m",
            startTime: "Starts in 6h",
            participants: "67 / 80 participants",
            entryFee: 25,
            prizePool: 600,
            description: "Perfect challenge for developing rowers. Prove your silver standard!",
            timeRemaining: "6h",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Silver",
            createdBy: "SilverLeague",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Wednesday 11:00 PM"
        ),
        
        RaceData(
            id: "Lunch Break 1500m",
            title: "Lunch Break 1500m",
            raceType: "Live Race",
            format: "Duel",
            workoutType: "1500m",
            startTime: "Starts in 30m",
            participants: "8 / 8 participants",
            entryFee: 20,
            prizePool: 120,
            description: "Quick race perfect for your lunch break! Short but sweet.",
            timeRemaining: "30m",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Silver",
            createdBy: "OfficeRower",
            specificStartDateTime: "Today 7:45 PM",
            specificDeadlineDateTime: "N/A"
        ),
        
        RaceData(
            id: "Steady State Challenge",
            title: "Steady State Challenge",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "8000m",
            startTime: "Ends in 5d 2h",
            participants: "134 / 200 participants",
            entryFee: 35,
            prizePool: 1400,
            description: "Long, steady endurance race. Maintain your pace over 8k!",
            timeRemaining: "5d 2h",
            status: .live,
            isFeatured: false,
            rankRequirement: "Silver",
            createdBy: "EnduranceCoach",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Monday 9:00 AM"
        ),
        
        // Bronze Level & Open Races
        RaceData(
            id: "Newbie Friendly 2k",
            title: "Newbie Friendly 2k",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "2000m",
            startTime: "Starts in 8h",
            participants: "45 / 60 participants",
            entryFee: 15,
            prizePool: 300,
            description: "Perfect first race for new rowers! Supportive community cheering you on.",
            timeRemaining: "8h",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Bronze",
            createdBy: "WelcomeCommittee",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Thursday 10:00 PM"
        ),
        
        RaceData(
            id: "Coffee Break 800m",
            title: "Coffee Break 800m",
            raceType: "Live Race",
            format: "Duel",
            workoutType: "800m",
            startTime: "Starts in 15m",
            participants: "6 / 8 participants",
            entryFee: 10,
            prizePool: 60,
            description: "Quick sprint while your coffee brews! Short and energizing.",
            timeRemaining: "15m",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Bronze",
            createdBy: "CaffeinatedRower",
            specificStartDateTime: "Today 7:30 PM",
            specificDeadlineDateTime: "N/A"
        ),
        
        RaceData(
            id: "Family Fun Row",
            title: "Family Fun Row",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "2500m",
            startTime: "Ends in 2d 8h",
            participants: "89 / 100 participants",
            entryFee: 20,
            prizePool: 500,
            description: "Bring the whole family! Open to all ages and skill levels. Fun over competition!",
            timeRemaining: "2d 8h",
            status: .live,
            isFeatured: false,
            rankRequirement: nil,
            createdBy: "FamilyRowing",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Saturday 4:00 PM"
        ),
        
        RaceData(
            id: "Charity 10k for Health",
            title: "Charity 10k for Health",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "10000m",
            startTime: "Ends in 6d 4h",
            participants: "234 / 300 participants",
            entryFee: 25,
            prizePool: 2000,
            description: "Row for a good cause! All entry fees donated to health research. Everyone welcome!",
            timeRemaining: "6d 4h",
            status: .live,
            isFeatured: false,
            rankRequirement: nil,
            createdBy: "CharityOrg",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Next Tuesday 6:00 PM"
        ),
        
        // Time-based races
        RaceData(
            id: "Power Hour Challenge",
            title: "Power Hour Challenge",
            raceType: "Async Race",
            format: "Tournament",
            workoutType: "60 minutes",
            startTime: "Starts tomorrow",
            participants: "23 / 40 participants",
            entryFee: 50,
            prizePool: 1000,
            description: "One full hour of rowing. How far can you go? Distance accumulation race.",
            timeRemaining: "18h",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Gold",
            createdBy: "PowerHour",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Friday 7:00 PM"
        ),
        
        RaceData(
            id: "Quick 20 Minutes",
            title: "Quick 20 Minutes",
            raceType: "Live Race",
            format: "Regatta",
            workoutType: "20 minutes",
            startTime: "Starts in 3h 20m",
            participants: "16 / 20 participants",
            entryFee: 30,
            prizePool: 400,
            description: "See how far you can row in exactly 20 minutes. Consistent pace is key!",
            timeRemaining: "3h 20m",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Silver",
            createdBy: "TimeTrialer",
            specificStartDateTime: "Today 11:05 PM",
            specificDeadlineDateTime: "N/A"
        ),
        
        // International/Regional Events
        RaceData(
            id: "European Championship Heat",
            title: "European Championship Heat",
            raceType: "Live Race",
            format: "Tournament",
            workoutType: "2000m",
            startTime: "Starts in 5h 45m",
            participants: "24 / 24 participants",
            entryFee: 65,
            prizePool: 1800,
            description: "Qualifying heat for European Championship. Elite European rowers compete.",
            timeRemaining: "5h 45m",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Elite",
            createdBy: "EuroRowing",
            specificStartDateTime: "Tomorrow 12:30 AM",
            specificDeadlineDateTime: "N/A"
        ),
        
        RaceData(
            id: "Pacific Rim 5k",
            title: "Pacific Rim 5k",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "5000m",
            startTime: "Ends in 4d 6h",
            participants: "156 / 180 participants",
            entryFee: 40,
            prizePool: 2200,
            description: "Rowers from around the Pacific compete in this prestigious 5k event.",
            timeRemaining: "4d 6h",
            status: .live,
            isFeatured: false,
            rankRequirement: "Plat",
            createdBy: "PacificRowing",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Sunday 2:00 PM"
        ),
        
        RaceData(
            id: "Americas Cup Qualifier",
            title: "Americas Cup Qualifier",
            raceType: "Live Race",
            format: "Tournament",
            workoutType: "1500m",
            startTime: "Starts in 7h 10m",
            participants: "32 / 32 participants",
            entryFee: 55,
            prizePool: 1200,
            description: "North and South American rowers battle for Cup qualification spots.",
            timeRemaining: "7h 10m",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Plat",
            createdBy: "AmericasCup",
            specificStartDateTime: "Tomorrow 2:25 AM",
            specificDeadlineDateTime: "N/A"
        ),
        
        // Daily/Regular events
        RaceData(
            id: "Daily Distance Challenge",
            title: "Daily Distance Challenge",
            raceType: "Async Race",
            format: "Duel",
            workoutType: "3000m",
            startTime: "Ends in 6h",
            participants: "18 / 20 participants",
            entryFee: 10,
            prizePool: 120,
            description: "Daily challenge for consistent rowers. Small entry, quick race!",
            timeRemaining: "6h",
            status: .live,
            isFeatured: false,
            rankRequirement: "Bronze",
            createdBy: "DailyRower",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Tomorrow 12:00 AM"
        ),
        
        RaceData(
            id: "Tuesday Night Special",
            title: "Tuesday Night Special",
            raceType: "Live Race",
            format: "Duel",
            workoutType: "2500m",
            startTime: "Starts in 25h",
            participants: "10 / 12 participants",
            entryFee: 25,
            prizePool: 200,
            description: "Weekly Tuesday tradition! Regular racers know this one well.",
            timeRemaining: "25h",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Silver",
            createdBy: "TuesdayTraditional",
            specificStartDateTime: "Tuesday 8:00 PM",
            specificDeadlineDateTime: "N/A"
        ),
        
        RaceData(
            id: "Weekend Warrior Revival",
            title: "Weekend Warrior Revival",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "7500m",
            startTime: "Starts in 3d",
            participants: "45 / 75 participants",
            entryFee: 35,
            prizePool: 900,
            description: "For those who row hard on weekends! Longer distance weekend challenge.",
            timeRemaining: "3d",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Gold",
            createdBy: "WeekendWarriors",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Next Monday 8:00 AM"
        ),
        
        // Extreme/Special Events
        RaceData(
            id: "Midnight Marathon",
            title: "Midnight Marathon",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "21097m",
            startTime: "Starts tomorrow",
            participants: "8 / 25 participants",
            entryFee: 100,
            prizePool: 1500,
            description: "The ultimate endurance test - a full marathon row. Only for the dedicated!",
            timeRemaining: "16h",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Elite",
            createdBy: "MarathonMike",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "Dec 20 11:59 PM"
        ),
        
        RaceData(
            id: "100k Ultra Challenge",
            title: "100k Ultra Challenge",
            raceType: "Async Race",
            format: "Tournament",
            workoutType: "100000m",
            startTime: "Starts in 1 week",
            participants: "3 / 10 participants",
            entryFee: 200,
            prizePool: 3000,
            description: "EXTREME: 100 kilometer row over 30 days. Only the most dedicated dare attempt!",
            timeRemaining: "1 week",
            status: .upcoming,
            isFeatured: false,
            rankRequirement: "Elite",
            createdBy: "UltraEndurance",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "January 15 11:59 PM"
        ),
        
        // Fun/Themed Races
        RaceData(
            id: "Holiday Spirit 3k",
            title: "Holiday Spirit 3k",
            raceType: "Async Race",
            format: "Regatta",
            workoutType: "3000m",
            startTime: "Ends in 3d 12h",
            participants: "78 / 100 participants",
            entryFee: 20,
            prizePool: 600,
            description: "Celebrate the holidays with fellow rowers! Festive fun and friendly competition.",
            timeRemaining: "3d 12h",
            status: .live,
            isFeatured: false,
            rankRequirement: nil,
            createdBy: "HolidaySpirit",
            specificStartDateTime: "N/A",
            specificDeadlineDateTime: "December 25 6:00 PM"
        )
    ]
} 