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
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
        let searchQuery: ControlProperty<String?>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let items: Driver<[String]>
    }
    
    private var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
//    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let itemsSubject = BehaviorSubject(value: data)
        
        input.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.data.remove(at: indexPath.row)
                itemsSubject.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        input.searchQuery.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                itemsSubject.onNext(result)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .withLatestFrom(input.searchQuery.orEmpty)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                itemsSubject.onNext(result)
            }
            .disposed(by: disposeBag)
            
        
        return Output(items: itemsSubject.asDriver(onErrorJustReturn: []))
    }
    
}
