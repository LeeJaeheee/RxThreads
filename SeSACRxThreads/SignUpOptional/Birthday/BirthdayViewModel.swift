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
    
    struct Input {
        let birthday: ControlProperty<Date>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let nextButtonTap: ControlEvent<Void>
        let year: Driver<String>
        let month: Driver<String>
        let day: Driver<String>
        let validAge: Driver<Bool>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let components = input.birthday
            .map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
            .map{ (year: String($0.year!)+"년", month: String($0.month!)+"월", day: String($0.day!)+"일") }
            .asDriver(onErrorJustReturn: (year: "", month: "", day: ""))
        
        let validAge = input.birthday
            .map { self.validAge(birthday: $0) }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            nextButtonTap: input.nextButtonTap,
            year: components.map { $0.year },
            month: components.map { $0.month },
            day: components.map { $0.day },
            validAge: validAge
        )
    }
    
    private func validAge(birthday: Date) -> Bool {
        let calendar = Calendar.current
        let age = calendar.dateComponents([.year], from: birthday, to: Date())
        return age.year ?? 0 >= 17
    }
}
