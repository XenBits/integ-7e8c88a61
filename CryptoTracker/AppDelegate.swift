//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by David on 2/8/22.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var menuBarCoinViewModel: MenuBarCoinViewModel!
    var popoverCoinViewModel: PopoverCoinViewModel!
    
    var coinCapService = CoinCapPriceService()
    var statusItem: NSStatusItem!
    let popover = NSPopover()
    
    private lazy var contentView: NSView? = {
        let view = (statusItem.value(forKey: "window") as? NSWindow)?.contentView
       