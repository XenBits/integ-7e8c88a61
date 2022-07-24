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
    
    private let monitor = NWPathMonitor()
    
    func connect() {
        let coins = CoinType.allCases
            .map{$0.rawValue}
            .joined(separator: ",")
        
        let url = URL(string: "wss://ws.coincap.io/prices?assets=\(coins)")!
        wsTask = session.webSocketTask(with: url)
        wsTask?.delegate = self
        wsTask?.resume()
        self.receiveMessage()
        self.schedulePing()
        
    }
    
    func startMonitorNetworkConnectivity() {
        monitor.pathUpdateHandler = {[weak self] path in
            guard let self = self else {return }
            if path.status == .satisfied, self.wsTask == nil {
                self.connect()
            }
            if path.status != .satisfied {
                self.clearConnection()
            }
        }
        monitor.start(queue: .main)
    }
    
    private func receiveMessage() {
        wsTask?.receive {[weak self] result in
            
            guard let self = self else {return}
            
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text message: \(text)")
                    if let data = text.data(using: .utf8){
                        self.onReceiveData(data)
                    }
                    break
                case .data(let d