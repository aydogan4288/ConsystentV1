//
//  HealthDataManagerTests.swift
//  ConsystentV1
//
//  Created by Ferhat Aydogan on 12/2/23.
//

import XCTest
@testable import ConsystentV1
import HealthKit

class HealthDataManagerTests: XCTestCase {

    var healthDataManager: HealthDataManager!
    var healthStoreMock: HKHealthStore!

    override func setUp() {
        super.setUp()
        // Initialize HealthDataManager with a mock HKHealthStore
        healthStoreMock = HKHealthStore() // This should be a mock or stub in your actual test
        healthDataManager = HealthDataManager(healthStore: healthStoreMock)
    }

    override func tearDown() {
        healthDataManager = nil
        healthStoreMock = nil
        super.tearDown()
    }

    func testRequestAuthorization() {
        let authorizationExpectation = expectation(description: "Authorization completion handler called")
        var receivedSuccess: Bool?
        var receivedError: Error?

        healthDataManager.requestAuthorization { success, error in
            receivedSuccess = success
            receivedError = error
            authorizationExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)
        XCTAssertNotNil(receivedSuccess)
        XCTAssertNil(receivedError)
    }

    func testFetchDistanceData() {
        let distanceDataExpectation = expectation(description: "Distance data fetch completion handler called")
        var receivedDistance: Double?
        var receivedError: Error?

        healthDataManager.fetchDistanceData { distance, error in
            receivedDistance = distance
            receivedError = error
            distanceDataExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)
        XCTAssertNotNil(receivedDistance)
        XCTAssertNil(receivedError)
    }


    func testFetchHeartRateData() {
        let heartRateDataExpectation = expectation(description: "Heart rate data fetch completion handler called")
        var receivedHeartRate: Double?
        var receivedError: Error?

        healthDataManager.fetchHeartRateData { heartRate, error in
            receivedHeartRate = heartRate
            receivedError = error
            heartRateDataExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)
        XCTAssertNotNil(receivedHeartRate)
        XCTAssertNil(receivedError)
    }

    // Add more tests as needed...
}
