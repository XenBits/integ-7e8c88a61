//
//  CoinCapPriceService.swift
//  CryptoTracker
//
//  Created by David on 2/9/22.
//

import Combine
import Foundation
import Network

class CoinCapPriceService: NSObject, URLSessionTaskDelegate {
    
    private let session = URLSession(configuration: .default)
    private var wsTas