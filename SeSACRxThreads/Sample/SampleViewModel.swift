//
//  SampleViewModel.swift
//  SeSACRxThreads
//
//  Created by 이재희 on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SampleViewModel {
    
    let itemSelected = PublishSubject<IndexPath>()
    let inputText = PublishSubject<String>()
    
    private var data = ["Hue"]
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    init() {
        itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.data.remove(at: indexPath.row)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        inputText
            .subscribe(with: self) { owner, value in
                owner.data.append(value)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)
    }
}
