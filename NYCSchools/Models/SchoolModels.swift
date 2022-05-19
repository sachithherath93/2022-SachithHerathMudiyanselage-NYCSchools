//
//  SchoolModels.swift
//  NYCSchools
//
//  Created by Sachith H on 5/18/22.
//

import Foundation

struct School: Codable {
    var id: String
    var schoolName: String
    var description: String?
    var phone: String?
    var website: String?
    var email: String?
    var addressLineOne: String?
    var city: String?
    var zip: String?
    
    enum CodingKeys: String, CodingKey {
      case id = "dbn", website, schoolName = "school_name", description = "overview_paragraph", phone = "phone_number",
           email = "school_email", addressLineOne = "primary_address_line_1", city, zip
    }
}

struct SchoolSAT: Codable {
    var id: String
    var schoolName: String
    var satTestTakers: String?
    var criticalReadingAvg: String?
    var mathAvg: String?
    var writingAvg: String? // "Not available if not"
    
    enum CodingKeys: String, CodingKey {
        case id = "dbn", schoolName = "school_name", satTestTakers = "num_of_sat_test_takers",
             criticalReadingAvg = "sat_critical_reading_avg_score", mathAvg = "sat_math_avg_score",
             writingAvg = "sat_writing_avg_score"
    }
}
