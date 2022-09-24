//
//  SearchViewController.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func display(viewModel: SearchModels.ViewModel)
}

final class SearchViewController: UIViewController {

    // MARK: - Public Properties
    var interactor: SearchBusinessLogic!
    var router: (SearchRoutingLogic & SearchDataPassing)!

    // MARK: - Private Properties
    private let searchController = UISearchController()
    private var searchTask: DispatchWorkItem?
    private var dataSource: [UserRepository] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = view.bounds
        tableView.backgroundColor = .customBlack
        return tableView
        
    }()
    
    // MARK: - Methods
    static func instantiate() -> SearchViewController {
        let viewController = SearchViewController()
        viewController.setup()
        return viewController
    }
    
    private func setup() {
        let viewController = self
        let worker = SearchDefaultWorker()
        let presenter = SearchPresenter(displayLogic: viewController)
        let interactor = SearchInteractor(worker: worker, presenter: presenter)
        let router = SearchRouter(viewController: viewController, dataStore: interactor)
        viewController.interactor = interactor
        viewController.router = router
    }
    
    private func configureSearchBar() {
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        if let textfield = searchController.searchBar.value(forKey: Constants.Keys.searchField) as? UITextField {
            textfield.textColor = .white
        }
        
    }
    
    private func configureUI() {
        view.backgroundColor = .customBlack
        navigationItem.title = Constants.searchTitle
        configureSearchBar()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        tableView.registerClass(class: SearchRepositoriesTableViewCell.self)
        
    }

}

// MARK: - Lifecycle
extension SearchViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.configureUI()
        self.setupTableView()
       
    }

}

// MARK: - SearchDisplayLogic
extension SearchViewController: SearchDisplayLogic {

    func display(viewModel: SearchModels.ViewModel) {
        switch viewModel {
        case .repositories(let repositories):
            self.display(repositories: repositories)
        case .error(let error):
            self.display(error: error)
        }
    }
    
    private func display(repositories: [UserRepository]) {
        self.dataSource = repositories
        DispatchQueue.main.async { [ weak self] in
            self?.tableView.reloadData()
        }
        
    }

    private func display(error: Error) {
//        self.displayActivityIndicator(shouldDisplay: false)
//        self.present(alert: CustomAlert(title: nil, message: error.localizedDescription, action: [.cancel(handler: nil)]))
    }

}

// MARK: - UISearchResultsUpdating Implementation
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchTask?.cancel()
        if let text = searchController.searchBar.text, text.count > 0 {
            
            let task = DispatchWorkItem { [weak self] in
                self?.interactor.process(request: .searchRepositories(with: text))
            }
            self.searchTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: task)
        }
        
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(SearchRepositoriesTableViewCell.self, for: indexPath)
        let data = dataSource[indexPath.row]
        cell.configure(data: data)
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
