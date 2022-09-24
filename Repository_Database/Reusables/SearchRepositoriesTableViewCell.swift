//
//  SearchRepositoriesTableViewCell.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 23.09.22.
//

import UIKit

class SearchRepositoriesTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    private var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()
    
    private var repositoryNameLabel: UILabel = {
        let repositoryNameLabel = UILabel()
        repositoryNameLabel.textColor = .white
        repositoryNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        return repositoryNameLabel
    }()
    
    private var authorNameLabel: UILabel = {
        let authorNameLabel = UILabel()
        authorNameLabel.textColor = .lightGray
        authorNameLabel.font = UIFont.systemFont(ofSize: 14.0)
        return authorNameLabel
    }()
    
    private func configureUI() {
        self.backgroundColor = .clear
        
        avatarImageView.constrain(with: contentView, addAsSubview: true)
            .setMinHeight(60)
            .setConstantWidth(60)
            .myLeftWithItsLeft(20)
            .myTopWithItsTop(20)
            .myBottomWithItsBottom(20)
            
        repositoryNameLabel.constrain(with: contentView, addAsSubview: true)
            .myLeftWithItsLeft(90)
            .myTopWithItsTop(20)
            .myRightWithItsRight(10)
        
        authorNameLabel.constrain(with: contentView, addAsSubview: true)
            .myLeftWithItsLeft(90)
            .myTopWithItsTop(50)
            .myRightWithItsRight(10)
            
    }
    
    // MARK: - Public Method
    func configure(data: UserRepository) {
        self.authorNameLabel.text = data.owner?.userName
        self.repositoryNameLabel.text = data.repositoryName
        if let avatarURL = data.owner?.avatarURL {
            self.avatarImageView.download(from: avatarURL)
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
// MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
