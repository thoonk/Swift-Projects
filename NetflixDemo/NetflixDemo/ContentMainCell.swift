//
//  ContentMainCell.swift
//  NetflixDemo
//
//  Created by 김태훈 on 2021/11/14.
//

import UIKit

class ContentMainCell: UICollectionViewCell {
    
    let baseStackView = UIStackView()
    let menuStackView = UIStackView()
    
    let tvButton = UIButton()
    let movieButton = UIButton()
    let categoryButton = UIButton()
    
    let imageView = UIImageView()
    let descLabel = UILabel()
    let contentStackView = UIStackView()
    
    let plusButton = UIButton()
    let playButton = UIButton()
    let infoButton = UIButton()

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [baseStackView, menuStackView].forEach {
            contentView.addSubview($0)
        }
        
        // baseStackView
        baseStackView.axis = .vertical
        baseStackView.alignment = .center
        baseStackView.distribution = .fillProportionally
        baseStackView.spacing = 5
        
        [imageView, descLabel, contentStackView].forEach {
            baseStackView.addArrangedSubview($0)
        }
        
        // imageView
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.width.top.leading.trailing.equalToSuperview()
            // 너비와 높이가 같은 1:1 설정
            $0.height.equalTo(imageView.snp.width)
        }
        
        // descLabel
        descLabel.font = .systemFont(ofSize: 13)
        descLabel.textColor = .white
        descLabel.sizeToFit()
        
        // contentStackView
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.distribution = .equalSpacing
        contentStackView.spacing = 20
        
        [plusButton, infoButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 13)
            $0.setTitleColor(.white, for: .normal)
            $0.imageView?.tintColor = .white
            $0.adjustVerticalLayout(5)
        }
        
        plusButton.setTitle("내가 찜한 콘텐츠", for: .normal)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.addTarget(self, action: #selector(plusBtnTapped(_:)), for: .touchUpInside)
        
        infoButton.setTitle("정보", for: .normal)
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.addTarget(self, action: #selector(infoBtnTapped(_:)), for: .touchUpInside)
        
        playButton.setTitle("▶️ 재생", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.backgroundColor = .white
        playButton.layer.cornerRadius = 3
        playButton.snp.makeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(30)
        }
        playButton.addTarget(self, action: #selector(playBtnTapped(_:)), for: .touchUpInside)
        
        [plusButton, playButton, infoButton].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
                
        baseStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // menuStackView
        menuStackView.axis = .horizontal
        menuStackView.alignment = .center
        menuStackView.distribution = .equalSpacing
        menuStackView.spacing = 20
        
        [tvButton, movieButton, categoryButton].forEach {
            menuStackView.addArrangedSubview($0)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowRadius = 3
        }
        
        tvButton.setTitle("TV 프로그램", for: .normal)
        movieButton.setTitle("영화", for: .normal)
        categoryButton.setTitle("카테고리", for: .normal)

        tvButton.addTarget(self, action: #selector(tvBtnTapped(_:)), for: .touchUpInside)
        movieButton.addTarget(self, action: #selector(movieBtnTapped(_:)), for: .touchUpInside)
        categoryButton.addTarget(self, action: #selector(categoryBtnTapped(_:)), for: .touchUpInside)
        
        menuStackView.snp.makeConstraints {
            $0.top.equalTo(baseStackView)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    @objc
    func tvBtnTapped(_ sender: UIButton) {
        print("TEST: TV Btn Tapped")
    }
    
    @objc
    func movieBtnTapped(_ sender: UIButton) {
        print("TEST: movie Btn Tapped")
    }
    
    @objc
    func categoryBtnTapped(_ sender: UIButton) {
        print("TEST: category Btn Tapped")
    }
    
    @objc
    func plusBtnTapped(_ sender: UIButton) {
        print("TEST: plus Btn Tapped")
    }
    
    @objc
    func infoBtnTapped(_ sender: UIButton) {
        print("TEST: info Btn Tapped")
    }
    
    @objc
    func playBtnTapped(_ sender: UIButton) {
        print("TEST: play Btn Tapped")
    }
}
