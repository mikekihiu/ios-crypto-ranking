//
//  NoContentView.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//
import SwiftUI

struct NoContentView: View {
    
    let description: String
    
    var body: some View {
        ContentUnavailableView(description, systemImage: "list.bullet.below.rectangle")
            .foregroundStyle(.secondary)
    }
}
