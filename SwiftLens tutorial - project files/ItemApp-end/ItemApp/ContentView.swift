//
//  ContentView.swift
//  ItemApp
//
//  Created by Karin Prater on 12/05/2025.
//

import SwiftUI
import SwiftLens

struct ContentView: View {
    
    @ObservedObject var viewModel: ItemViewModel
    @State private var newItemSheetIsShown = false
    
    let testingID = UIIdentifiers.ItemListScreen.self
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.items) { item in
                    Text(item.name)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(Color.yellow))
                        .lensTracked(id: testingID.item(item.id))
                }
            }
            .lensGroup(id: testingID.itemList)
            
            Divider()
            
            HStack {
                Button("Remove Last") {
                    viewModel.deleteLastItem()
                }
                .lensButton(id: testingID.deleteButton)
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.deleteDisabled)
               
                
                Button {
                    newItemSheetIsShown = true
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
                .lensButton(id: testingID.addButton)
                .buttonStyle(.bordered)
                
                .lensSheet(id: UIIdentifiers.AddNewItemScreen.sheet,
                           isPresented:  $newItemSheetIsShown) {
                    NewItemView(viewModel: viewModel)
                }
            }
        }
        .padding()
        .lensGroup(id: testingID.screen)
    }
}

#Preview {
    ContentView(viewModel: ItemViewModel())
}


