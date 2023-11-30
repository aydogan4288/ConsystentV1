//
//  ConsystentV1App.swift
//  ConsystentV1
//
//  Created by Ferhat Aydogan on 11/29/23.
//

import SwiftUI

@main
struct ConsystentV1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView();
            RunningSessionView(viewModel: RunningSessionViewModel())
        }
    }
}
