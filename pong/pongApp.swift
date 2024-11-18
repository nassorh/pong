//
//  pongApp.swift
//  pong
//
//  Created by Nassor, Hamad on 07/11/2024.
//

import SwiftUI

@main
struct pongApp: App {
    var body: some Scene {
        WindowGroup {
            let screenBounds = UIScreen.main.bounds
            let viewModel = PongViewModel(screenBounds: screenBounds)
            ContentView(viewModel: viewModel)
        }
    }
}
