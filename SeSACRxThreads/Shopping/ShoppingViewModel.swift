//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by 이재희 on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    
    let updateIsChecked = PublishSubject<Int>()
    let updateIsBookmarked = PublishSubject<Int>()
    let inputTitle = PublishSubject<String>()
    let searchQuery = PublishSubject<String>()
    
    private var list: [Shopping] = [
        Shopping(isChecked: true, title: "그립톡 구매하기", isBookmarked: true),
        Shopping(title: "사이다 구매"),
        Shopping(title: "아이패드 케이스 최저가 알아보기", isBookmarked: true),
        Shopping(isChecked: true, title: "양말", isBookmarked: true)
    ]
    
    lazy var items = BehaviorSubject(value: list)
    
    let disposeBag = DisposeBag()
    
    init() {
        updateIsChecked
            .subscribe(with: self) { owner, value in
                owner.list[value].isChecked.toggle()
                owner.items.onNext(owner.list)
                dump(owner.list)
            }
            .disposed(by: disposeBag)
        
        updateIsBookmarked
            .subscribe(with: self) { owner, value in
                owner.list[value].isBookmarked.toggle()
                owner.items.onNext(owner.list)
                dump(owner.list)
            }
            .disposed(by: disposeBag)
        
        inputTitle
            .map { Shopping(title: $0) }
            .subscribe(with: self) { owner, value in
                owner.list.append(value)
                owner.items.onNext(owner.list)
            }
            .disposed(by: disposeBag)
        
        searchQuery
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.list : owner.list.filter { $0.title.contains(value) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
    }
    
}
