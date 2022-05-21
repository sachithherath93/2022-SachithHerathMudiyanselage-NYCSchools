//
//  SchoolListVCTests.swift
//  NYCSchoolsTests
//
//  Created by Sachith H on 5/19/22.
//

@testable import NYCSchools
import Foundation
import XCTest

class SchoolsListVCTests: XCTestCase {
    var appCoordinator: AppCoordinator!
    var networkMock: NetworkManagerMock!
    var navigationController: UINavigationController!
    var viewController: SchoolListViewController?
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        networkMock = NetworkManagerMock()
        appCoordinator = AppCoordinator(navigationController: navigationController, networkManager: networkMock)
        appCoordinator.startCoordinator()
        viewController = appCoordinator.navigationController.topViewController as? SchoolListViewController
        viewController?.loadView()
    }
    
    func testViewControllerNotNil() {
       XCTAssertNotNil(viewController)
    }
    
    // Check Table V
    func testCheckDataOnTableView() {
        // Make sure table view is empty
        XCTAssertEqual(viewController?.tableView.numberOfRows(inSection: 0), 0)
        
        // load the data
        viewController?.viewModel.schoolList = NYCTestMocks.schools
        viewController?.tableView.reloadData()
        
        guard let firstCell = viewController?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SchoolListCell else {
            XCTFail("Did not reload the cells as intended")
            return
        }
        XCTAssertEqual(firstCell.nameTextLabel.text, "MockSchool0")
        XCTAssertEqual(viewController?.tableView.numberOfRows(inSection: 0), 2)
    }
    
    func testCheckDataOnTableViewWithSearch() {
        guard let viewController = viewController else {
            XCTFail("Unable to initialize list view controller")
            return
        }

        // load the data
        viewController.viewModel.coordinator = appCoordinator
        viewController.viewModel.schoolList = NYCTestMocks.schools
        viewController.tableView.reloadData()
        
        XCTAssertEqual(viewController.viewModel.filteredSchoolList.count, 0)
        viewController.searchActive = true
        viewController.searchController.searchBar.text = "MockSchool0"
        viewController.tableView.reloadData()
        // this should update the filtered count
        XCTAssertEqual(viewController.viewModel.filteredSchoolList.count, 1)
    }
    
    func testCheckTap() {
        guard let viewController = viewController else {
            XCTFail("Unable to initialize list view controller")
            return
        }

        // load the data
        viewController.viewModel.coordinator = appCoordinator
        viewController.viewModel.schoolList = NYCTestMocks.schools
        viewController.tableView.reloadData()
        
        // Make sure the details view controller is loaded
        viewController.tableView(viewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(appCoordinator.schoolListViewController)
    }
    
    override func tearDown() {
        super.tearDown()
        appCoordinator = nil
        networkMock = nil
        navigationController = nil
        viewController = nil
    }
}
