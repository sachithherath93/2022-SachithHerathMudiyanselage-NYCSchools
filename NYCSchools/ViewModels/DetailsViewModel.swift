//
//  DetailsViewModel.swift
//  NYCSchools
//
//  Created by Sachith H on 5/18/22.
//

import Foundation
import OrderedCollections // swift package
import UIKit

class DetailsViewModel {
    unowned var coordinator: AppCoordinator
    var networkManager: ServiceProtocol
    
    var school: School
    var satInfo: SchoolSAT? {
        didSet {
            populateSchoolInformation()
            populateSATData()
        }
    }

    var name: String
    var description: String?
    var satDescription: String?
    var schoolInformation: String?
    
    init(coordinator: AppCoordinator, networkManager: ServiceProtocol, school: School) {
        self.coordinator = coordinator
        self.networkManager = networkManager
        self.school = school
        self.name = school.schoolName.removeUnwantedCharacters().trimmingCharacters(in: .whitespacesAndNewlines)
        if let desc = school.description {
            self.description = desc.removeUnwantedCharacters().trimmingCharacters(in: .whitespaces).capitalizingFirstLetter()
        }
    }
    
    func populateSchoolInformation() {
        var descriptionString = ""
        
        // from the ordered collections package/ dependency
        let schoolInfoDict: OrderedDictionary =
        [SchoolsConstants.SchoolInfo.phone: school.phone?.removeNonPhoneNumber(), SchoolsConstants.SchoolInfo.email: school.email?.removeNoneEmail(), SchoolsConstants.SchoolInfo.website: school.website,
         SchoolsConstants.SchoolInfo.addressLine1: school.addressLineOne,
         SchoolsConstants.SchoolInfo.city: school.city?.removeUnwantedCharacters().capitalizingFirstLetter(),
         // used the same as non phone number as zip also sometimes contains -
         SchoolsConstants.SchoolInfo.zip: school.zip?.removeNonPhoneNumber()]
        
        for schoolInfo in schoolInfoDict {
            if let info = schoolInfo.value, !info.isEmpty {
                descriptionString.append("\(schoolInfo.key) \(info)\n")
            } else {
                descriptionString.append("\(schoolInfo.key) \(SchoolsConstants.ErrorMessage.notAvailable)\n")
            }
        }
        schoolInformation = descriptionString
    }
    
    func populateSATData() {
        guard let satInfo = satInfo else { return }
        var descriptionString = ""
        
        // from the ordered collections package/ dependency
        let satInfoDict: OrderedDictionary =
        [SchoolsConstants.SATConstants.testTakers: satInfo.satTestTakers?.removeNonNumeric(), SchoolsConstants.SATConstants.critical: satInfo.criticalReadingAvg?.removeNonNumeric(), SchoolsConstants.SATConstants.math: satInfo.mathAvg?.removeNonNumeric(),
         SchoolsConstants.SATConstants.writing: satInfo.writingAvg?.removeNonNumeric()]
        
        for satInfo in satInfoDict {
            if let info = satInfo.value, !info.isEmpty {
                descriptionString.append("\(satInfo.key) \(info)\n")
            } else {
                descriptionString.append("\(satInfo.key) \(SchoolsConstants.ErrorMessage.notAvailable)\n")
            }
        }
        satDescription = descriptionString
    }
    
    func showAPIError() {
        coordinator.displayError(.apiError)
    }
    
    func dismissDetails() {
        coordinator.closeVC()
    }
}

extension DetailsViewModel {
    func fetchSATDetails(onCompletion: @escaping ((SchoolAPIError?) -> Void)) {
        networkManager.executeSchoolSATRequest(schoolId: school.id) { [weak self] infoArray, error in
            guard let self = self else { return }
            guard let infoArray = infoArray,
                    let satInfo = infoArray.first,
                    error == nil else {
                onCompletion(error)
                return
            }
            self.satInfo = satInfo
            onCompletion(nil)
        }
    }
}
