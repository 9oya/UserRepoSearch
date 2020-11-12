//
//  APIConstants.swift
//  UserRepoSearch
//
//  Created by Eido Goya on 2020/11/10.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import Foundation

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "accept"
    case acceptEncoding = "Accept-Encoding"
    case userAgent = "User-Agent"
    case appToken = "App-Token"
}

enum AcceptType: String {
    case anyMIMEgtype = "*/*"
    case githubV3Json = "application/vnd.github.v3+json"
}

enum ContentType: String {
    case json = "application/json; charset=utf-8"
    case xwwwFormUrlencoded = "application/x-www-form-urlencoded; charset=utf-8"
}

enum SortType: String {
    case repos = "repositories"
    case followers = "followers"
    case joined = "joined"
    case bestMatch = ""
}

enum OrderType: String {
    case desc = "desc"
    case asc = "asc"
}

enum HTTPStatus: Int {
  case ok = 200

  case badRequest = 400
  case notAuthorized = 401
  case paymentRequired = 402
  case forbidden = 403
  case notFound = 404

  case internalServerError = 500
}

enum BasicAuth: String {
    case username = "9oya"
    case password = "af001f6b4a92a2efd0fb36dee8f787898203f4b0"
}
