//
//  SchoolsConstants.swift
//  NYCSchools
//
//  Created by Sachith H on 5/18/22.
//

import Foundation

struct SchoolsConstants {
    struct ErrorMessage {
        static let apiCallFailure = "We had trouble fetching your data, please try again in a bit."
        static let header = "Error!"
        static let navigationFail = "We had trouble loading your screen."
        static let notAvailable = "N/A"
        static let ok = "Ok"
    }
    
    struct Titles {
        static let schoolList = "Schools List"
        static let details = "School Details"
    }
    
    struct Timeouts {
        static let timeout = 10.0
    }
    
    struct SATConstants {
        static let critical = "Critical Reading Average:"
        static let math = "Math Average:"
        static let testTakers = "Test Takers:"
        static let writing = "Writing Average:"
    }
}
