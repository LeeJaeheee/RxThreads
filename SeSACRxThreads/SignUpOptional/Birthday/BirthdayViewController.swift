//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let viewModel = BirthdayViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()

        bind()
    }
    
    func bind() {
        let input = BirthdayViewModel.Input(
            birthday: birthDayPicker.rx.date,
            nextButtonTap: nextButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.nextButtonTap
            .bind { _ in
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = scene.windows.first {
                    window.rootViewController = SampleViewController()
                    window.makeKeyAndVisible()
                }
            }
            .disposed(by: disposeBag)
        
        output.year
            .drive(yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.month
            .drive(monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.day
            .drive(dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validAge
            .map { $0 ? "가입 가능한 나이입니다." : "만 17세 이상만 가입 가능합니다." }
            .drive(infoLabel.rx.text)
            .disposed(by: disposeBag)

        output.validAge
            .map { $0 ? .blue : .red }
            .drive(infoLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.validAge
            .map { $0 ? .blue : .lightGray }
            .drive(nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)

        output.validAge
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
