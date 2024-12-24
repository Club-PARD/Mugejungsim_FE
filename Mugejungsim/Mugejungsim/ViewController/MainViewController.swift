//
//  MainViewController.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/23/24.
//

import UIKit

class MainViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행기를 남겨보세요!" // 기본 텍스트
        label.font = .systemFont(ofSize: 24, weight: .bold) // 텍스트 크기와 두께 설정
        label.textColor = .black // 텍스트 색상
        label.backgroundColor = .lightGray // 배경색
        label.textAlignment = .center // 텍스트 가운데 정렬
        label.layer.cornerRadius = 8 // 둥근 모서리 설정
        label.clipsToBounds = true // 둥근 모서리 적용
        label.translatesAutoresizingMaskIntoConstraints = false // 오토레이아웃 사용
        return label
    }()

    
    let MyPageButton: UIButton = {
        let mine = UIButton()
        mine.translatesAutoresizingMaskIntoConstraints = false
        mine.layer.cornerRadius = 25
        mine.clipsToBounds = true
        mine.backgroundColor = UIColor.lightGray
        mine.setImage(UIImage(systemName: "person.circle"), for: .normal)
        mine.tintColor = .white
        return mine
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit // 이미지 비율 유지하며 조정
        imageView.image = UIImage(systemName: "photo") // 기본 이미지 (아이콘)
        imageView.backgroundColor = .lightGray // 배경색
        imageView.layer.cornerRadius = 12 // 둥근 모서리
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let CreateRecord: UIButton = {
        let create = UIButton()
        create.translatesAutoresizingMaskIntoConstraints = false // 오토레이아웃
        create.layer.cornerRadius = 10
        create.backgroundColor = .systemBlue
        create.setTitle("새 기록 만들기", for: .normal)
        create.setTitleColor(.white, for: .normal)
        create.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        return create
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // UI 요소 추가 (같은 부모 뷰에 추가해야 함)
        view.addSubview(titleLabel)
        view.addSubview(MyPageButton)
        view.addSubview(imageView) // 반드시 동일한 부모 뷰에 추가
        view.addSubview(CreateRecord) // 버튼 추가
        
        setConstraints()
        addDoneButtonToAllInputs()
        // 버튼 액션 설정
        CreateRecord.addTarget(self, action: #selector(createRecordTapped), for: .touchUpInside)
    }
    func addDoneButtonToAllInputs() {
        // 툴바 생성
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // 완료 버튼 생성
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        // 텍스트 필드와 텍스트 뷰에 툴바 추가
        for subview in view.subviews {
            if let textField = subview as? UITextField {
                textField.inputAccessoryView = toolbar
            } else if let textView = subview as? UITextView {
                textView.inputAccessoryView = toolbar
            }
        }
    }

    @objc func doneButtonTapped() {
        // 키보드 닫기
        view.endEditing(true)
    }
    func setConstraints() {
        // Auto Layout Constraints 설정
        NSLayoutConstraint.activate([
            // Title TextField Constraints
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // MyPage Button Constraints
            MyPageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            MyPageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            MyPageButton.widthAnchor.constraint(equalToConstant: 50),
            MyPageButton.heightAnchor.constraint(equalToConstant: 50),
            
            // ImageView Constraints
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30), // 텍스트 필드 아래
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200), // 고정된 높이
            
            // CreateRecord Button Constraints
            CreateRecord.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20), // 이미지 바로 아래
            CreateRecord.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            CreateRecord.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            CreateRecord.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func createRecordTapped() {
        // CreateViewController로 화면 전환
        let createVC = CreateViewController()
        createVC.modalPresentationStyle = .fullScreen
        present(createVC, animated: true, completion: nil)
    }
}

class NewCreateViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
