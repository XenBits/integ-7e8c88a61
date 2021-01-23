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
        return view
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupCoinCapService()
        setupMenuBar()
        setupPopover()
        print("App did finish launch")
    }
    
    func setupCoinCapService(){
        coinCapService.connect()
        coinCapService.startMonitorNetworkConnectivity()
    }
}
//MARK: - MENU BAR

extension AppDelegate {
    
    
    
    func setupMenuBar(){
        menuBarCoinViewModel = MenuBarCoinViewModel(service: coinCapService)
        statusItem = NSStatusBar.system.statusItem(withLength: 64)
        guard let contentView = self.contentView,
              let menuButton = statusItem.button
        else {return}
        
        let hostingView = NSHostingView(rootView: MenuBarCoinView(viewModel: menuBarCoinViewModel))
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingView)
        
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hostingView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
        menuButton.action = #selector(menuButtonClicked)
    }
    
   @objc func menuButtonClicked() {
       if popover.isShown {
           popover.performClose(nil)
           return
       }
       guard let menuButton = statusItem.button else {return}
       let positioningView = NSView(frame: menuButton.bounds)
       positioningView.identifier = NSUserInterfaceItemIdentifier("positioningView")
       menuButton.addSubview(positioningView)
       
       popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .maxY)
       menuButton.bounds = menuButton.bounds.offsetBy(dx: 0, dy: menuButton.bounds.height)
       popover.contentViewController?.view.window?.makeKey()
        
    }
}
//MARK: - Popover

extension AppDelegate: NSPopoverDelegate {
    func setupPopover(){
        popoverCoinViewModel = .init(service: coinCapService)
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = 