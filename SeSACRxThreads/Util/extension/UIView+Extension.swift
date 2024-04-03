//
//  UIView+Extension.swift
//  SeSACRxThreads
//
//  Created by 이재희 on 4/2/24.
//

import UIKit

extension UIView {
    
    func setupRoundView(backgroundColor: UIColor = .systemGray6, cornerRadius: CGFloat = 8) {
        self.backgroundColor = backgroundColor
        clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
}
