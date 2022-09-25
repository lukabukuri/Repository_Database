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
    private var currentPageNumber = 1
    private var areAllRepositoriesFetched = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = view.bounds
        tableView.backgroundColor = .customBlack
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        tableView.isScrollEnabled = false
        tableView.keyboardDismissMode = .onDrag
        return tableView
        
    }()
    
    private lazy var spinnerFooter: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = .white
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }()
    
    
    private lazy var noMoreRepositoriesFooter: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        footerView.center = label.center
        label.textColor = .white
        label.textAlignment = .center
        label.text = "No More Repositories"
        footerView.addSubview(label)
        
        return footerView
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
        
        searchController.searchBar.delegate = self
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
        case .repositories(let repositories, let isFullyFetched):
            self.display(repositories: repositories, isFullyFetched: isFullyFetched)
        case .error(let error):
            self.display(error: error)
        }
    }
    
    private func display(repositories: [UserRepository], isFullyFetched: Bool) {
        self.dataSource += repositories
        DispatchQueue.main.async { [ weak self] in
            self?.tableView.reloadData()
            self?.tableView.tableFooterView = nil
            self?.tableView.isScrollEnabled = true
        }
        
        self.areAllRepositoriesFetched = isFullyFetched
    }

    private func display(error: Error) {
//        self.displayActivityIndicator(shouldDisplay: false)
//        self.present(alert: CustomAlert(title: nil, message: error.localizedDescription, action: [.cancel(handler: nil)]))
    }

}

// MARK: - UISearchBarDelegate Implementation
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        clearSearchedRepositories()
        if searchText.count > 0 {
            let task = DispatchWorkItem { [weak self] in
                self?.interactor.process(request: .loadRepositories(with: searchText))
            }
            self.searchTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: task)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearchedRepositories()
    }
    
    private func clearSearchedRepositories() {
        self.searchTask?.cancel()
        self.dataSource.removeAll()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.isScrollEnabled = false
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
            self.tableView.setContentOffset(.zero, animated: false)
            self.currentPageNumber = 1
            
        }
    }

    
}
// MARK: - UITableViewDataSource Implementation
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

// MARK: - UITableViewDelegate Implementation
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = dataSource[indexPath.row]
        guard let repositoryName = item.repositoryName, let userName = item.owner?.userName else { return }
        router.navigate(to: .details(repositoryName: repositoryName, userName: userName))
    }
    
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height && !dataSource.isEmpty && !areAllRepositoriesFetched {
            if let text = searchController.searchBar.text {
                currentPageNumber += 1
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.tableFooterView = self?.spinnerFooter
                }
                self.interactor.process(request: .loadRepositories(with: text, isPagination: true, pageNumber: currentPageNumber))
                
            }
        } else if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height && !dataSource.isEmpty && areAllRepositoriesFetched {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.tableFooterView = self?.noMoreRepositoriesFooter
            }
        }
        
    }
}
