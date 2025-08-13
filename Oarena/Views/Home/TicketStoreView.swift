//
//  TicketStoreView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct TicketStoreView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategory = 0
    @ObservedObject private var userData = UserData.shared
    
    let categories = ["Ticket Packs", "Premium", "Bundles"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Current Balance Card
                    CardView(backgroundColor: Color.oarenaAccent.opacity(0.1)) {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "ticket.fill")
                                    .foregroundColor(.oarenaAction)
                                    .font(.title2)
                                
                                Text("Current Balance")
                                    .font(.headline)
                                    .foregroundColor(.oarenaPrimary)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text("\(userData.ticketCount)")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.oarenaAction)
                                
                                Text("Tickets")
                                    .font(.title3)
                                    .foregroundColor(.oarenaSecondary)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Category Selection
                    Picker("Store Category", selection: $selectedCategory) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Text(categories[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Store Content
                    if selectedCategory == 0 {
                        TicketPacksView()
                    } else if selectedCategory == 1 {
                        PremiumView()
                    } else {
                        BundlesView()
                    }
                    
                    // How to Earn Tickets Card
                    CardView(backgroundColor: Color.oarenaHighlight.opacity(0.05)) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.oarenaHighlight)
                                
                                Text("How to Earn Tickets")
                                    .font(.headline)
                                    .foregroundColor(.oarenaPrimary)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                EarnTicketsRow(icon: "figure.rowing", title: "Complete Solo Workouts", tickets: "10-25")
                                EarnTicketsRow(icon: "flag.checkered", title: "Win Races", tickets: "50-200")
                                EarnTicketsRow(icon: "trophy.fill", title: "Daily Challenges", tickets: "15-30")
                                EarnTicketsRow(icon: "calendar", title: "Weekly Streaks", tickets: "100+")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .navigationTitle("Ticket Store")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct TicketPacksView: View {
    var body: some View {
        LazyVStack(spacing: 16) {
            TicketPackCard(
                title: "Starter Pack",
                tickets: 100,
                price: "$0.99",
                bonus: nil,
                isPopular: false
            )
            
            TicketPackCard(
                title: "Training Pack",
                tickets: 500,
                price: "$4.99",
                bonus: "Best Value",
                isPopular: true
            )
            
            TicketPackCard(
                title: "Racer Pack",
                tickets: 1200,
                price: "$9.99",
                bonus: "20% Bonus",
                isPopular: false
            )
            
            TicketPackCard(
                title: "Champion Pack",
                tickets: 2500,
                price: "$19.99",
                bonus: "25% Bonus",
                isPopular: false
            )
        }
        .padding(.horizontal)
    }
}

struct PremiumView: View {
    var body: some View {
        LazyVStack(spacing: 16) {
            PremiumFeatureCard(
                title: "Premium Membership",
                subtitle: "Unlock exclusive features",
                features: [
                    "Double ticket rewards",
                    "Exclusive premium races",
                    "Advanced analytics",
                    "Priority PM5 support",
                    "Custom rank badges"
                ],
                price: "$9.99/month",
                isMonthly: true
            )
            
            PremiumFeatureCard(
                title: "Premium Annual",
                subtitle: "Save 40% with yearly plan",
                features: [
                    "All Premium features",
                    "3000 bonus tickets",
                    "Exclusive annual challenges",
                    "Premium coaching tips",
                    "Elite community access"
                ],
                price: "$59.99/year",
                isMonthly: false
            )
        }
        .padding(.horizontal)
    }
}

struct BundlesView: View {
    var body: some View {
        LazyVStack(spacing: 16) {
            BundleCard(
                title: "Beginner Bundle",
                description: "Perfect for new rowers",
                items: ["300 Tickets", "PM5 Setup Guide", "Basic Training Plan"],
                price: "$7.99",
                savings: "Save 30%"
            )
            
            BundleCard(
                title: "Competitor Bundle",
                description: "For serious racing",
                items: ["1000 Tickets", "Premium 1 Month", "Race Strategy Guide"],
                price: "$19.99",
                savings: "Save 40%"
            )
            
            BundleCard(
                title: "Elite Bundle",
                description: "Complete rowing experience",
                items: ["2500 Tickets", "Premium 3 Months", "Personal Coach Session", "Exclusive Gear"],
                price: "$49.99",
                savings: "Save 50%"
            )
        }
        .padding(.horizontal)
    }
}

struct TicketPackCard: View {
    let title: String
    let tickets: Int
    let price: String
    let bonus: String?
    let isPopular: Bool
    
    var body: some View {
        CardView(backgroundColor: isPopular ? Color.oarenaAccent.opacity(0.05) : Color(.systemBackground)) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.oarenaPrimary)
                        
                        if let bonus = bonus {
                            Text(bonus)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.oarenaHighlight)
                        }
                    }
                    
                    Spacer()
                    
                    if isPopular {
                        Text("POPULAR")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.oarenaAccent)
                            .cornerRadius(4)
                    }
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "ticket.fill")
                            .foregroundColor(.oarenaAction)
                        Text("\(tickets)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.oarenaAction)
                        Text("Tickets")
                            .font(.subheadline)
                            .foregroundColor(.oarenaSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Purchase action
                    }) {
                        Text(price)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(isPopular ? Color.oarenaAccent : Color.oarenaHighlight)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isPopular ? Color.oarenaAccent : Color.clear, lineWidth: 2)
        )
    }
}

struct PremiumFeatureCard: View {
    let title: String
    let subtitle: String
    let features: [String]
    let price: String
    let isMonthly: Bool
    
    var body: some View {
        CardView(backgroundColor: Color.oarenaAccent.opacity(0.05)) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.oarenaPrimary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.oarenaSecondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(features, id: \.self) { feature in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.oarenaAccent)
                            Text(feature)
                                .font(.subheadline)
                                .foregroundColor(.oarenaPrimary)
                        }
                    }
                }
                
                Button(action: {
                    // Subscribe action
                }) {
                    Text("Subscribe for \(price)")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.oarenaAccent)
                        .cornerRadius(12)
                }
            }
        }
    }
}

struct BundleCard: View {
    let title: String
    let description: String
    let items: [String]
    let price: String
    let savings: String
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.oarenaPrimary)
                        
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.oarenaSecondary)
                    }
                    
                    Spacer()
                    
                    Text(savings)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.oarenaHighlight)
                        .cornerRadius(4)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.oarenaAccent)
                                .font(.caption)
                            Text(item)
                                .font(.subheadline)
                                .foregroundColor(.oarenaPrimary)
                        }
                    }
                }
                
                Button(action: {
                    // Purchase bundle
                }) {
                    Text("Buy Bundle - \(price)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.oarenaHighlight)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct EarnTicketsRow: View {
    let icon: String
    let title: String
    let tickets: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.oarenaAccent)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.oarenaPrimary)
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "ticket.fill")
                    .foregroundColor(.oarenaAction)
                    .font(.caption)
                Text(tickets)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.oarenaAction)
            }
        }
    }
}

#Preview {
    TicketStoreView()
} 