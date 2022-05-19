//
//  DetailsViewModelTests.swift
//  NYCSchoolsTests
//
//  Created by Sachith H on 5/19/22.
//

@testable import NYCSchools
import Foundation
import XCTest

class DetailsViewModelTests: XCTestCase {
    var coordinator: AppCoordinator!
    var viewModel: DetailsViewModel!
    var service: NetworkManagerMock!

    override func setUp() {
        super.setUp()
        let serviceMock = NetworkManagerMock()
        self.service = serviceMock
        self.coordinator = AppCoordinator(navigationController: UINavigationController(), networkManager: serviceMock)
        self.viewModel = DetailsViewModel(coordinator: coordinator, networkManager: serviceMock, school: NYCTestMocks.schoolOne)
    }
    
    func testFetchSuccess() {
        service.failure = false
        viewModel.fetchSATDetails { _ in}
        XCTAssertNotNil(self.viewModel.satInfo)
        XCTAssertEqual(self.viewModel.satDescription, "Test Takers: 200\nCritical Reading Average: 300\nMath Average: 300\nWriting Average: 300\n")
        XCTAssertEqual(self.viewModel.schoolInformation, "Phone: 123456789\nEmail: fb@fb.com\nWebsite: www.facebook.com\nAddress Line 1: 345 Lombard Street\nCity: New York\nZip: 19104\n")
    }
    
    func testFetchFailure() {
        service.failure = true
        viewModel.fetchSATDetails { [unowned self] _ in
            XCTAssertNil(self.viewModel.satInfo)
        }
    }

    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        super.tearDown()
    }
}
