//
//  SchoolDetailsVCTest.swift
//  NYCSchoolsTests
//
//  Created by Sachith H on 5/19/22.
//

@testable import NYCSchools
import Foundation
import XCTest

class SchoolDetailsVCTests: XCTestCase {
    var appCoordinator: AppCoordinator!
    var networkMock: NetworkManagerMock!
    var navigationController: UINavigationController!
    var viewController: SchoolDetailsViewController?
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        networkMock = NetworkManagerMock()
        appCoordinator = AppCoordinator(navigationController: navigationController, networkManager: networkMock)
        appCoordinator.startCoordinator()
        appCoordinator.loadDetails(school: NYCTestMocks.schoolOne)
        viewController = appCoordinator.detailsViewController
        setupViews()
        _ = viewController?.view
    }
    
    private func setupViews() {
        guard let vc = viewController else { return }
        vc.mainView = UIView()
        vc.nameLabel = UILabel()
        vc.descriptionLabel = UILabel()
        vc.informationlabel = UILabel()
        vc.loadingSpinner = UIActivityIndicatorView()
        vc.satLabel = UILabel()
        vc.loadingSpinner.startAnimating()
    }
    
    func testViewControllerNotNil() {
       XCTAssertNotNil(viewController)
    }
    
    override func tearDown() {
        super.tearDown()
        appCoordinator = nil
        networkMock = nil
        navigationController = nil
        viewController = nil
    }
}
