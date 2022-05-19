//
//  SchoolListViewController.swift
//  NYCSchools
//
//  Created by Sachith H on 5/18/22.
//

import Foundation
import UIKit

class SchoolListViewController: UIViewController {
    var viewModel: SchoolListViewModel!
    var cellReuseId = "SchoolListCell"
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.hidesNavigationBarDuringPresentation = true
        definesPresentationContext = true
        controller.searchBar.isHidden = true
        return controller
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SchoolListCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var loadingSpinner: UIActivityIndicatorView = {
        let loadingSpinner = UIActivityIndicatorView()
        loadingSpinner.hidesWhenStopped = true
        return loadingSpinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = SchoolsConstants.Titles.schoolList
        navigationItem.searchController = searchController
        view.addSubview(tableView)
        tableView.pinToSuperView(view)
        searchController.searchBar.sizeToFit()
        tableView.addSubview(loadingSpinner)
        addSpinnerConstraints()
        loadingSpinner.startAnimating()
        fetchSchools()
    }
    
    private func addSpinnerConstraints() {
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.frame.size.height = 20.0
        let spinnerConstraints: [NSLayoutConstraint] = [loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor), loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor), loadingSpinner.heightAnchor.constraint(equalTo: loadingSpinner.widthAnchor)]
        NSLayoutConstraint.activate(spinnerConstraints)
    }
    
    private func fetchSchools() {
        viewModel.fetchSchoolList(onCompletion: { [unowned self] error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.loadingSpinner.stopAnimating()
                    self.viewModel.showAPIError()
                }
                return
            }
            DispatchQueue.main.async {
                self.loadingSpinner.stopAnimating()
                self.searchController.searchBar.isHidden = false
                self.tableView.reloadData()
            }
        })
    }
}

extension SchoolListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return viewModel.filteredSchoolList.count
        } else {
            return viewModel.sortedSchoolList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as? SchoolListCell else {
            return UITableViewCell()
        }
        let school = searchController.isActive ? viewModel.filteredSchoolList[indexPath.row] : viewModel.sortedSchoolList[indexPath.row]
        cell.setUpCell(with: school)
        return cell
    }
}

extension SchoolListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let school = searchController.isActive ? viewModel.filteredSchoolList[indexPath.row] : viewModel.sortedSchoolList[indexPath.row]
        viewModel.showDetails(school)
    }
}

extension SchoolListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        viewModel.updateFilteredResults(searchBarText)
        self.tableView.reloadData()
    }
}
