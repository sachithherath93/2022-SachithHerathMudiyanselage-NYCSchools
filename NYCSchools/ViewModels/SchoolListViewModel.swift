//
//  SchoolListViewModel.swift
//  NYCSchools
//
//  Created by Sachith H on 5/18/22.
//

import Foundation

class SchoolListViewModel {
    unowned var coordinator: AppCoordinator
    var networkManager: ServiceProtocol
    
    var schoolList: [School] = [] {
        didSet {
            // Some names have unwanted numbers and characters - ex - ""~`'
            sortedSchoolList = schoolList.sorted {
                $0.schoolName.removeUnwantedCharacters().localizedCaseInsensitiveCompare($1.schoolName.removeUnwantedCharacters()) == ComparisonResult.orderedAscending }
        }
    }
    var sortedSchoolList: [School] = []
    // For use with the search bar
    var filteredSchoolList: [School] = []
    var error: SchoolAPIError?
    
    init(coordinator: AppCoordinator, networkManager: ServiceProtocol) {
        self.coordinator = coordinator
        self.networkManager = networkManager
    }
    
    func showDetails(_ school: School) {
        coordinator.loadDetails(school: school)
    }
    
    func showAPIError() {
        coordinator.displayError(.apiError, suspend: true)
    }
    
    func updateFilteredResults(_ searchBarText: String) {
        filteredSchoolList.removeAll(keepingCapacity: false)
        let searchFilter = sortedSchoolList.filter { school in
            school.schoolName.lowercased().contains(searchBarText.lowercased())
        }
        filteredSchoolList = searchFilter
    }
}

// API call
extension SchoolListViewModel {
    func fetchSchoolList(onCompletion: @escaping ((SchoolAPIError?) -> Void)) {
        networkManager.executeSchoolListRequest { [weak self] schools, error in
            guard let self = self else { return }
            guard let schools = schools, error == nil else {
                onCompletion(error)
                return
            }
            self.schoolList = schools
            onCompletion(nil)
        }
    }
}
