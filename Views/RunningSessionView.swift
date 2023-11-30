//
//  RunningSessionView.swift
//  ConsystentV1
//
//  Created by Ferhat Aydogan on 11/30/23.
//

import Foundation
import SwiftUI

struct RunningSessionView: View {
    @ObservedObject var viewModel: RunningSessionViewModel

    var body: some View {
        VStack {
            Text("Distance: \(viewModel.distance, specifier: "%.2f") miles")
            Text("Heart Rate: \(viewModel.heartRate, specifier: "%.0f") bpm")
            Text("Pace: \(viewModel.pace, specifier: "%.2f") min/mile")
        }
    }
}

