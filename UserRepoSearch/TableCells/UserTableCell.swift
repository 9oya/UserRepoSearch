//
//  UserTableCell.swift
//  UserRepoSearch
//
//  Created by Eido Goya on 2020/11/10.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

let userTableCellId = "userTableCellId"

class UserTableCell: UITableViewCell {
    
    // MARK: Properties
    var profileImgView: UIImageView!
    var nickNameLabel: UILabel!
    var reposCntLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Load views
    private func setupLayout() {
        // Configure subview properties
        profileImgView = {
            let imgView = UIImageView()
            imgView.translatesAutoresizingMaskIntoConstraints = false
            return imgView
        }()
        nickNameLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        reposCntLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // Setup ui hierarchy
        addSubview(profileImgView)
        addSubview(nickNameLabel)
        addSubview(reposCntLabel)
        
        // Setup ui constraints
        let profileImgViewConstraints = [
            profileImgView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            profileImgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            profileImgView.widthAnchor.constraint(equalToConstant: 50),
            profileImgView.heightAnchor.constraint(equalToConstant: 50)
        ]
        let nickNameLabelConstraints = [
            nickNameLabel.topAnchor.constraint(equalTo: profileImgView.topAnchor, constant: 10),
            nickNameLabel.leadingAnchor.constraint(equalTo: profileImgView.trailingAnchor, constant: 10)
        ]
        let reposCntLabelConstraints = [
            reposCntLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 10),
            reposCntLabel.leadingAnchor.constraint(equalTo: nickNameLabel.leadingAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(profileImgViewConstraints + nickNameLabelConstraints + reposCntLabelConstraints)
    }
}
