//
//  RunningSessionViewModel.swift
//  ConsystentV1
//
//  Created by Ferhat Aydogan on 11/30/23.
//

import Foundation

class RunningSessionViewModel: ObservableObject {
    private let healthDataManager = HealthDataManager()
    // Properties to store fetched data
    @Published var distance: Double = 0.0
    @Published var heartRate: Double = 0.0
    @Published var pace: Double = 0.0

    func fetchRunningSessionData() {
        healthDataManager.requestAuthorization { [weak self] success, error in
            guard success, error == nil else {
                // Handle error or lack of authorization
                return
            }

            self?.healthDataManager.fetchRunningData { samples, error in
                guard let samples = samples, error == nil else {
                    // Handle error
                    return
                }

                // Calculate and update pace
                self?.pace = self?.healthDataManager.calculatePace(for: samples) ?? 0

                // Update other properties (distance, heart rate) as needed
            }
        }
    }
}

