//
//  ContentView.swift
//  ItemApp
//
//  Created by Karin Prater on 12/05/2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.items) { item in
                    Text(item.name)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(Color.yellow))
                        .accessibilityIdentifier("item.\(item)")
                }
            }
            
            Divider()
            
            Button("Remove Last") {
                viewModel.deleteLastItem()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.deleteDisabled)
            .accessibilityIdentifier("delete.button")
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: ItemViewModel())
}
