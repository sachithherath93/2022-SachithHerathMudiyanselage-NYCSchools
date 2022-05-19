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
    var school: School {
        didSet {
            populateSchoolInformation()
        }
    }
    var satInfo: SchoolSAT? {
        didSet {
            populateSATData()
        }
    }

    // School info
    var name: String
    var description: String?
    var satDescription: String? // SchoolsConstants.ErrorMessage.notAvailable
    var schoolInformation: String? // SchoolsConstants.ErrorMessage.notAvailable
    
    init(school: School, coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.school = school
        self.name = school.schoolName.removeUnwantedCharacters().trimmingCharacters(in: .whitespacesAndNewlines)
        if let desc = school.description {
            self.description = desc.removeUnwantedCharacters().trimmingCharacters(in: .whitespaces)
        }
    }
    
    func populateSchoolInformation() {
        var descriptionString = ""
        descriptionString.append("Phone: \(school.phone?.removeLetters() ?? SchoolsConstants.ErrorMessage.notAvailable)\n")
        descriptionString.append("Email: \(school.email ?? SchoolsConstants.ErrorMessage.notAvailable)\n")
        descriptionString.append("Website: \(school.website ?? SchoolsConstants.ErrorMessage.notAvailable)\n")
        descriptionString.append("Address Line 1: \(school.addressLineOne ?? SchoolsConstants.ErrorMessage.notAvailable)\n")
        descriptionString.append("City: \(school.city ?? SchoolsConstants.ErrorMessage.notAvailable)\n")
        descriptionString.append("Zip: \(school.zip ?? SchoolsConstants.ErrorMessage.notAvailable)")
        schoolInformation = descriptionString
    }
    
    func populateSATData() {
        guard let satInfo = satInfo else { return }
        var descriptionString = ""
        
        // from the ordered collections package
        let satInfoDict: OrderedDictionary =
        [SchoolsConstants.SATConstants.testTakers: satInfo.satTestTakers?.removeLetters(), SchoolsConstants.SATConstants.critical: satInfo.criticalReadingAvg?.removeLetters(), SchoolsConstants.SATConstants.math: satInfo.mathAvg?.removeLetters(),
         SchoolsConstants.SATConstants.writing: satInfo.writingAvg?.removeLetters()]
        
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
        NetworkManager().executeSchoolSATRequest(schoolId: school.id) { [weak self] infoArray, error in
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
