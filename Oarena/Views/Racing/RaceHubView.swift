//
//  RaceHubView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct RaceHubView: View {
    @ObservedObject private var userData = UserData.shared
    @State private var selectedTab = 0
    @State private var isPM5Connected = false
    @State private var showingTicketStore = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // PM5 Connection Status
                PM5ConnectionStatusCard(isConnected: $isPM5Connected)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                
                // Tab Selection
                Picker("Race Section", selection: $selectedTab) {
                    Text("Featured").tag(0)
                    Text("All Races").tag(1)
                    Text("My Races").tag(2)
                    Text("Create").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    FeaturedRacesView()
                        .tag(0)
                    
                    AllRacesView()
                        .tag(1)
                    
                    MyRacesView()
                        .tag(2)
                    
                    CreateRaceView()
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Race")
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
        .sheet(isPresented: $showingTicketStore) {
            TicketStoreView()
        }
    }
}

struct FeaturedRacesView: View {
    @ObservedObject private var userData = UserData.shared
    @State private var selectedRace: RaceData?
    @State private var showingRaceDetail = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(RaceData.sampleFeaturedRaces) { race in
                    FeaturedRaceCard(race: race)
                        .padding(.horizontal)
                        .onTapGesture {
                            // Only allow tapping if user hasn't joined the race
                            if !userData.hasJoinedRace(race.id) {
                                selectedRace = race
                                showingRaceDetail = true
                            }
                        }
                }
            }
            .padding(.top)
        }
        .sheet(isPresented: $showingRaceDetail) {
            if let race = selectedRace {
                RaceDetailView(race: race)
            }
        }
    }
}

struct AllRacesView: View {
    @ObservedObject private var userData = UserData.shared
    @State private var searchText = ""
    @State private var showingFilters = false
    @State private var selectedRace: RaceData?
    @State private var showingRaceDetail = false
    
    // Filter states
    @State private var selectedRaceType: String = "All"
    @State private var selectedFormat: String = "All" 
    @State private var selectedStatus: String = "All"
    @State private var selectedRank: String = "All"
    @State private var entryFeeRange: ClosedRange<Double> = 0...200
    @State private var onlyShowAvailable: Bool = false
    @State private var sortBy: String = "Featured First"
    
    var filteredRaces: [RaceData] {
        var races = RaceData.sampleAllRaces
        
        // Apply search filter
        if !searchText.isEmpty {
            races = races.filter { race in
                race.title.localizedCaseInsensitiveContains(searchText) ||
                race.workoutType.localizedCaseInsensitiveContains(searchText) ||
                race.description.localizedCaseInsensitiveContains(searchText) ||
                race.createdBy.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply race type filter
        if selectedRaceType != "All" {
            races = races.filter { $0.raceType == selectedRaceType }
        }
        
        // Apply format filter
        if selectedFormat != "All" {
            races = races.filter { $0.format == selectedFormat }
        }
        
        // Apply status filter
        if selectedStatus != "All" {
            switch selectedStatus {
            case "Upcoming":
                races = races.filter { $0.status == .upcoming }
            case "In Action":
                races = races.filter { $0.status == .live }
            case "Completed":
                races = races.filter { $0.status == .completed }
            default:
                break
            }
        }
        
        // Apply rank filter
        if selectedRank != "All" {
            if selectedRank == "Open to All" {
                races = races.filter { $0.rankRequirement == nil }
            } else {
                races = races.filter { $0.rankRequirement == selectedRank }
            }
        }
        
        // Apply entry fee filter
        races = races.filter { Double($0.entryFee) >= entryFeeRange.lowerBound && Double($0.entryFee) <= entryFeeRange.upperBound }
        
        // Apply availability filter
        if onlyShowAvailable {
            races = races.filter { !userData.hasJoinedRace($0.id) }
        }
        
        // Apply sorting
        switch sortBy {
        case "Featured First":
            races = races.sorted { $0.isFeatured && !$1.isFeatured }
        case "Entry Fee (Low to High)":
            races = races.sorted { $0.entryFee < $1.entryFee }
        case "Entry Fee (High to Low)":
            races = races.sorted { $0.entryFee > $1.entryFee }
        case "Prize Pool (High to Low)":
            races = races.sorted { $0.prizePool > $1.prizePool }
        case "Participants (Most to Least)":
            races = races.sorted { extractParticipantCount($0) > extractParticipantCount($1) }
        case "Starting Soon":
            races = races.sorted { race1, race2 in
                if race1.status == .upcoming && race2.status != .upcoming { return true }
                if race1.status != .upcoming && race2.status == .upcoming { return false }
                return false // Simple comparison for now
            }
        default:
            break
        }
        
        return races
    }
    
    private func extractParticipantCount(_ race: RaceData) -> Int {
        let components = race.participants.split(separator: " ")
        if let firstComponent = components.first,
           let count = Int(firstComponent) {
            return count
        }
        return 0
    }
    
    var body: some View {
        VStack {
            // Search and Filter
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.oarenaSecondary)
                    
                    TextField("Search races...", text: $searchText)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Button(action: { showingFilters.toggle() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "slider.horizontal.3")
                        if hasActiveFilters {
                            Circle()
                                .fill(Color.oarenaHighlight)
                                .frame(width: 6, height: 6)
                        }
                    }
                    .foregroundColor(.oarenaAccent)
                    .padding(8)
                    .background(Color.oarenaAccent.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            // Active filters indicator
            if hasActiveFilters {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(activeFilters, id: \.self) { filter in
                            Text(filter)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.oarenaAccent.opacity(0.1))
                                .foregroundColor(.oarenaAccent)
                                .cornerRadius(12)
                        }
                        
                        Button("Clear All") {
                            clearAllFilters()
                        }
                        .font(.caption)
                        .foregroundColor(.oarenaHighlight)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.oarenaHighlight.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
            }
            
            // Results count
            HStack {
                Text("\(filteredRaces.count) race\(filteredRaces.count == 1 ? "" : "s") found")
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
            
            // Race List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredRaces) { race in
                        RaceListCard(race: race)
                            .padding(.horizontal)
                            .onTapGesture {
                                // Only allow tapping if user hasn't joined the race
                                if !userData.hasJoinedRace(race.id) {
                                    selectedRace = race
                                    showingRaceDetail = true
                                }
                            }
                    }
                }
                .padding(.top)
            }
        }
        .sheet(isPresented: $showingFilters) {
            RaceFiltersView(
                selectedRaceType: $selectedRaceType,
                selectedFormat: $selectedFormat,
                selectedStatus: $selectedStatus,
                selectedRank: $selectedRank,
                entryFeeRange: $entryFeeRange,
                onlyShowAvailable: $onlyShowAvailable,
                sortBy: $sortBy
            )
        }
        .sheet(isPresented: $showingRaceDetail) {
            if let race = selectedRace {
                RaceDetailView(race: race)
            }
        }
    }
    
    private var hasActiveFilters: Bool {
        selectedRaceType != "All" || 
        selectedFormat != "All" || 
        selectedStatus != "All" || 
        selectedRank != "All" ||
        entryFeeRange != 0...200 ||
        onlyShowAvailable ||
        sortBy != "Featured First"
    }
    
    private var activeFilters: [String] {
        var filters: [String] = []
        
        if selectedRaceType != "All" { filters.append(selectedRaceType) }
        if selectedFormat != "All" { filters.append(selectedFormat) }
        if selectedStatus != "All" { filters.append(selectedStatus) }
        if selectedRank != "All" { filters.append(selectedRank == "Open to All" ? "Open Races" : "\(selectedRank)+") }
        if entryFeeRange != 0...200 { 
            filters.append("\(Int(entryFeeRange.lowerBound))-\(Int(entryFeeRange.upperBound)) tickets") 
        }
        if onlyShowAvailable { filters.append("Available Only") }
        if sortBy != "Featured First" { filters.append("Sort: \(sortBy)") }
        
        return filters
    }
    
    private func clearAllFilters() {
        selectedRaceType = "All"
        selectedFormat = "All"
        selectedStatus = "All"
        selectedRank = "All"
        entryFeeRange = 0...200
        onlyShowAvailable = false
        sortBy = "Featured First"
    }
}

struct MyRacesView: View {
    @ObservedObject private var userData = UserData.shared
    @State private var selectedSection = 0
    @State private var selectedRace: RaceData?
    @State private var showingRaceDetail = false
    
    var body: some View {
        VStack {
            // Section Picker
            Picker("My Races Section", selection: $selectedSection) {
                Text("Upcoming").tag(0)
                Text("In Progress").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            if selectedSection == 0 {
                // Upcoming Races
                if userData.upcomingJoinedRaces.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 50))
                            .foregroundColor(.oarenaSecondary.opacity(0.5))
                        
                        Text("No Upcoming Races")
                            .font(.headline)
                            .foregroundColor(.oarenaSecondary)
                        
                        Text("Join races from the Featured or All Races sections to see them here.")
                            .font(.subheadline)
                            .foregroundColor(.oarenaSecondary.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 60)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(userData.upcomingJoinedRaces) { race in
                                MyJoinedRaceCard(race: race)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        selectedRace = race
                                        showingRaceDetail = true
                                    }
                            }
                        }
                        .padding(.top)
                    }
                }
            } else {
                // In Progress Races
                if userData.liveJoinedRaces.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "play.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.oarenaSecondary.opacity(0.5))
                        
                        Text("No Active Races")
                            .font(.headline)
                            .foregroundColor(.oarenaSecondary)
                        
                        Text("Join live races or async races that are currently open to see them here.")
                            .font(.subheadline)
                            .foregroundColor(.oarenaSecondary.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 60)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(userData.liveJoinedRaces) { race in
                                MyJoinedRaceCard(race: race, showStartButton: true)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        selectedRace = race
                                        showingRaceDetail = true
                                    }
                            }
                        }
                        .padding(.top)
                    }
                }
            }
        }
        .sheet(isPresented: $showingRaceDetail) {
            if let race = selectedRace {
                RaceDetailView(race: race)
            }
        }
    }
}

struct CreateRaceView: View {
    @State private var raceName = ""
    @State private var selectedMode = 0
    @State private var selectedFormat = 0
    @State private var maxParticipants = 8
    @State private var selectedWorkoutType = 0
    @State private var distance = ""
    @State private var timeMinutes = ""
    @State private var timeSeconds = ""
    @State private var intervalDistance = ""
    @State private var intervalTimeMinutes = ""
    @State private var intervalTimeSeconds = ""
    @State private var intervalRestMinutes = ""
    @State private var intervalRestSeconds = ""
    @State private var intervalCount = ""
    @State private var entryFee = 25
    @State private var startDate = Date()
    @State private var raceDescription = ""
    @State private var rankRequirement = 0
    
    let raceModes = ["Duel", "Regatta", "Tournament"]
    let raceFormats = ["Live", "Asynchronous"]
    let workoutTypes = ["Single Distance", "Single Time", "Intervals: Distance", "Intervals: Time"]
    let rankOptions = ["Open to All", "Bronze", "Silver", "Gold", "Platinum", "Elite"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header Card
                CardView(backgroundColor: Color.oarenaAccent.opacity(0.05)) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.oarenaHighlight)
                            
                            VStack(alignment: .leading) {
                                Text("Create New Race")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.oarenaPrimary)
                                
                                Text("Set up your custom rowing competition")
                                    .font(.subheadline)
                                    .foregroundColor(.oarenaSecondary)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                
                // Basic Information Card
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "textformat")
                                .foregroundColor(.oarenaAccent)
                                .font(.title3)
                            
                            Text("Basic Information")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.oarenaPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Race Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            TextField("Enter a compelling race name", text: $raceName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            TextEditor(text: $raceDescription)
                                .frame(height: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                
                // Race Configuration Card
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "gear")
                                .foregroundColor(.oarenaAccent)
                                .font(.title3)
                            
                            Text("Race Configuration")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.oarenaPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Race Mode")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            Picker("Mode", selection: $selectedMode) {
                                ForEach(0..<raceModes.count, id: \.self) { index in
                                    Text(raceModes[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Race Format")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            Picker("Format", selection: $selectedFormat) {
                                ForEach(0..<raceFormats.count, id: \.self) { index in
                                    Text(raceFormats[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Maximum Participants")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            HStack {
                                Stepper("", value: $maxParticipants, in: 2...50, step: 1)
                                    .labelsHidden()
                                
                                HStack {
                                    Image(systemName: "person.2.fill")
                                        .foregroundColor(.oarenaAccent)
                                    Text("\(maxParticipants) participants")
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaPrimary)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.oarenaAccent.opacity(0.1))
                                .cornerRadius(8)
                                
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Workout Details Card
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "stopwatch")
                                .foregroundColor(.oarenaAccent)
                                .font(.title3)
                            
                            Text("Workout Details")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.oarenaPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Workout Type")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            // Workout Type Buttons Grid (2x2 layout)
                            VStack(spacing: 12) {
                                // First row: Single Distance, Single Time
                                HStack(spacing: 12) {
                                    WorkoutTypeRaceButton(
                                        title: "Single Distance",
                                        subtitle: "Set meters",
                                        index: 0,
                                        selectedIndex: selectedWorkoutType,
                                        action: { selectedWorkoutType = 0 }
                                    )
                                    
                                    WorkoutTypeRaceButton(
                                        title: "Single Time",
                                        subtitle: "Set duration",
                                        index: 1,
                                        selectedIndex: selectedWorkoutType,
                                        action: { selectedWorkoutType = 1 }
                                    )
                                }
                                
                                // Second row: Interval types
                                HStack(spacing: 12) {
                                    WorkoutTypeRaceButton(
                                        title: "Intervals: Distance",
                                        subtitle: "Distance sets",
                                        index: 2,
                                        selectedIndex: selectedWorkoutType,
                                        action: { selectedWorkoutType = 2 }
                                    )
                                    
                                    WorkoutTypeRaceButton(
                                        title: "Intervals: Time",
                                        subtitle: "Time sets",
                                        index: 3,
                                        selectedIndex: selectedWorkoutType,
                                        action: { selectedWorkoutType = 3 }
                                    )
                                }
                            }
                        }
                        
                        // Parameters based on workout type
                        if selectedWorkoutType == 0 { // Single Distance
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Distance (meters)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaSecondary)
                                
                                TextField("e.g., 2000", text: $distance)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                        } else if selectedWorkoutType == 1 { // Single Time
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
                        } else if selectedWorkoutType == 2 { // Intervals: Distance
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
                                
                                // Rest time row
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Rest Time Between Sets")
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
                                            .font(.title3)
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
                        } else if selectedWorkoutType == 3 { // Intervals: Time
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
                                VStack(alignment: .leading, spacing: 8) {
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
                                            .font(.title3)
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
                                
                                // Rest time row
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Rest Time Between Sets")
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
                                            .font(.title3)
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
                        
                        // Workout type explanation
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.oarenaAccent)
                                .font(.caption)
                            
                            Text(getWorkoutExplanation())
                                .font(.caption)
                                .foregroundColor(.oarenaSecondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.oarenaAccent.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                // Requirements & Pricing Card
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.oarenaAction)
                                .font(.title3)
                            
                            Text("Requirements & Pricing")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.oarenaPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Rank Requirement")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            Picker("Rank Requirement", selection: $rankRequirement) {
                                ForEach(0..<rankOptions.count, id: \.self) { index in
                                    Text(rankOptions[index]).tag(index)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 120)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Entry Fee")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            HStack {
                                Stepper("", value: $entryFee, in: 0...500, step: 5)
                                    .labelsHidden()
                                
                                HStack {
                                    Image(systemName: "ticket.fill")
                                        .foregroundColor(.oarenaAction)
                                    Text("\(entryFee) Tickets")
                                        .fontWeight(.medium)
                                        .foregroundColor(.oarenaPrimary)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.oarenaAction.opacity(0.1))
                                .cornerRadius(8)
                                
                                Spacer()
                            }
                        }
                        
                        // Prize Pool Preview
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Estimated Prize Pool")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            HStack {
                                Image(systemName: "trophy.fill")
                                    .foregroundColor(.oarenaHighlight)
                                Text("\(entryFee * maxParticipants) Tickets")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.oarenaAccent)
                                
                                Spacer()
                                
                                Text("(based on max participants)")
                                    .font(.caption)
                                    .foregroundColor(.oarenaSecondary)
                                    .italic()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Timing Card
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.oarenaHighlight)
                                .font(.title3)
                            
                            Text("Race Timing")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.oarenaPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(selectedFormat == 0 ? "Race Start Time" : "Race Window Start")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            DatePicker("", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                                .accentColor(.oarenaAccent)
                        }
                        
                        // Format explanation
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.oarenaAccent)
                                .font(.caption)
                            
                            Text(selectedFormat == 0 ? 
                                 "Live races start at the exact scheduled time for all participants." : 
                                 "Async races allow participants to complete within a time window.")
                                .font(.caption)
                                .foregroundColor(.oarenaSecondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.oarenaAccent.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                // Create Race Button
                CardView(backgroundColor: Color.clear) {
                    Button(action: {
                        // Create race
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Schedule Race")
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.oarenaHighlight, Color.oarenaHighlight.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color.oarenaHighlight.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(raceName.isEmpty || !isWorkoutValid())
                    .opacity(raceName.isEmpty || !isWorkoutValid() ? 0.6 : 1.0)
                }
                .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(.top)
        }
    }
    
    private func isWorkoutValid() -> Bool {
        switch selectedWorkoutType {
        case 0: // Single Distance
            return !distance.isEmpty
        case 1: // Single Time
            return !timeMinutes.isEmpty
        case 2: // Intervals: Distance
            return !intervalDistance.isEmpty && !intervalCount.isEmpty
        case 3: // Intervals: Time
            return !intervalTimeMinutes.isEmpty && !intervalCount.isEmpty
        default:
            return false
        }
    }
    
    private func getWorkoutExplanation() -> String {
        switch selectedWorkoutType {
        case 0: // Single Distance
            return "Participants must complete the specified distance. Race winner is determined by fastest time."
        case 1: // Single Time
            return "Participants row for the specified duration. Race winner is determined by greatest distance covered."
        case 2: // Intervals: Distance
            return "Participants complete multiple distance intervals with rest periods. Total time determines winner."
        case 3: // Intervals: Time
            return "Participants complete multiple time intervals with rest periods. Total distance determines winner."
        default:
            return ""
        }
    }
}

struct WorkoutTypeRaceButton: View {
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

struct FeaturedRaceCard: View {
    let race: RaceData
    @ObservedObject private var userData = UserData.shared
    
    private var hasJoined: Bool {
        userData.hasJoinedRace(race.id)
    }
    
    var body: some View {
        CardView(backgroundColor: hasJoined ? Color.oarenaAccent.opacity(0.15) : Color.oarenaAccent.opacity(0.05)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(race.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.oarenaPrimary)
                        
                        Text("\(race.raceType) • \(race.format)")
                            .font(.subheadline)
                            .foregroundColor(.oarenaHighlight)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        if hasJoined {
                            Text("JOINED")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.oarenaAccent)
                                .cornerRadius(6)
                        }
                        
                        Text(race.rankDisplayText)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(
                                Color(race.rankColor)
                            )
                    }
                }
                
                // Workout type
                Text(race.workoutType)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.oarenaAccent)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        // Enhanced timing display
                        VStack(alignment: .leading, spacing: 2) {
                            Text(race.timingLabel)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(race.raceType == "Live Race" ? .oarenaHighlight : .oarenaAccent)
                            
                            Text(race.timingDisplayText)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.oarenaPrimary)
                            
                            Text(race.countdownDisplayText)
                                .font(.caption)
                                .foregroundColor(.oarenaSecondary)
                        }
                        
                        Text(race.participants)
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Image(systemName: "ticket.fill")
                                .foregroundColor(.oarenaAction)
                            Text("\(race.entryFee) Tickets")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaPrimary)
                        }
                        
                        Text("Prize: \(race.prizePool) Tickets")
                            .font(.caption)
                            .foregroundColor(.oarenaAccent)
                    }
                }
                
                // Status indicator and action
                HStack {
                    Text(race.statusText)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(race.status == .upcoming ? Color.oarenaAccent : 
                                  race.status == .live ? Color.oarenaHighlight : Color.oarenaSecondary)
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Text(hasJoined ? "Tap to view details" : "Tap to view details")
                        .font(.caption)
                        .foregroundColor(hasJoined ? .oarenaSecondary : .oarenaAccent)
                        .italic()
                }
            }
        }
        .contentShape(Rectangle()) // Makes entire card tappable
        .opacity(hasJoined ? 0.8 : 1.0)
    }
}

struct RaceListCard: View {
    let race: RaceData
    @ObservedObject private var userData = UserData.shared
    
    private var hasJoined: Bool {
        userData.hasJoinedRace(race.id)
    }
    
    var body: some View {
        CardView(backgroundColor: hasJoined ? Color.oarenaAccent.opacity(0.15) : Color.oarenaAccent.opacity(0.05)) {
            VStack(alignment: .leading, spacing: 12) {
                // Header row
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(race.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.oarenaPrimary)
                            .lineLimit(2)
                        
                        Text("\(race.raceType) • \(race.format)")
                            .font(.subheadline)
                            .foregroundColor(.oarenaHighlight)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        if hasJoined {
                            Text("JOINED")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.oarenaAccent)
                                .cornerRadius(6)
                        }
                        
                        // Status badge
                        Text(race.statusText)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(race.status == .upcoming ? Color.oarenaAccent : 
                                      race.status == .live ? Color.oarenaHighlight : Color.oarenaSecondary)
                            .cornerRadius(6)
                    }
                }
                
                // Workout type
                Text(race.workoutType)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.oarenaAccent)
                
                // Enhanced timing display
                VStack(alignment: .leading, spacing: 4) {
                    Text(race.timingLabel)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(race.raceType == "Live Race" ? .oarenaHighlight : .oarenaAccent)
                    
                    Text(race.timingDisplayText)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.oarenaPrimary)
                    
                    Text(race.countdownDisplayText)
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                }
                
                // Race information row
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(race.rankDisplayText)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color(race.rankColor))
                        
                        Text(race.participants)
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "ticket.fill")
                                .foregroundColor(.oarenaAction)
                                .font(.caption)
                            Text("\(race.entryFee)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaPrimary)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.oarenaHighlight)
                                .font(.caption)
                            Text("\(race.prizePool)")
                                .font(.caption)
                                .foregroundColor(.oarenaAccent)
                        }
                    }
                }
                
                // Creator and tap instruction
                HStack {
                    Text("by \(race.createdBy)")
                        .font(.caption2)
                        .foregroundColor(.oarenaSecondary)
                        .italic()
                    
                    Spacer()
                    
                    Text(hasJoined ? "Tap to view details" : "Tap to view details")
                        .font(.caption2)
                        .foregroundColor(hasJoined ? .oarenaSecondary : .oarenaAccent)
                        .italic()
                }
            }
        }
        .contentShape(Rectangle()) // Makes entire card tappable
        .opacity(hasJoined ? 0.8 : 1.0)
    }
}

struct MyJoinedRaceCard: View {
    let race: RaceData
    let showStartButton: Bool
    
    init(race: RaceData, showStartButton: Bool = false) {
        self.race = race
        self.showStartButton = showStartButton
    }
    
    var body: some View {
        CardView(backgroundColor: Color.oarenaAccent.opacity(0.05)) {
            VStack(alignment: .leading, spacing: 12) {
                // Header row
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(race.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.oarenaPrimary)
                            .lineLimit(2)
                        
                        Text("\(race.raceType) • \(race.format)")
                            .font(.subheadline)
                            .foregroundColor(.oarenaHighlight)
                    }
                    
                    Spacer()
                    
                    // Status badge
                    Text(race.statusText)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(race.status == .upcoming ? Color.oarenaAccent : 
                                  race.status == .live ? Color.oarenaHighlight : Color.oarenaSecondary)
                        .cornerRadius(6)
                }
                
                // Workout type
                Text(race.workoutType)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.oarenaAccent)
                
                // Enhanced timing display
                VStack(alignment: .leading, spacing: 4) {
                    Text(race.timingLabel)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(race.raceType == "Live Race" ? .oarenaHighlight : .oarenaAccent)
                    
                    Text(race.timingDisplayText)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.oarenaPrimary)
                    
                    Text(race.countdownDisplayText)
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                }
                
                // Race information row
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(race.rankDisplayText)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color(race.rankColor))
                        
                        Text(race.participants)
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "ticket.fill")
                                .foregroundColor(.oarenaAction)
                                .font(.caption)
                            Text("\(race.entryFee)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaPrimary)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.oarenaHighlight)
                                .font(.caption)
                            Text("\(race.prizePool)")
                                .font(.caption)
                                .foregroundColor(.oarenaAccent)
                        }
                    }
                }
                
                // Creator and tap instruction
                HStack {
                    Text("by \(race.createdBy)")
                        .font(.caption2)
                        .foregroundColor(.oarenaSecondary)
                        .italic()
                    
                    Spacer()
                    
                    Text("Tap to view details")
                        .font(.caption2)
                        .foregroundColor(.oarenaAccent)
                        .italic()
                }
                
                if showStartButton {
                    Button(action: {
                        // Start race now - would navigate to race/workout view
                        // TODO: Implement race start functionality
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text(race.raceType == "Live Race" ? "Start Live Race" : "Submit Result")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.oarenaHighlight)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .contentShape(Rectangle()) // Makes entire card tappable
    }
}

struct RaceFiltersView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedRaceType: String
    @Binding var selectedFormat: String
    @Binding var selectedStatus: String
    @Binding var selectedRank: String
    @Binding var entryFeeRange: ClosedRange<Double>
    @Binding var onlyShowAvailable: Bool
    @Binding var sortBy: String
    
    let raceTypes = ["All", "Live Race", "Async Race"]
    let formats = ["All", "Duel", "Regatta", "Tournament"]
    let statuses = ["All", "Upcoming", "In Action", "Completed"]
    let ranks = ["All", "Open to All", "Bronze", "Silver", "Gold", "Plat", "Elite"]
    let sortOptions = [
        "Featured First",
        "Entry Fee (Low to High)",
        "Entry Fee (High to Low)", 
        "Prize Pool (High to Low)",
        "Participants (Most to Least)",
        "Starting Soon"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Header Card
                    CardView(backgroundColor: Color.oarenaAccent.opacity(0.05)) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.title2)
                                    .foregroundColor(.oarenaHighlight)
                                
                                VStack(alignment: .leading) {
                                    Text("Filter Races")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.oarenaPrimary)
                                    
                                    Text("Find exactly the races you're looking for")
                                        .font(.subheadline)
                                        .foregroundColor(.oarenaSecondary)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Race Type & Format Card
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "flag.fill")
                                    .foregroundColor(.oarenaAccent)
                                    .font(.title3)
                                
                                Text("Race Type & Format")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.oarenaPrimary)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Race Type")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaSecondary)
                                
                                Picker("Race Type", selection: $selectedRaceType) {
                                    ForEach(raceTypes, id: \.self) { type in
                                        Text(type).tag(type)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Race Format")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaSecondary)
                                
                                Picker("Format", selection: $selectedFormat) {
                                    ForEach(formats, id: \.self) { format in
                                        Text(format).tag(format)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 120)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Status & Requirements Card
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.oarenaHighlight)
                                    .font(.title3)
                                
                                Text("Status & Requirements")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.oarenaPrimary)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Race Status")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaSecondary)
                                
                                Picker("Status", selection: $selectedStatus) {
                                    ForEach(statuses, id: \.self) { status in
                                        Text(status).tag(status)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Rank Requirement")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaSecondary)
                                
                                Picker("Rank", selection: $selectedRank) {
                                    ForEach(ranks, id: \.self) { rank in
                                        if rank == "All" {
                                            Text("All Ranks").tag(rank)
                                        } else if rank == "Open to All" {
                                            Text("Open Races Only").tag(rank)
                                        } else {
                                            Text("\(rank)+").tag(rank)
                                        }
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 120)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Entry Fee Range Card
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "ticket.fill")
                                    .foregroundColor(.oarenaAction)
                                    .font(.title3)
                                
                                Text("Entry Fee Range")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.oarenaPrimary)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Minimum")
                                            .font(.caption)
                                            .foregroundColor(.oarenaSecondary)
                                        
                                        HStack {
                                            Image(systemName: "ticket.fill")
                                                .foregroundColor(.oarenaAction)
                                                .font(.caption)
                                            Text("\(Int(entryFeeRange.lowerBound))")
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(.oarenaPrimary)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.oarenaAction.opacity(0.1))
                                        .cornerRadius(6)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text("Maximum")
                                            .font(.caption)
                                            .foregroundColor(.oarenaSecondary)
                                        
                                        HStack {
                                            Image(systemName: "ticket.fill")
                                                .foregroundColor(.oarenaAction)
                                                .font(.caption)
                                            Text("\(Int(entryFeeRange.upperBound))")
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(.oarenaPrimary)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.oarenaAction.opacity(0.1))
                                        .cornerRadius(6)
                                    }
                                }
                                
                                RangeSlider(
                                    range: $entryFeeRange,
                                    bounds: 0...200,
                                    step: 5
                                )
                                .padding(.top, 8)
                                
                                // Range explanation
                                HStack {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundColor(.oarenaAccent)
                                        .font(.caption)
                                    
                                    Text("Drag the sliders to set your preferred entry fee range")
                                        .font(.caption)
                                        .foregroundColor(.oarenaSecondary)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.oarenaAccent.opacity(0.05))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Availability & Sorting Card
                    CardView {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "arrow.up.arrow.down")
                                    .foregroundColor(.oarenaAccent)
                                    .font(.title3)
                                
                                Text("Availability & Sorting")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.oarenaPrimary)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Availability Filter")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaSecondary)
                                
                                HStack {
                                    Toggle("Only show races I can join", isOn: $onlyShowAvailable)
                                        .tint(.oarenaAccent)
                                    
                                    Spacer()
                                }
                                
                                if onlyShowAvailable {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.oarenaAccent)
                                            .font(.caption)
                                        
                                        Text("Excluding races you've already joined")
                                            .font(.caption)
                                            .foregroundColor(.oarenaSecondary)
                                            .italic()
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Sort Results By")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaSecondary)
                                
                                Picker("Sort By", selection: $sortBy) {
                                    ForEach(sortOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 120)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Action Buttons Card
                    CardView(backgroundColor: Color.clear) {
                        VStack(spacing: 12) {
                            // Apply Filters Button
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Apply Filters")
                                }
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.oarenaAccent, Color.oarenaAccent.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: Color.oarenaAccent.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            // Reset Filters Button
                            Button(action: {
                                resetFilters()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Reset All Filters")
                                }
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaHighlight)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.oarenaHighlight.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.oarenaSecondary),
                trailing: EmptyView()
            )
        }
    }
    
    private func resetFilters() {
        selectedRaceType = "All"
        selectedFormat = "All"
        selectedStatus = "All"
        selectedRank = "All"
        entryFeeRange = 0...200
        onlyShowAvailable = false
        sortBy = "Featured First"
    }
}

struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    let step: Double
    
    var body: some View {
        GeometryReader { geometry in
            let trackWidth = geometry.size.width
            let lowerPosition = CGFloat((range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * trackWidth
            let upperPosition = CGFloat((range.upperBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * trackWidth
            
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 4)
                
                // Active range
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.oarenaAccent)
                    .frame(width: upperPosition - lowerPosition, height: 4)
                    .offset(x: lowerPosition)
                
                // Lower thumb
                Circle()
                    .fill(Color.oarenaAccent)
                    .frame(width: 20, height: 20)
                    .offset(x: lowerPosition - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * Double(max(0, min(upperPosition - 20, value.location.x)) / trackWidth)
                                let steppedValue = round(newValue / step) * step
                                range = max(bounds.lowerBound, min(steppedValue, range.upperBound - step))...range.upperBound
                            }
                    )
                
                // Upper thumb
                Circle()
                    .fill(Color.oarenaAccent)
                    .frame(width: 20, height: 20)
                    .offset(x: upperPosition - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * Double(max(lowerPosition + 20, min(trackWidth, value.location.x)) / trackWidth)
                                let steppedValue = round(newValue / step) * step
                                range = range.lowerBound...max(range.lowerBound + step, min(bounds.upperBound, steppedValue))
                            }
                    )
            }
        }
        .frame(height: 20)
    }
}

#Preview {
    RaceHubView()
} 