import Foundation
import HealthKit

class HealthDataManager {
    var healthStore: HKHealthStore

    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    // Request Authorization for HealthKit
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthError.dataNotAvailable)
            return
        }
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            completion(success, error)
        }
    }

    // Fetch Distance Data
    func fetchDistanceData(completion: @escaping (Double?, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, HealthError.dataNotAvailable)
            return
        }

        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion(nil, HealthError.dataTypeNotAvailable)
            return
        }

        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: nil, options: .cumulativeSum) { _, result, error in
            guard let result = result, error == nil else {
                completion(nil, error)
                return
            }

            let totalDistance = result.sumQuantity()?.doubleValue(for: .mile())
            completion(totalDistance, nil)
        }

        healthStore.execute(query)
    }

    // Fetch Heart Rate Data
    func fetchHeartRateData(completion: @escaping (Double?, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, HealthError.dataNotAvailable)
            return
        }

        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completion(nil, HealthError.dataTypeNotAvailable)
            return
        }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let samples = samples, let mostRecentSample = samples.first as? HKQuantitySample, error == nil else {
                completion(nil, error)
                return
            }

            let heartRate = mostRecentSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            completion(heartRate, nil)
        }

        healthStore.execute(query)
    }
}
