//
//  NewsListViewController.swift
//  KeywordNews
//
//  Created by thoonk on 2022/02/04.
//

import UIKit
import SnapKit

final class NewsListViewController: UIViewController {

    private lazy var presenter = NewsListPresenter(viewController: self)
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(didRefreshTableView),
            for: .valueChanged
        )
        
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.dataSource = presenter
        tableView.delegate = presenter
        
        tableView.register(
            NewsListTableViewHeaderView.self,
            forHeaderFooterViewReuseIdentifier: NewsListTableViewHeaderView.identifier
        )
        
        tableView.register(
            NewsListTableViewCell.self,
            forCellReuseIdentifier: NewsListTableViewCell.identifier
        )
        
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension NewsListViewController: NewsListProtocol {
    func setupNavigationBar() {
        navigationItem.title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func moveToNewsWebViewController() {
        let newsWebViewController = NewsWebViewController()
        navigationController?.pushViewController(newsWebViewController, animated: true)
    }
}

private extension NewsListViewController {
    @objc func didRefreshTableView() {
        presenter.didRefreshTableView()
    }
}
