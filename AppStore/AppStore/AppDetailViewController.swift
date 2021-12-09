//
//  AppDetailViewController.swift
//  AppStore
//
//  Created by MA2103 on 2021/12/09.
//

import UIKit
import SnapKit
import Kingfisher

final class AppDetailViewController: UIViewController {
    private var appInfo: AppInfo
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("받기", for: .normal)
        button.layer.cornerRadius = 12.0
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .bold)
        
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
            
        return button
    }()
    
    init(appInfo: AppInfo) {
        self.appInfo = appInfo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        setupView()
        
        titleLabel.text = appInfo.appName
        subTitleLabel.text = appInfo.type
        
        if let imageURLString = appInfo.imageURL,
            let imageURL = URL(string: imageURLString) {
            iconImageView.kf.setImage(with: imageURL)
        } else {
            iconImageView.backgroundColor = .lightGray
        }
        
    }
}

// MARK: - Private Methods
private extension AppDetailViewController {
    func setupView() {
        let spacingView = UIView(frame: .zero)
        
        [
            spacingView,
            iconImageView,
            titleLabel,
            subTitleLabel,
            downloadButton,
            shareButton,
        ].forEach { view.addSubview($0) }
        
        spacingView.snp.makeConstraints {            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30.0)
            
        }

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.top.equalTo(spacingView.snp.bottom)
            $0.width.equalTo(100.0)
            $0.height.equalTo(iconImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.top)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview().inset(16.0)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        downloadButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalTo(iconImageView.snp.bottom)
            $0.width.equalTo(60.0)
            $0.height.equalTo(32.0)
        }
        
        shareButton.snp.makeConstraints {
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalTo(iconImageView.snp.bottom)
            $0.width.height.equalTo(32.0)
        }
    }
    
    @objc
    func didTapShareButton() {
        let activityItems: [Any] = [appInfo.appName]
        let activityVC = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }
}
