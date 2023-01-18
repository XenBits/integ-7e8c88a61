
//
//  MenuBarCoinViewModel.swift
//  CryptoTracker
//
//  Created by David on 2/9/22.
//

import Combine
import Foundation
import SwiftUI

class MenuBarCoinViewModel: ObservableObject {
    @Published private(set) var name: String
    @Published private(set) var value: String
    @Published private(set) var color: Color
    @AppStorage("SelectedCoinType") private(set) var selecterdCoinType = CoinType.bitcoin
    
    private let service: CoinCapPriceService
    private var subscrition = Set<AnyCancellable>()
    
    private let currencyFormatter: NumberFormatter = {