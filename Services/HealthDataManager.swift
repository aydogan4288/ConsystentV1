//
//  HealthDataManager.swift
//  ConsystentV1
//
//  Created by Ferhat Aydogan on 11/30/23.
//

import Foundation
import HealthKit

class HealthDataManager {
    private let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // Check if Health Data is available
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthError.dataNotAvailable)
            return
        }

        // Define the types of data to access
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(false, HealthError.dataNotAvailable)
            return
        }

        let typesToRead: Set<HKObjectType> = [distanceType, heartRateType]

        // Request authorization to access data
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    func fetchRunningData(completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
            guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
                completion(nil, HealthError.dataNotAvailable)
                return
            }

            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            
            let query = HKSampleQuery(sampleType: distanceType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                guard let samples = samples as? [HKQuantitySample], error == nil else {
                    completion(nil, error)
                    return
                }
                completion(samples, nil)
            }

            healthStore.execute(query)
        }

    func calculatePace(for samples: [HKQuantitySample]) -> Double {
            let totalDistance = samples.reduce(0.0) { sum, sample in
                sum + sample.quantity.doubleValue(for: .mile())
            }

            let totalDuration = samples.reduce(0.0) { sum, sample in
                sum + sample.endDate.timeIntervalSince(sample.startDate)
            }

            // Avoid division by zero
            guard totalDistance > 0 else { return 0 }

            let paceInSecondsPerMile = totalDuration / totalDistance
            let paceInMinutesPerMile = paceInSecondsPerMile / 60

            return paceInMinutesPerMile
        }
}


