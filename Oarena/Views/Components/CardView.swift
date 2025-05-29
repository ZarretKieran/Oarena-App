//
//  CardView.swift
//  Oarena
//
//  Created by AI Assistant
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    let padding: CGFloat
    
    init(backgroundColor: Color = Color(.systemBackground), padding: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.backgroundColor = backgroundColor
        self.padding = padding
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    CardView {
        VStack {
            Text("Sample Card")
                .font(.headline)
            Text("This is a sample card with content")
                .font(.body)
        }
    }
    .padding()
} 