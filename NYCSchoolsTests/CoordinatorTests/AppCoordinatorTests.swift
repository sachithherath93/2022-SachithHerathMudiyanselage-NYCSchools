//
//  AppCoordinatorTests.swift
//  NYCSchoolsTests
//
//  Created by Sachith H on 5/20/22.
//

@testable import NYCSchools
import Foundation
import XCTest

class AppCoordinatorTests: XCTestCase {
    var coordinator: AppCoordinator!
    var service: NetworkManagerMock!

    override func setUp() {
        super.setUp()
        let serviceMock = NetworkManagerMock()
        self.service = serviceMock
        self.coordinator = AppCoordinator(navigationController: UINavigationController(), networkManager: serviceMock)
    }
    
    func testAppCoordinator() {
        coordinator.startCoordinator()
        XCTAssertNotNil(coordinator.schoolListViewController)
        coordinator.loadDetails(school: NYCTestMocks.schoolOne)
        XCTAssertNotNil(coordinator.schoolListViewController)
        coordinator.closeVC()
        let listVC = coordinator.navigationController.topViewController as? SchoolListViewController
        XCTAssertNotNil(listVC)
        coordinator.displayError(.apiError)
        coordinator.displayError(.other)
    }
    
    override func tearDown() {
        coordinator = nil
        service = nil
    }
}
