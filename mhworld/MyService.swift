//
//  MyService.swift
//  mhworld
//
//  Created by Nikhil Sharma on 11/2/18.
//  Copyright © 2018 nikhil. All rights reserved.
//

import Foundation
import Moya

enum MyService {
    case skills
    case builder(skills: [Skill], slots: [String: Int])
}

extension MyService: TargetType {
    var baseURL: URL { return URL(string: "http://crawler.fatcoder.co")! }
    var path: String {
        switch self {
        case .skills:
            return "/skills"
        case .builder(_, _):
            return "/builder"
        }
    }
    var method: Moya.Method {
        switch self {
        case .skills:
            return .get
        case .builder:
            return .post
        }
    }
    var task: Task {
        switch self {
        case .skills: // Send no parameters
            return .requestPlain
        case let .builder(skills, slots): // Always send parameters as JSON in request body
            return .requestParameters(parameters: ["skills": skills, "slots": slots], encoding: JSONEncoding.default)
        }
    }
    var sampleData: Data {
        switch self {
        case .skills:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        case .builder(let skills, let slots):
            return "{\"id\": \(skills), \"first_name\": \(slots), \"last_name\": \"Potter\"}".utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
