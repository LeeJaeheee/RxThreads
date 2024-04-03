//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by 이재희 on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingViewController: UIViewController {
    
    let inputShoppingView = InputShoppingView()
    let tableView = UITableView()
    
    let viewModel = ShoppingViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }
    
    private func bind() {
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { row, element, cell in
                let cellViewModel = ShoppingTableViewCellViewModel(item: element)
                cellViewModel.checkButtonTapped
                    .subscribe(with: self) { owner, _ in
                        owner.viewModel.updateIsChecked.onNext(row)
                    }
                    .disposed(by: cell.disposeBag)
                cellViewModel.bookmarkButtonTapped
                    .subscribe(with: self) { owner, _ in
                        owner.viewModel.updateIsBookmarked.onNext(row)
                    }
                    .disposed(by: cell.disposeBag)
                cell.setViewModel(cellViewModel)
            }
            .disposed(by: disposeBag)
        
        inputShoppingView.addButton.rx.tap
            .withLatestFrom(inputShoppingView.textField.rx.text.orEmpty)
            .bind(to: viewModel.inputTitle)
            .disposed(by: disposeBag)
        
        inputShoppingView.textField.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchQuery)
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Shopping.self))
            .bind(with: self) { owner, value in
                let vc = UIViewController()
                vc.view.backgroundColor = .systemBackground
                vc.title = "\(value.0.row) " + value.1.title
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configureHierarchy() {
        view.addSubview(inputShoppingView)
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        inputShoppingView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(inputShoppingView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureView() {
        view.tintColor = .black
        view.backgroundColor = .systemBackground
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        tableView.rowHeight = 48
        tableView.separatorColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
    }

}
