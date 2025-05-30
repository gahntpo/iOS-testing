//
//  NewItemView.swift
//  ItemApp
//
//  Created by Karin Prater on 24/05/2025.
//
import SwiftUI

struct NewItemView: View {
    
    @ObservedObject var viewModel: ItemViewModel
    @State private var newItemName = ""
    @Environment(\.dismiss) var dismiss
    
  private let testingID = UIIdentifiers.AddNewItemScreen.self
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Item name", text: $newItemName)
                .lensTextField(id: testingID.itemNameTextField,
                               text: $newItemName)
                .padding()
                .textFieldStyle(.roundedBorder)
                
            
            Button("Add Item") {
                if !newItemName.isEmpty {
                    viewModel.addItem(name: newItemName)
                    dismiss()
                }
            }
            .lensButton(id: testingID.addButton)
            .buttonStyle(.borderedProminent)
            .disabled(newItemName.isEmpty)
           
        }
        .padding()
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(testingID.sheet)
        
    }
}

#Preview {
    NewItemView(viewModel: .init())
}
