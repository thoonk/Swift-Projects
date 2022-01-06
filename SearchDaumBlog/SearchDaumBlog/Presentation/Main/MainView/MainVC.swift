//
//  MainVC.swift
//  SearchDaumBlog
//
//  Created by thoonk on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa

final class MainVC: UIViewController {
    let bag = DisposeBag()
    
    let searchBar = SearchBar()
    let listView = BlogListView()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MainViewModel) {
        listView.bind(viewModel.blogListViewModel)
        searchBar.bind(viewModel.searchBarViewModel)
        
        viewModel.shouldPresentAlert
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(
                    title: alert.title,
                    message: alert.message,
                    preferredStyle: alert.style
                )
                return self.presentAlertController(alertController, actions: alert.actions)
            }
            .emit(to: viewModel.alertActionTapped)
            .disposed(by: bag)
    }
    
    private func attribute() {
        title = "다음 블로그 검색"        
    }
    
    private func layout() {
        [searchBar, listView]
            .forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Alert
extension MainVC {
    typealias Alert = (
        title: String?,
        message: String?,
        actions: [AlertAction],
        style: UIAlertController.Style
    )
    
    enum AlertAction: AlertActionConvertible {
        case title, datetime, cancel
        case confirm
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .datetime:
                return "Datetime"
            case .cancel:
                return "Cancel"
            case .confirm:
                return "Ok"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .title, .datetime:
                return .default
            case .cancel, .confirm:
                return .cancel
            }
        }
    }
    
    func presentAlertController<Action: AlertActionConvertible>(
        _ alertController: UIAlertController,
        actions: [Action]
    ) -> Signal<Action> {
        guard !actions.isEmpty else { return .empty() }
        return Observable
            .create { [weak self] observer in
                guard let self = self else { return Disposables.create() }
                for action in actions {
                    alertController.addAction(
                        UIAlertAction(
                        title: action.title,
                        style: action.style,
                        handler: { _ in
                            observer.onNext(action)
                            observer.onCompleted()
                        })
                    )
                }
                
                self.present(alertController, animated: true)
                
                return Disposables.create {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
