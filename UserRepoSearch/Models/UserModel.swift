//
//  UserModel.swift
//  UserRepoSearch
//
//  Created by Eido Goya on 2020/11/10.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    let login: String
    let id: Int
    let node_id: String
    let name: String
    let company: String
    let blog: String
    let location: String
    let email: String
    let public_repos: Int
    let public_gists: Int
    let followers: Int
    let following: Int
    let created_at: String
    let updated_at: String
}
