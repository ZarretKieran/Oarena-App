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
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<5) { index in
                    FeaturedRaceCard()
                        .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
}

struct AllRacesView: View {
    @State private var searchText = ""
    @State private var showingFilters = false
    
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
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.oarenaAccent)
                        .padding(8)
                        .background(Color.oarenaAccent.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            // Race List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0..<10) { index in
                        RaceListCard()
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
        }
        .sheet(isPresented: $showingFilters) {
            RaceFiltersView()
        }
    }
}

struct MyRacesView: View {
    @State private var selectedSection = 0
    
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
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(0..<3) { index in
                            MyRaceCard(status: .upcoming)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
            } else {
                // In Progress Races
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(0..<2) { index in
                            MyRaceCard(status: .inProgress)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
            }
        }
    }
}

struct CreateRaceView: View {
    @State private var raceName = ""
    @State private var selectedMode = 0
    @State private var selectedFormat = 0
    @State private var maxParticipants = 8
    @State private var workoutType = 0
    @State private var workoutValue = ""
    @State private var entryFee = 25
    @State private var startDate = Date()
    @State private var raceDescription = ""
    
    let raceModes = ["Duel", "Regatta", "Tournament"]
    let raceFormats = ["Live", "Asynchronous"]
    let workoutTypes = ["Distance", "Time"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Create New Race")
                            .font(.headline)
                            .foregroundColor(.oarenaPrimary)
                        
                        // Race Name
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Race Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            TextField("Enter race name", text: $raceName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Mode and Format
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Mode")
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
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Format")
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
                        }
                        
                        // Workout Configuration
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Workout")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            HStack {
                                Picker("Workout Type", selection: $workoutType) {
                                    ForEach(0..<workoutTypes.count, id: \.self) { index in
                                        Text(workoutTypes[index]).tag(index)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(maxWidth: .infinity)
                                
                                TextField(workoutType == 0 ? "meters" : "minutes", text: $workoutValue)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 80)
                            }
                        }
                        
                        // Entry Fee
                        VStack(alignment: .leading, spacing: 6) {
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
                        
                        // Start Date
                        VStack(alignment: .leading, spacing: 6) {
                            Text(selectedFormat == 0 ? "Start Time" : "Race Window Start")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaSecondary)
                            
                            DatePicker("", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 6) {
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
                        
                        // Create Button
                        Button(action: {
                            // Create race
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Schedule Race")
                            }
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.oarenaHighlight)
                            .cornerRadius(12)
                        }
                        .disabled(raceName.isEmpty || workoutValue.isEmpty)
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(.top)
        }
    }
}

struct FeaturedRaceCard: View {
    var body: some View {
        CardView(backgroundColor: Color.oarenaAccent.opacity(0.05)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Elite 2k Championship")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.oarenaPrimary)
                        
                        Text("Live Race • Regatta")
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
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Starts in 1h 30m")
                            .font(.subheadline)
                            .foregroundColor(.oarenaSecondary)
                        
                        Text("24 / 32 participants")
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Image(systemName: "ticket.fill")
                                .foregroundColor(.oarenaAction)
                            Text("50 Tickets")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaPrimary)
                        }
                        
                        Text("Prize: 1200 Tickets")
                            .font(.caption)
                            .foregroundColor(.oarenaAccent)
                    }
                }
                
                Button(action: {
                    // Join race
                }) {
                    Text("Join Race")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.oarenaAccent)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct RaceListCard: View {
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("5k Distance Challenge")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.oarenaPrimary)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "ticket.fill")
                            .foregroundColor(.oarenaAction)
                            .font(.caption)
                        Text("25")
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                    }
                }
                
                HStack {
                    Text("Async • Duel")
                        .font(.caption)
                        .foregroundColor(.oarenaHighlight)
                    
                    Spacer()
                    
                    Text("8 participants")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                }
                
                Text("Ends in 2 days")
                    .font(.caption)
                    .foregroundColor(.oarenaSecondary)
            }
        }
    }
}

struct MyRaceCard: View {
    enum RaceStatus {
        case upcoming, inProgress
    }
    
    let status: RaceStatus
    
    var body: some View {
        CardView(backgroundColor: status == .inProgress ? Color.oarenaAccent.opacity(0.05) : Color(.systemBackground)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("2k Sprint Duel")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.oarenaPrimary)
                    
                    Spacer()
                    
                    Text(status == .upcoming ? "JOINED" : "ACTIVE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(status == .upcoming ? Color.oarenaAccent : Color.oarenaHighlight)
                        .cornerRadius(4)
                }
                
                if status == .upcoming {
                    Text("Starts in 4h 15m")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                } else {
                    Text("Window ends in 1d 6h")
                        .font(.caption)
                        .foregroundColor(.oarenaSecondary)
                }
                
                if status == .inProgress {
                    Button(action: {
                        // Start race now
                    }) {
                        Text("Start Race Now")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.oarenaHighlight)
                            .cornerRadius(6)
                    }
                }
            }
        }
    }
}

struct RaceFiltersView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Race Filters")
                    .font(.headline)
                    .padding()
                
                // Filter options would go here
                
                Spacer()
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Apply") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    RaceHubView()
} 