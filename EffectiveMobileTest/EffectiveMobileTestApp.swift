//
//  EffectiveMobileTestApp.swift
//  EffectiveMobileTest
//
//  Created by Сергей on 23.08.2024.
//

import SwiftUI

@main
struct EffectiveMobileTestApp: App {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
    }
}
