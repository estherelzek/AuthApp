//
//  GitHubRepositoriesViewController.swift
//  AuthApp
//
//  Created by esterelzek on 27/05/2025.
//

import UIKit

class GitHubRepositoriesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let viewModel = GitHubRepositoriesViewModel()
    let loader = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupLoader()
        bindViewModel()
        viewModel.fetchRepositories(reset: true)
    }

    func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.loader.stopAnimating()
                self?.view.isUserInteractionEnabled = true
                self?.tableView.reloadData()
            }
        }
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.loader.stopAnimating()
                self?.view.isUserInteractionEnabled = true
                self?.showError(message)
            }
        }
    }
}

extension GitHubRepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repo = viewModel.repositories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "RepoCell")
        cell.textLabel?.text = repo.name
        cell.detailTextLabel?.text = repo.description ?? "No description"
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height * 1.5 {
            loader.startAnimating()
            viewModel.fetchRepositories(reset: false)
        }
    }
}

extension GitHubRepositoriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !query.isEmpty else { return }
        viewModel.updateQuery(query)
        searchBar.resignFirstResponder()
        loader.startAnimating()
        viewModel.fetchRepositories(reset: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.updateQuery("swift")
            loader.startAnimating()
            viewModel.fetchRepositories(reset: true)
        }
    }
}



