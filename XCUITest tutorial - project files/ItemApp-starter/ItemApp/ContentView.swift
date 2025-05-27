//
//  ContentView.swift
//  ItemApp
//
//  Created by Karin Prater on 12/05/2025.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ItemViewModel
    @State private var newItemSheetIsShown = false
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.items) { item in
                    Text(item.name)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(Color.yellow))
                }
            }
            
            Divider()
            
            HStack {
                Button("Remove Last") {
                    viewModel.deleteLastItem()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.deleteDisabled)
                
                Button {
                    newItemSheetIsShown = true
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $newItemSheetIsShown) {
                    NewItemView(viewModel: viewModel)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: ItemViewModel())
}


