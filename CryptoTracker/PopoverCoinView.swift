
//
//  PopoverCoinView.swift
//  CryptoTracker
//
//  Created by David on 2/9/22.
//

import SwiftUI

struct PopoverCoinView: View {
    @ObservedObject var viewModel: PopoverCoinViewModel
    
    var body: some View {
        VStack(spacing: 16){