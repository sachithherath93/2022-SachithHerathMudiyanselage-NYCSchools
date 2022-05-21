//
//  SchoolListViewModelTests.swift
//  NYCSchoolsTests
//
//  Created by Sachith H on 5/19/22.
//

@testable import NYCSchools
import Foundation
import XCTest

class SchoolListViewModelTests: XCTestCase {
    var coordinator: AppCoordinator!
    var viewModel: SchoolListViewModel!
    var service: NetworkManagerMock!

    override func setUp() {
        super.setUp()
        let serviceMock = NetworkManagerMock()
        self.service = serviceMock
        self.coordinator = AppCoordinator(navigationController: UINavigationController(), networkManager: serviceMock)
        self.viewModel = SchoolListViewModel(coordinator: coordinator, networkManager: serviceMock)
    }
    
    func testFetchSuccess() {
        service.failure = false
        viewModel.fetchSchoolList { [unowned self] result in
            XCTAssertFalse(self.viewModel.schoolList.isEmpty)
        }
    }
    
    func testFetchFailure() {
        service.failure = true
        viewModel.fetchSchoolList { [unowned self] _ in
            XCTAssertTrue(self.viewModel.schoolList.isEmpty)
        }
    }
    
    func testShowDetails() {
        // this should load the next view controller on to the coordinator's nav controller, it should increase the count
        XCTAssertEqual(coordinator.navigationController.viewControllers.count, 0)
        viewModel.showDetails(NYCTestMocks.schoolOne)
        XCTAssertEqual(coordinator.navigationController.viewControllers.count, 1)
    }
    
    func testShowAPIError() {
        XCTAssertEqual(coordinator.navigationController.viewControllers.count, 0)
        viewModel.showAPIError()
    }
    
    func testUpdatedSearchText() {
        testFetchSuccess()
        viewModel.updateFilteredResults("")
        XCTAssertEqual(viewModel.filteredSchoolList.count, 0)
        viewModel.updateFilteredResults("Mock")
        XCTAssertEqual(viewModel.filteredSchoolList.count, 2)
        viewModel.updateFilteredResults("MockSchool1")
        XCTAssertEqual(viewModel.filteredSchoolList.count, 1)
        viewModel.updateFilteredResults("NotMockSchool")
        XCTAssertEqual(viewModel.filteredSchoolList.count, 0)
    }

    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        self.coordinator = nil
        super.tearDown()
    }
}
