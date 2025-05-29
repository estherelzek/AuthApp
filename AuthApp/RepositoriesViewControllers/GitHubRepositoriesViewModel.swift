//
//  GitHubRepositoriesViewModel.swift
//  AuthApp
//
//  Created by esterelzek on 27/05/2025.
//

import Foundation

// MARK: - GitHub Repositories ViewModel
class GitHubRepositoriesViewModel {
    
    var repositories: [Repository] = []
    var currentPage = 1
    var currentQuery = "swift"
    var isLoading = false
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - fetc hRepositories function
    func fetchRepositories(reset: Bool) {
        guard !isLoading else { return }
        isLoading = true

        if reset {
            currentPage = 1
            repositories.removeAll()
        }

        GitHubService.shared.searchRepositories(query: currentQuery, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let items):
                self.repositories.append(contentsOf: items)
                self.currentPage += 1
                self.onDataUpdated?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func updateQuery(_ query: String) {
        currentQuery = query
    }
}
