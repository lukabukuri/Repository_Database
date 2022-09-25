//
//  DetailsViewController.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.


import UIKit

protocol DetailsDisplayLogic: AnyObject {
    func display(viewModel: DetailsModels.ViewModel)
}

final class DetailsViewController: UIViewController {

    // MARK: - Public Properties
    var interactor: DetailsBusinessLogic!
    var router: (DetailsRoutingLogic & DetailsDataPassing)!
    
    // MARK: - Private Properties
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        return avatarImageView
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let authorNameLabel = UILabel()
        authorNameLabel.textColor = .lightGray
        authorNameLabel.font = UIFont.systemFont(ofSize: 15)
        authorNameLabel.clipsToBounds = true
        return authorNameLabel
    }()
    
    private lazy var repositoryNameLabel: UILabel = {
        let repositoryNameLabel = UILabel()
        repositoryNameLabel.textColor = .white
        repositoryNameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        return repositoryNameLabel
    }()
    
    private lazy var programmingLanguageLabel: UILabel = {
       let programmingLanguageLabel = UILabel()
        programmingLanguageLabel.textColor = .white
        
        return programmingLanguageLabel
    }()
    
    private lazy var dateLabel: UILabel = {
       let dateLabel = UILabel()
        dateLabel.textColor = .white
        dateLabel.text = "Creation Date:\(String.largeSpace)"
        return dateLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .center
        return descriptionLabel
    }()


    // MARK: - Setup Methods
    static func instantiate() -> DetailsViewController {
        let viewController = DetailsViewController()
        viewController.setup()
        return viewController
    }

    private func setup() {
        let viewController = self
        let worker = DetailsDefaultWorker(persistentManager: PersistentManager())
        let presenter = DetailsPresenter(displayLogic: viewController)
        let interactor = DetailsInteractor(worker: worker, presenter: presenter)
        let router = DetailsRouter(viewController: viewController, dataStore: interactor)
        viewController.interactor = interactor
        viewController.router = router
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        view.backgroundColor = .customBlack
        navigationItem.title = Constants.detailsTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(symbol: .star), style: .done, target: self, action: #selector(saveButtonDidTap))
    }
    
    private func makeConstraints() {
        
        NSLayoutConstraint.deactivate(self.view.constraints)
        
        avatarImageView.constrain(with: view, addAsSubview: true)
            .setConstantHeight(DetailsPageConstraintHelper.avatarImageViewHeight)
            .setConstantWidth(DetailsPageConstraintHelper.avatarImageViewWidth)
            .myTopWithItsTop(DetailsPageConstraintHelper.avatarImageViewTop)
            .equalItscenterX()
        
        authorNameLabel.constrain(with: view, addAsSubview: true)
            .myTopWithItsTop(DetailsPageConstraintHelper.authorLabelTop)
            .equalItscenterX()
        
        repositoryNameLabel.constrain(with: view, addAsSubview: true)
            .myLeftWithItsLeft(DetailsPageConstraintHelper.repositoryNameLabelLeft)
            .myRightWithItsRight(DetailsPageConstraintHelper.repositoryNameLabelRight)
            .myTopWithItsTop(DetailsPageConstraintHelper.repositoryNameLabelTop)

        programmingLanguageLabel.constrain(with: view, addAsSubview: true)
            .myLeftWithItsLeft(DetailsPageConstraintHelper.programmingLanguageLabelLeft)
            .myTopWithItsTop(DetailsPageConstraintHelper.programmingLanguageLabelTop)

        dateLabel.constrain(with: view, addAsSubview: true)
            .myLeftWithItsLeft(DetailsPageConstraintHelper.dateLabelLeft)
            .myTopWithItsTop(DetailsPageConstraintHelper.dateLabelTop)

        descriptionLabel.constrain(with: view, addAsSubview: true)
            .myLeftWithItsLeft(DetailsPageConstraintHelper.descriptionLabelLeft)
            .myRightWithItsRight(DetailsPageConstraintHelper.descriptionLabelRight)
            .myTopWithItsTop(DetailsPageConstraintHelper.descriptionLabelTop)

    }
    
    @objc private func saveButtonDidTap() {
        self.presentAlert(title: nil, message: Constants.askingForSaveRepository, actions: [
            .no(handler: nil), .yes(handler: { [weak self] in
                self?.interactor.process(request: .saveRepository(imageData: self?.avatarImageView.image?.pngData()))
            })])
    }
    
}

// MARK: - Lifecycle
extension DetailsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.makeConstraints()
        self.interactor.process(request: .viewDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.makeRounded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        makeConstraints()
    }

}

// MARK: - DetailsDisplayLogic
extension DetailsViewController: DetailsDisplayLogic {

    func display(viewModel: DetailsModels.ViewModel) {
        switch viewModel {
        case .repository(let repository, let isSavedInLocalStorage):
            self.display(repository: repository, isSavedInLocalStorage)
        case .didRepositorySave(let image):
            self.display(buttonState: image)
        case .error(let error):
            self.display(error: error)
        }
    }
    
    private func display(repository: Repository, _ isSavedInLocalStorage: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if isSavedInLocalStorage {
                self.avatarImageView.image = UIImage(data: repository.profileImage ?? Data())
                self.navigationItem.rightBarButtonItem?.image = UIImage(symbol: .starFill)
            } else {
                self.avatarImageView.download(from: repository.owner?.avatarURL ?? .empty)
                self.navigationItem.rightBarButtonItem?.image = UIImage(symbol: .star)
            }
            self.authorNameLabel.text = repository.owner?.userName
            self.repositoryNameLabel.text = repository.repositoryName
            self.programmingLanguageLabel.text = repository.programmingLanguage ?? .empty
            self.dateLabel.text?.append(repository.dateCreated?.convertISODateToString() ?? .empty)
            self.descriptionLabel.text = repository.description
        }
    }

    private func display(buttonState image: UIImage?) {
        self.navigationItem.rightBarButtonItem?.image = image
    }
    
    private func display(error: Error) {
//        self.displayActivityIndicator(shouldDisplay: false)
//        self.present(alert: CustomAlert(title: nil, message: error.localizedDescription, action: [.cancel(handler: nil)]))
        
    }

}
