//
//  RunningSessionView.swift
//  ConsystentV1
//
//  Created by Ferhat Aydogan on 11/30/23.
//

import SwiftUI

struct RunningSessionView: View {
    @ObservedObject var viewModel: RunningSessionViewModel

    var body: some View {
        VStack {
            if viewModel.isError {
                Text("An error occurred. Please try again.")
            } else {
                Text("Distance: \(viewModel.distance, specifier: "%.2f") miles")
                Text("Heart Rate: \(viewModel.heartRate, specifier: "%.0f") bpm")
            }
        }
    }
}

// The following code is usually at the bottom of the Swift file for testing in the Xcode preview provider.
#if DEBUG
struct RunningSessionView_Previews: PreviewProvider {
    static var previews: some View {
        RunningSessionView(viewModel: RunningSessionViewModel())
    }
}
#endif

