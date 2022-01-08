//
//  MainViewController.swift
//  UsedGoodsUpload
//
//  Created by thoonk on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MainViewController: UIViewController {
    let bag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        
        tableView.register(TitleTextFieldCell.self, forCellReuseIdentifier: TitleTextFieldCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategorySelectCell")
        tableView.register(PriceTextFieldCell.self, forCellReuseIdentifier: PriceTextFieldCell.identifier)
        tableView.register(DetailWriteFormCell.self, forCellReuseIdentifier: DetailWriteFormCell.identifier)
        
        return tableView
    }()
    
    lazy var submitButton: UIBarButtonItem = {
       let button = UIBarButtonItem()
        button.title = "제출"
        button.style = .done
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MainViewModel) {
        // Input
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.itemSelected)
            .disposed(by: bag)
        
        submitButton.rx.tap
            .bind(to: viewModel.submitButtonTapped)
            .disposed(by: bag)
        
        // Output
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, data in
                switch row {
                case 0:
                    let cell = tv.dequeueReusableCell(withIdentifier: TitleTextFieldCell.identifier, for: IndexPath(row: row, section: 0)) as! TitleTextFieldCell
                    
                    cell.selectionStyle = .none
                    cell.titleInputField.placeholder = data
                    cell.bind(viewModel.titleTextFieldCellViewModel)
                    return cell
                    
                case 1:
                    let cell = tv.dequeueReusableCell(withIdentifier: "CategorySelectCell", for: IndexPath(row: row, section: 0))
                    
                    cell.selectionStyle = .none
                    cell.textLabel?.text = data
                    cell.accessoryType = .disclosureIndicator
                    return cell
                    
                case 2:
                    let cell = tv.dequeueReusableCell(withIdentifier: PriceTextFieldCell.identifier , for: IndexPath(row: row, section: 0)) as! PriceTextFieldCell
                    
                    cell.selectionStyle = .none
                    cell.priceInputField.placeholder = data
                    cell.bind(viewModel.priceTextFieldCellViewModel)
                    return cell
                    
                case 3:
                    let cell = tv.dequeueReusableCell(withIdentifier: DetailWriteFormCell.identifier , for: IndexPath(row: row, section: 0)) as! DetailWriteFormCell
                    
                    cell.selectionStyle = .none
                    cell.contentInputView.text = data
                    cell.bind(viewModel.detailWriteFormCellViewModel)
                    return cell
                    
                default:
                    fatalError()
                }
            }
            .disposed(by: bag)
        
        viewModel.presentAlert
            .emit(to: self.rx.setAlert)
            .disposed(by: bag)
        
        viewModel.push
            .drive(onNext: { viewModel in
                let viewController = CategoryListViewController()
                viewController.bind(viewModel)
                self.show(viewController, sender: nil)
            })
            .disposed(by: bag)
    }
}

private extension MainViewController {
    func setupLayout() {
        title = "중고거래 글쓰기"
        view.backgroundColor = .white
        navigationItem.setRightBarButton(submitButton, animated: true)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

typealias Alert = (title: String, message: String?)
extension Reactive where Base: MainViewController {
    var setAlert: Binder<Alert> {
        return Binder(base) { base, data in
            let ac = UIAlertController(
                title: data.title,
                message: data.message,
                preferredStyle: .alert
            )
            let action = UIAlertAction(title: "확인", style: .cancel)
            ac.addAction(action)
            
            base.present(ac, animated: true)
        }
    }
}
