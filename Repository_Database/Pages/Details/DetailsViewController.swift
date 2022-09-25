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
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton(type: .system)
        saveButton.tintColor = .white
        saveButton.setImage(.init(symbol: .star), for: .normal)
        saveButton.contentHorizontalAlignment = .fill
        saveButton.contentVerticalAlignment = .fill
        saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return saveButton
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
            .setConstantHeight(50)
            
            
        saveButton.constrain(with: view, addAsSubview: true)
            .setConstantHeight(DetailsPageConstraintHelper.saveButtonHeight)
            .setConstantWidth(DetailsPageConstraintHelper.saveButtonWidth)
            .myTopWithItsTop(DetailsPageConstraintHelper.saveButtonTop)
            .equalItscenterX()
    }
    
    @objc private func saveButtonDidTap() {
        interactor.process(request: .saveRepository(imageData: avatarImageView.image?.pngData()))
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
                self.saveButton.setImage(UIImage(symbol: .starFill), for: .normal)
            } else {
                self.avatarImageView.download(from: repository.owner?.avatarURL ?? .empty)
                self.saveButton.setImage(UIImage(symbol: .star), for: .normal)
            }
            self.authorNameLabel.text = repository.owner?.userName
            self.repositoryNameLabel.text = repository.repositoryName
            self.programmingLanguageLabel.text = repository.programmingLanguage ?? .empty
            self.dateLabel.text?.append(repository.dateCreated?.convertISODateToString() ?? .empty)
            self.descriptionLabel.text = repository.description
        }
    }

    private func display(buttonState image: UIImage?) {
        self.saveButton.setImage(image, for: .normal)
    }
    
    private func display(error: Error) {
//        self.displayActivityIndicator(shouldDisplay: false)
//        self.present(alert: CustomAlert(title: nil, message: error.localizedDescription, action: [.cancel(handler: nil)]))
        
    }

}
