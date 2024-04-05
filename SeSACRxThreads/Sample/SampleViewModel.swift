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
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
        let inputText: Observable<String>
        let itemAccessoryButtonTap: ControlEvent<IndexPath>
    }
    
    struct Output {
        let items: Driver<[String]>
        let itemAccessoryButtonTap: ControlEvent<IndexPath>
    }
    
    private var data = ["Hue"]
    //lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let itemsSubject = BehaviorSubject(value: data)
        
        input.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.data.remove(at: indexPath.row)
                itemsSubject.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        input.inputText
            .subscribe(with: self) { owner, value in
                owner.data.append(value)
                itemsSubject.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        return Output(items: itemsSubject.asDriver(onErrorJustReturn: []), itemAccessoryButtonTap: input.itemAccessoryButtonTap)
    }
}
