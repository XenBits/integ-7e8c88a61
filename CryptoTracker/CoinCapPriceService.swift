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
    private var wsTask: URLSessionWebSocketTask?
    private var pingTryCount = 0
    
    let coinDictionarySubject = CurrentValueSubject<[String: Coin], Never>([:])
    var coinDictionary: [String: Coin] {coinDictionarySubject.value}
    
    let connectionStateSubject = CurrentValueSubject<Bool, Never>(false)
    var isConnected: Bool {connectionStateSubject.value}
    
    private let 