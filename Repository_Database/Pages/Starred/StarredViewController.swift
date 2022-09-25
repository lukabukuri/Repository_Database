//
//  StarredViewController.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.


import UIKit

protocol StarredDisplayLogic: AnyObject {
    func display(viewModel: StarredModels.ViewModel)
}

final class StarredViewController: UIViewController {

    // MARK: - Public Properties
    var interactor: StarredBusinessLogic!
    var router: (StarredRoutingLogic & StarredDataPassing)!

    // MARK: - Private Properties
    private var dataSource: [UserRepository] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .customBlack
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        return tableView
    }()
    
    
    
    // MARK: - Methods
    static func instantiate() -> StarredViewController {
        let viewController = StarredViewController()
        viewController.setup()
        return viewController
    }

    private func setup() {
        let viewController = self
        let worker = StarredDefaultWorker(persistentManager: PersistentManager())
        let presenter = StarredPresenter(displayLogic: viewController)
        let interactor = StarredInteractor(worker: worker, presenter: presenter)
        let router = StarredRouter(viewController: viewController, dataStore: interactor)
        viewController.interactor = interactor
        viewController.router = router
    }
    
    private func configureUI() {
        view.backgroundColor = .customBlack
        navigationItem.title = Constants.starredTitle
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(class: SearchRepositoriesTableViewCell.self)
        
    }

}

// MARK: - Lifecycle
extension StarredViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
        self.setupTableView()
        self.interactor.process(request: .viewDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor.process(request: .viewDidLoad)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

// MARK: - StarredDisplayLogic
extension StarredViewController: StarredDisplayLogic {

    func display(viewModel: StarredModels.ViewModel) {
        switch viewModel {
        case .repositories(let userRepositories):
            self.display(userRepositories: userRepositories)
        case .error(let error):
            self.display(error: error)
        }
    }
    
    private func display(userRepositories: [UserRepository]) {
        self.dataSource = userRepositories
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func display(error: Error) {
//        self.displayActivityIndicator(shouldDisplay: false)
//        self.present(alert: CustomAlert(title: nil, message: error.localizedDescription, action: [.cancel(handler: nil)]))
    }

}

// MARK: - UITableViewDataSource Implementation
extension StarredViewController: UITableViewDataSource {
    
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
extension StarredViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = dataSource[indexPath.row]
        guard let repositoryName = item.repositoryName else { return }
        router.navigate(to: .details(repositoryName: repositoryName))
    }
}
