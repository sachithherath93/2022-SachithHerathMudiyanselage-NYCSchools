//
//  SchoolsConstants.swift
//  NYCSchools
//
//  Created by Sachith H on 5/18/22.
//

import Foundation

struct SchoolsConstants {
    enum ErrorMessage {
        static let apiCallFailure = "We had trouble fetching your data, please try again in a bit."
        static let header = "Error!"
        static let navigationFail = "We had trouble loading your screen."
        static let notAvailable = "N/A"
        static let ok = "Ok"
    }
    
    enum SATConstants {
        static let critical = "Critical Reading Average:"
        static let math = "Math Average:"
        static let testTakers = "Test Takers:"
        static let writing = "Writing Average:"
    }
    
    enum SchoolInfo {
        static let addressLine1 = "Address Line 1:"
        static let city = "City:"
        static let email = "Email:"
        static let phone = "Phone:"
        static let website = "Website:"
        static let zip = "Zip:"
    }
    
    enum Titles {
        static let schoolList = "New York Schools"
        static let details = "School Details"
    }
    
    enum Timeouts {
        static let timeout = 10.0
    }
}
