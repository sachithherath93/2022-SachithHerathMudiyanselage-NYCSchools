//
//  NYCSchoolTestMocks.swift
//  NYCSchoolsTests
//
//  Created by Sachith H on 5/19/22.
//

@testable import NYCSchools
import Foundation

struct NYCTestMocks {
    static let schoolOne = School(id: "1234", schoolName: "MockSchool0", description: "MockDescription", phone: "123456789", website: "www.facebook.com", email: "fb@fb.com", addressLineOne: "345 Lombard Street", city: "New York", zip: "19104")
    static let schoolTwo = School(id: "1235", schoolName: "MockSchool1", description: "MockDescription", phone: "123456789", website: "www.facebook.com", email: "fb@fb.com", addressLineOne: "346 Lombard Street", city: "New York", zip: "19105")
    static let schools = [schoolOne, schoolTwo]
    static let sat = [SchoolSAT(id: "1234", schoolName: "MockSchool", satTestTakers: "200", criticalReadingAvg: "300", mathAvg: "300", writingAvg: "300")]
}

final class NetworkManagerMock: ServiceProtocol {
    var failure: Bool = false
    
    func executeSchoolListRequest(completion: @escaping schoolListCompletion) {
        if failure {
            completion(nil, .requestError)
        } else {
            completion(NYCTestMocks.schools, nil)
        }
    }
    
    func executeSchoolSATRequest(schoolId: String, completion: @escaping schoolSATCompletion) {
        if failure {
            completion(nil, .requestError)
        } else {
            completion(NYCTestMocks.sat, nil)
        }
    }
    
    static func parseJSON(filename: String) -> Data? {
        guard let path = Bundle(for: NetworkManagerMock.self).path(forResource: filename, ofType: "json") else {
            return nil }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
}
