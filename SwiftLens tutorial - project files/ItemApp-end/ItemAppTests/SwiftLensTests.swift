//
//  SwiftLensTests.swift
//  ItemAppTests
//
//  Created by Karin Prater on 27/05/2025.
//

import Testing
@testable import ItemApp
import SwiftLensTestSupport

struct SwiftLensTests {
    
    let itemListScreen = UIIdentifiers.ItemListScreen.self
    let newItemScreen = UIIdentifiers.AddNewItemScreen.self
    
    @MainActor
    @Test("Show items for initial state")
    func test_items_shown() async throws {
        let vm = ItemViewModel()
        let sut = LensWorkBench { _ in
            ContentView(viewModel: vm)
        }
        
       try await sut.observer.waitForViewCount(withViewIDPrefix: itemListScreen.item(nil),
                                      expected: 4)
    }

    @MainActor
    @Test("Add new item")
    func test_add_new_item() async throws {
        // --- GIVEN ---
        let vm = ItemViewModel()
        let sut = LensWorkBench { _ in
            ContentView(viewModel: vm)
        }
        
        let rowID = itemListScreen.item(nil)
        let initialCount = vm.items.count
        try await sut.observer.waitForViewCount(withViewIDPrefix: rowID,
                                       expected: initialCount)
        
        // --- THEN ---
        
        sut.interactor.tapButton(withID: itemListScreen.addButton)
        
        try await sut.observer.waitForViewVisible(withID: newItemScreen.sheet)
        #expect(sut.observer.textFieldText(forViewID: newItemScreen.itemNameTextField, equalTo: ""),
                "Textfield should be when sheet is opened")
        
        let new = "Test Item"
        sut.interactor.textField(withID: newItemScreen.itemNameTextField, to: new)
       
        
        try await sut.observer.waitButton(forViewID: newItemScreen.addButton, isEnabled: true)
        sut.interactor.tapButton(withID: newItemScreen.addButton)
        
        // --- WHEN ---
        
        try await sut.observer.waitForViewHidden(withID: newItemScreen.sheet)
        try await sut.observer.waitForViewCount(withViewIDPrefix: rowID,
                                       expected: initialCount + 1)
        
    }
    
    @MainActor
    @Test
    func test_when_press_remove_last_button_then_updates_item_list() async throws {
        // --- GIVEN ---
        let vm = ItemViewModel()
        let sut = LensWorkBench { _ in
            ContentView(viewModel: vm)
        }
        
        let rowID = itemListScreen.item(nil)
        let initialCount = vm.items.count
        try await sut.observer.waitForViewCount(withViewIDPrefix: rowID,
                                       expected: initialCount)
        
        // --- WHEN ---
        sut.interactor.tapButton(withID: itemListScreen.deleteButton)
        
        // --- THEN ---
        try await sut.observer.waitForViewCount(withViewIDPrefix: rowID,
                                       expected: initialCount - 1)
    }
    
    @MainActor
    @Test
    func test_when_all_items_removed_then_remove_disabled() async throws {
        // --- GIVEN ---
        let vm = ItemViewModel()
        let sut = LensWorkBench { _ in
            ContentView(viewModel: vm)
        }
        
        let rowID = itemListScreen.item(nil)
        let initialCount = vm.items.count
        try await sut.observer.waitForViewCount(withViewIDPrefix: rowID,
                                       expected: initialCount)
        
        // --- WHEN ---
        for _ in 0..<initialCount {
            sut.interactor.tapButton(withID: itemListScreen.deleteButton)
        }
        
        // --- THEN ---
        try await sut.observer.waitForViewCount(withViewIDPrefix: rowID,
                                                expected: 0)
        
        #expect(sut.observer.isDisabledState(forViewID: itemListScreen.deleteButton))
        
    }
}
