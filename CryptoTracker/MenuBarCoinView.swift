
//
//  MenuBarCoinView.swift
//  CryptoTracker
//
//  Created by David on 2/9/22.
//

import SwiftUI

struct MenuBarCoinView: View {
    
    @ObservedObject var viewModel: MenuBarCoinViewModel
    
    var body: some View {
        HStack(spacing: 4){
            Image(systemName: "circle.fill")
                .foregroundColor(viewModel.color)
            
            VStack(alignment: .leading, spacing: -2){
                Text(viewModel.name)
                Text(viewModel.value)
            }
            .font(.caption)
        }
        .onChange(of: viewModel.selecterdCoinType){ _ in
            viewModel.updateView()
        }
        .onAppear{