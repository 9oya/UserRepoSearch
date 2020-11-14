//
//  SearchModel+ItemModel.swift
//  UserRepoSearch
//
//  Created by Eido Goya on 2020/11/10.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import Foundation

struct SearchModel: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [ItemModel]
}

class ItemModel: Codable {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let gravatar_id: String?
    let url: String
    let html_url: String
    let followers_url: String
    let following_url: String
    let gists_url: String
    let starred_url: String
    let subscriptions_url: String
    let organizations_url: String
    let repos_url: String
    let events_url: String
    let received_events_url: String
    let type: String
    let site_admin: Bool
    let score: Float
    
    var avatarUrlData: Data?
    var publicReposCnt: Int?
}
