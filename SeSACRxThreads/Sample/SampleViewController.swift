//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by 이재희 on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {

    private let textField = UITextField()
    private let addButton = PointButton(title: "추가")
    private let tableView = UITableView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = SampleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()
        
        bind()
    }
    
    func bind() {
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = "\(element) @ row \(row)"
                cell.accessoryType = .detailButton
            }
            .disposed(by: disposeBag)
        
        /*
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(String.self)
        )
        .bind(with: self) { owner, value in
            owner.showAlert(message: "\(value.0)번 \(value.1)를 선택했습니다!")
        }
        .disposed(by: disposeBag)
         */
        
        tableView.rx
            .itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemAccessoryButtonTapped
            .bind(with: self) { owner, indexPath in
                owner.showAlert(message: "\(indexPath)의 디테일 버튼을 클릭했습니다!")
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty)
            .bind(to: viewModel.inputText)
            .disposed(by: disposeBag)
    }
    
    
    func configureHierarchy() {
        view.addSubview(textField)
        view.addSubview(addButton)
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
            make.leading.equalToSuperview().inset(20)
        }
        addButton.snp.makeConstraints { make in
            make.centerY.height.equalTo(textField)
            make.leading.equalTo(textField.snp.trailing).offset(8)
            make.width.equalTo(70)
            make.trailing.equalToSuperview().inset(20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    func showAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
