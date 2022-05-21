//
//  SchoolDetailsViewController.swift
//  NYCSchools
//
//  Created by Sachith H on 5/18/22.
//

import UIKit

class SchoolDetailsViewController: UIViewController {
    var viewModel: DetailsViewModel!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var informationlabel: UILabel!
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet var satLabel: UILabel!
    
    static var viewController: SchoolDetailsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: SchoolDetailsViewController.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: SchoolDetailsViewController.self)) as? SchoolDetailsViewController else {
            // assertionFailure() - went for an error message in the coordinator
            return nil
        }
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = SchoolsConstants.Titles.details
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeVC))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for subView in mainView.subviews {
            subView.isHidden = true
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        fetchSATDetails()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchSATDetails() {
        viewModel.fetchSATDetails { [unowned self] error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.loadingSpinner.stopAnimating()
                    self.viewModel.showAPIError()
                }
                return
            }
            DispatchQueue.main.async {
                self.loadingSpinner.stopAnimating()
                for subView in self.mainView.subviews {
                    subView.isHidden = false
                }
                self.nameLabel.text = viewModel.name
                self.descriptionLabel.text = viewModel.description ?? SchoolsConstants.ErrorMessage.notAvailable
                self.informationlabel.text = viewModel.schoolInformation ?? SchoolsConstants.ErrorMessage.notAvailable
                self.satLabel.text = viewModel.satDescription ?? SchoolsConstants.ErrorMessage.notAvailable
            }
        }
    }
    
    @objc func closeVC() {
        viewModel.dismissDetails()
    }
}
