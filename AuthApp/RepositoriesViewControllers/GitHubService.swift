//
//  GitHubService.swift
//  AuthApp
//
//  Created by esterelzek on 27/05/2025.
//

import Foundation
import Alamofire

class GitHubService {

    static let shared = GitHubService()
    private init() {}

    func searchRepositories(query: String, page: Int, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let url = "https://api.github.com/search/repositories"
        let parameters: Parameters = [
            "q": query,
            "per_page": 20,
            "page": page
        ]

        AF.request(url, parameters: parameters, requestModifier: { $0.timeoutInterval = 15 })
            .validate()
            .responseDecodable(of: SearchResponse.self) { response in
                switch response.result {
                case .success(let searchResponse):
                    completion(.success(searchResponse.items))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
     }
}
