//
//  AppCoordinator.swift
//  NYCSchools
//
//  Created by Sachith H on 5/18/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var parent: Coordinator? { get set }
    var children: [Coordinator]? { get set }
    var navigationController : UINavigationController { get set }
    
    func startCoordinator()
}

enum AlertType {
    case apiError
    case other
}

// To initiate the app // coordinator functions is called in the view model
final class AppCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator]?
    var navigationController: UINavigationController // root
    let networkManager: ServiceProtocol
    
    init(navigationController: UINavigationController, networkManager: ServiceProtocol) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }
    
    func startCoordinator() {
        let schoolListVC = SchoolListViewController()
        let viewModel = SchoolListViewModel(coordinator: self, networkManager: networkManager)
        schoolListVC.viewModel = viewModel
        self.navigationController.pushViewController(schoolListVC, animated: true)
    }
    
    func loadDetails(school: School) {
        guard let detailsVC = SchoolDetailsViewController.viewController else {
            displayError(.other)
            return
        }
        let viewModel = DetailsViewModel(coordinator: self, networkManager: networkManager, school: school)
        detailsVC.viewModel = viewModel
        self.navigationController.pushViewController(detailsVC, animated: true)
    }
    
    func displayError(_ alertType: AlertType, suspend: Bool = false) {
        var errorMessage = ""
        switch alertType { // Depending on the api error, this can be expanded
        case .apiError:
            errorMessage = SchoolsConstants.ErrorMessage.apiCallFailure
        case .other:
            errorMessage = SchoolsConstants.ErrorMessage.navigationFail
        }
        let alertController = UIAlertController(title: SchoolsConstants.ErrorMessage.header, message: errorMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: SchoolsConstants.ErrorMessage.ok, style: .default, handler: { [unowned self] _ in
            if suspend {
                // terminate app
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            } else {
                // pop screen
                self.navigationController.popViewController(animated: true)
            }
        })
        alertController.addAction(dismissAction)
        self.navigationController.present(alertController, animated: true, completion: nil)
    }
    
    func closeVC() {
        self.navigationController.popViewController(animated: true)
    }
}
