//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 이재희 on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
    
    let birthday = PublishRelay<Date>()
    let year = PublishRelay<Int>()
    let month = PublishRelay<Int>()
    let day = PublishRelay<Int>()
    
    let disposeBag = DisposeBag()
    
    init() {
        birthday
            .subscribe(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                owner.year.accept(component.year!)
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)
            }
            .disposed(by: disposeBag)
    }
}
