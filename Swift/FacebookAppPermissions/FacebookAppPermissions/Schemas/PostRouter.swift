//
//  PostRouter.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 2/2/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import Foundation

// Encode this no-id struct for POST, PUT requests
public struct Post: Codable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
    
    public init(userId:Int, id:Int, title:String, body:String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}

// Decode responses with this struct
public struct PostWithId: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    public init(userId: Int, id: Int, title: String, body: String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}

public enum PostRouter {
    // Possible requests
    case getAll
    case get(Int)
    case create(Post)
    case update(Int, Post)
    case delete(Int)
    // Base endpoint
    static let baseURLString = "https://jsonplaceholder.typicode.com/posts/"
    //static let baseURLString = "http://localhost:3000/employees/"
    // Set the method
    var method: String {
        // DONE: Return "GET", "POST", "PUT" or "DELETE", as appropriate
        switch self {
        case .getAll, .get: return "GET"
        case .create: return "POST"
        case .update: return "PUT"
        case .delete: return "DELETE"
        }
    }
    // Construct the request from url, method and parameters
    public func asURLRequest() -> URLRequest {
        // Build the request endpoint
        let url: URL = {
            let relativePath: String?
            // DONE: Set relativePath to use id, as appropriate
            switch self {
            case .getAll, .create: relativePath = ""
            case .get(let id), .update(let id, _), .delete(let id): relativePath = "\(id)"
            }
            var url = URL(string: PostRouter.baseURLString)!
            if let path = relativePath {
                url = url.appendingPathComponent(path)
            }
            return url
        }()
        // Set up request parameters
        let parameters: Post? = {
            switch self {
            case .getAll, .get, .delete: return nil
            case .create(let post), .update(_, let post): return post
            }
        }()
        // Create request
        var request = URLRequest(url: url)
        // DONE: Set httpMethod
        request.httpMethod = method
        // DONE: Set HTTP header field content-type to application/json
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        // DONE: If there are parameters, and they can be converted to data, set httpBody
        guard let post = parameters else { return request }
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(post)
            request.httpBody = data
        } catch let encodeError as NSError {
            print("Encoder error: \(encodeError.localizedDescription)\n")
        }
        return request
    }
}
