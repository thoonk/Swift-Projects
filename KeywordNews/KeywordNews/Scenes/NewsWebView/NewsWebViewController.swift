//
//  NewsWebViewController.swift
//  KeywordNews
//
//  Created by thoonk on 2022/02/06.
//

import UIKit
import SnapKit
import WebKit

final class NewsWebViewController: UIViewController {
    private let webView = WKWebView()

    private let rightBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "link"),
        style: .plain,
        target: self,
        action: #selector(didTapRightBarButtonItem)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupNaviagationBar()
        setupWebView()
    }
}

private extension NewsWebViewController {
    func setupNaviagationBar() {
        navigationItem.title = "기사 제목"
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupWebView() {
        guard let linkURL = URL(string: "https://m.naver.com") else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        view = webView
        let urlRequest = URLRequest(url: linkURL)
        webView.load(urlRequest)
    }
    
    @objc
    func didTapRightBarButtonItem() {
        UIPasteboard.general.string = "naver.com"
    }
}
