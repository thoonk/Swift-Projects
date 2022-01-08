//
//  CategoryListViewController.swift
//  UsedGoodsUpload
//
//  Created by thoonk on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoryListViewController: UIViewController {
    let bag = DisposeBag()
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryListCell")
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: CategoryViewModel) {
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: "CategoryListCell", for: IndexPath(row: row, section: 0))
                
                cell.textLabel?.text = data.name
                return cell
            }
            .disposed(by: bag)
        
        viewModel.pop
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.itemSelected)
            .disposed(by: bag)
    }
}

private extension CategoryListViewController {
    func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
