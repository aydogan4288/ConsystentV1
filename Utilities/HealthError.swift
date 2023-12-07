//
//  HealthError.swift
//  ConsystentV1
//
//  Created by Ferhat Aydogan on 11/30/23.
//

import Foundation

enum HealthError: Error {
    case dataNotAvailable
    case dataTypeNotAvailable
    case unauthorizedAccess
    case queryFailed
    // Add more specific error cases as needed
}
