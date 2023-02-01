
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
            VStack {
                Text(viewModel.title).font(.largeTitle)
                Text(viewModel.subtitle).font(.title.bold())
            }
            Divider()
            Picker("Select Coin", selection: $viewModel.selecterdCoinType){
                ForEach(viewModel.coinType){ type in
                    HStack {
                        Text(type.desccription).font(.headline)
                        Spacer()
                        Text(viewModel.valueText(for: type))
                            .frame(alignment: .trailing)
                            .font(.body)
                        
                        Link(destination: type.url){
                            Image(systemName: "safari")
                        }
                    }
                    .tag(type)
                    
                }
            }
            .pickerStyle(RadioGroupPickerStyle())
            .labelsHidden()
            
            Divider()
            
            Button("Quit"){
                NSApp.terminate(self)
            }
        }
        .onChange(of: viewModel.selecterdCoinType){ _ in
            viewModel.updateView()
        }
        .onAppear{
            viewModel.subscribeToService()
        }
    }
}

struct PopoverCoinView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverCoinView(viewModel: .init(title: "Bitcoin", subtitle: "40,000"))
    }
}