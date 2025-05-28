//
//  RepositoryModel.swift
//  AuthApp
//
//  Created by esterelzek on 27/05/2025.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let name: String
    let description: String?
    let html_url: String
    let stargazers_count: Int
}

struct SearchResponse: Decodable {
    let items: [Repository]
}
