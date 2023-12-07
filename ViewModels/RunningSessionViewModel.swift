import Foundation
import Combine
import HealthKit  // Ensure we have HealthKit imported

class RunningSessionViewModel: ObservableObject {
    @Published var distance: Double = 0.0
    @Published var heartRate: Double = 0.0
    @Published var isError: Bool = false

    private var healthDataManager: HealthDataManager
    private var cancellables = Set<AnyCancellable>()

    init(healthStore: HKHealthStore = HKHealthStore()) {
        self.healthDataManager = HealthDataManager(healthStore: healthStore)
        fetchRunningSessionData()
    }

    // Fetch Running Session Data
    func fetchRunningSessionData() {
        healthDataManager.requestAuthorization { [weak self] success, error in
            guard success, error == nil else {
                self?.isError = true
                return
            }
            // Start fetching running session data if authorization is successful
            self?.fetchDistance()
            self?.fetchHeartRate()
        }
    }
    
    private func fetchDistance() {
        // Assuming HealthDataManager has a method to fetch distance
        healthDataManager.fetchDistanceData { [weak self] distance, error in
            DispatchQueue.main.async {
                if let distance = distance {
                    self?.distance = distance
                } else {
                    self?.isError = true
                }
            }
        }
    }
    
    private func fetchHeartRate() {
        // Assuming HealthDataManager has a method to fetch heart rate
        healthDataManager.fetchHeartRateData { [weak self] heartRate, error in
            DispatchQueue.main.async {
                if let heartRate = heartRate {
                    self?.heartRate = heartRate
                } else {
                    self?.isError = true
                }
            }
        }
    }   
    // Add any other methods or properties you need in your ViewModel
}
