//
//  APIRouter.swift
//  UserRepoSearch
//
//  Created by Eido Goya on 2020/11/10.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import Foundation
import WebKit

enum APIRouter {
    
    // MARK: Base URL
    static let baseURL = "https://api.github.com"
    
    // MARK: Cases
    case getAUser(authId: String, authPw: String, username: String)
    case searchUsers(authId: String, authPw: String, query: String, sort: SortType, order: OrderType, page: Int, perPage: Int)
    
    // MARK: HTTPMethod
    private var method: String {
        switch self {
        case .getAUser, .searchUsers:
            return "GET"
        }
    }
    
    // MARK: Path
    private var path: String {
        switch self {
        case .getAUser(_, _, let username):
            return "/users/\(username)"
        case .searchUsers:
            return "/search/users"
        }
    }
    
    // MARK: Parameters
    private var parameters: [String: Any]? {
        switch self {
        case .getAUser, .searchUsers:
            return nil
        }
    }
    
    // MARK: QueryStrings
    private var queryItems: [URLQueryItem]? {
        var queryItems = [URLQueryItem]()
        switch self {
        case .getAUser:
            return nil
        case .searchUsers(_, _, let query, let sort, let order, let page, let perPage):
            queryItems.append(URLQueryItem(name: "q", value: query))
            if sort != SortType.bestMatch {
                queryItems.append(URLQueryItem(name: "sort", value: sort.rawValue))
            }
            queryItems.append(URLQueryItem(name: "order", value: order.rawValue))
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
            queryItems.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
            return queryItems
        }
    }
    
    // MARK: HTTPHeader
    private func getAdditionalHttpHeaders() -> [(String, String)] {
        var headers = [(String, String)]()
        switch self {
        case .getAUser, .searchUsers:
            headers = [(String, String)]()
            return headers
        }
    }
    
    func asURLRequest() -> URLRequest {
        // Base URL
        let url: URL = URL(string: APIRouter.baseURL)!
        
        // Path
        var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        
        // QueryStrings
        if let queryItems = queryItems {
            urlComponents?.queryItems = queryItems
        }
        
        // URLRequest
        var urlRequest = URLRequest(url: urlComponents!.url!)
        
        // HTTP Method
        urlRequest.httpMethod = method
        
        // Headers
//        urlRequest.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptEncoding.rawValue)
        urlRequest.addValue(AcceptType.githubV3Json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        let headers = getAdditionalHttpHeaders()
        headers.forEach { (header) in
            urlRequest.addValue(header.1, forHTTPHeaderField: header.0)
        }
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        return urlRequest
    }
}
