//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 이재희 on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    let itemSelected = PublishSubject<IndexPath>()
    let searchQuery = PublishSubject<String>()
    
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    init() {
        
        itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.data.remove(at: indexPath.row)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        searchQuery
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
    }
    
}
