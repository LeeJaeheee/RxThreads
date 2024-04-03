//
//  InputView.swift
//  SeSACRxThreads
//
//  Created by 이재희 on 4/3/24.
//

import UIKit
import SnapKit

class InputShoppingView: UIView {
    
    let textField = UITextField()
    let addButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureHierarchy() {
        addSubview(textField)
        addSubview(addButton)
    }
    
    private func configureLayout() {
        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.verticalEdges.trailing.equalToSuperview().inset(16)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(addButton.snp.leading).offset(-8)
        }
    }
    
    private func configureView() {
        setupRoundView()
        textField.placeholder = "무엇을 구매하실 건가요?"
        textField.clearButtonMode = .whileEditing
        addButton.setTitle("추가", for: .normal)
        addButton.setupRoundView(backgroundColor: .systemGray5, cornerRadius: 5)
        addButton.setTitleColor(.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
