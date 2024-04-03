//
//  ShoppingCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by 이재희 on 4/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct ShoppingTableViewCellViewModel {
    let isChecked: Observable<Bool>
    let title: Observable<String>
    let isBookmarked: Observable<Bool>
    
    let checkButtonTapped = PublishSubject<Void>()
    let bookmarkButtonTapped = PublishSubject<Void>()
    
    init(item: Shopping) {
        isChecked = Observable.just(item.isChecked)
        title = Observable.just(item.title)
        isBookmarked = Observable.just(item.isBookmarked)
    }
}

final class ShoppingTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: ShoppingTableViewCell.self)
    
    let checkButton = UIButton()
    let titleLabel = UILabel()
    let bookmarkButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func configureHierarchy() {
        [checkButton, titleLabel, bookmarkButton].forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(32)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkButton.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualTo(bookmarkButton.snp.leading).offset(-16)
        }
    }
    
    private func configureView() {
        setupRoundView()
        
        checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        checkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        
        bookmarkButton.setImage(UIImage(systemName: "star"), for: .normal)
        bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
    }
    
    func setViewModel(_ viewModel: ShoppingTableViewCellViewModel) {
        
        viewModel.isChecked
            .bind(to: checkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isBookmarked
            .bind(to: bookmarkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        checkButton.rx.tap
            .bind(to: viewModel.checkButtonTapped)
            .disposed(by: disposeBag)
        
        bookmarkButton.rx.tap
            .bind(to: viewModel.bookmarkButtonTapped)
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
