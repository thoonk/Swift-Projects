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
    
    let alertActionTapped = PublishRelay<AlertAction>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        let blogResult = searchBar.shouldLoadResult
            .flatMapLatest { query in
                SearchBlogNetwork().searchBlog(query: query)
            }
            .share()
        
        let blogValue = blogResult
            .compactMap { data -> DKBlog? in
                guard case .success(let value) = data else { return nil }
                return value
            }
        
        let blogError = blogResult
            .compactMap { data -> String? in
                guard case .failure(let error) = data else { return nil }
                return error.localizedDescription
            }
        
        // 네트워크 결과 값을 cellData로 변환
        let cellData = blogValue
            .map { blog -> [BlogListCellData] in
                return blog.documents
                    .map { doc in
                        let thumbnailURL = URL(string: doc.thumbnail ?? "")
                        return BlogListCellData(
                            thunmbnailURL: thumbnailURL,
                            name: doc.name,
                            title: doc.title,
                            datetime: doc.datetime
                        )
                    }
            }
        
        // FilterView를 선택했을 때 나오는 alertsheet를 선택했을 때 타입
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        // MainVC -> ListView
        Observable
            .combineLatest(
                sortedType,
                cellData
            ) { type, data -> [BlogListCellData] in
                switch type {
                case .title:
                    return data.sorted { $0.title ?? "" < $1.title ?? "" }
                case .datetime:
                    return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() }
                default:
                    return data
                }
            }
            .bind(to: listView.cellData)
            .disposed(by: bag)
        
        let alertSheetForSorting = listView.headerView.sortButtonTapped
            .map { _ -> Alert in
                return (
                    title: nil,
                    message: nil,
                    actions: [.title, .datetime, .cancel],
                    style: .actionSheet
                )
            }
        
        let alertForErrorMessage = blogError
            .map { message -> Alert in
                return (
                    title: nil,
                    message: "네트워크 오류가 발생했습니다. 잠시후 다시 시도해주세요.",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        Observable
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(
                    title: alert.title,
                    message: alert.message,
                    preferredStyle: alert.style
                )
                return self.presentAlertController(alertController, actions: alert.actions)
            }
            .emit(to: alertActionTapped)
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
