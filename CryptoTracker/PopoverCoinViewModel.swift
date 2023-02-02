
//
//  PopoverCoinViewModel.swift
//  CryptoTracker
//
//  Created by David on 2/9/22.
//

import Combine
import Foundation
import SwiftUI

class PopoverCoinViewModel: ObservableObject {
    @Published private(set) var title: String
    @Published private(set) var subtitle: String
    @Published private(set) var coinType: [CoinType]
    @AppStorage("SelectedCoinType") var selecterdCoinType = CoinType.bitcoin
    
    private let service: CoinCapPriceService
    private var subscrition = Set<AnyCancellable>()
    
    private let currencyFormatter: NumberFormatter = {
       let  formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "USD"
        return formatter
    }()
    
    init(title: String = "", subtitle: String = "", coinTypes: [CoinType] = CoinType.allCases, service: CoinCapPriceService = .init()){
        self.title = title
        self.subtitle = subtitle
        self.coinType = coinTypes
        self.service = service
        
    }
    
    func subscribeToService(){
        service.coinDictionarySubject
            .receive(on: DispatchQueue.main)
            .sink{[weak self] _ in self?.updateView()}
            .store(in: &subscrition)
    }
    
    func updateView(){