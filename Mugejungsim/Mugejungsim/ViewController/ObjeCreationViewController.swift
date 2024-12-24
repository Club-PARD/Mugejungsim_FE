//
//  ObjeCreationViewController.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/24/24.
//

import UIKit

class ObjeCreationViewController: UIViewController {
    
    // 항목 데이터 (버튼의 value와 title 정의)
    private let items: [(value: String, title: String)] = [
        ("value1", "설레는 여행이었어요"),
        ("value2", "잊지 못할 여행이었어요"),
        ("value3", "즐거운 여행이었어요"),
        ("value4", "눈부신 여행이었어요"),
        ("value5", "평화로운 여행이었어요"),
        ("value6", "매력적인 여행이었어요"),
        ("value7", "흥미로운 여행이었어요"),
        ("value8", "특별한 여행이었어요"),
        ("value9", "감동적인 여행이었어요"),
        ("value10", "힐링되는 여행이었어요")
    ]
    
    // 선택된 항목 (value 기반으로 관리)
    private var selectedItems: [String] = [] {
        didSet {
            updateCreateButtonState()
        }
    }
    
    // 스크롤 뷰
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // "오브제 만들기" 버튼
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오브제 만들기", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        // 스크롤 뷰와 스택 뷰 설정
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // 스크롤 뷰 레이아웃
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
        
        // 스택 뷰 레이아웃
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        // 항목 버튼 추가
        for (value, title) in items {
            let button = createItemButton(value: value, title: title)
            stackView.addArrangedSubview(button)
        }
        
        // 하단 "오브제 만들기" 버튼 추가
        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 버튼 액션 추가
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    // 항목 버튼 생성 (value와 title 설정)
    private func createItemButton(value: String, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.accessibilityIdentifier = value // value를 identifier로 저장
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // 버튼 액션 추가
        button.addTarget(self, action: #selector(didTapItemButton(_:)), for: .touchUpInside)
        return button
    }
    
    // 항목 버튼 클릭 이벤트
    @objc private func didTapItemButton(_ sender: UIButton) {
        guard let value = sender.accessibilityIdentifier else { return }
        
        if selectedItems.contains(value) {
            // 이미 선택된 항목은 선택 해제
            selectedItems.removeAll { $0 == value }
            sender.backgroundColor = .white
        } else {
            // 선택 항목이 2개 이상이면 선택 불가
            guard selectedItems.count < 2 else { return }
            selectedItems.append(value)
            sender.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        }
    }
    
    // "오브제 만들기" 버튼 상태 업데이트
    private func updateCreateButtonState() {
        if selectedItems.count == 2 {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor.systemGreen
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .lightGray
        }
    }
    
    // "오브제 만들기" 버튼 클릭 이벤트
    @objc private func didTapCreateButton() {
        print("선택된 값: \(selectedItems)") // 선택된 value 값 출력
        // 여기서 선택된 데이터를 서버로 전송하거나 다음 화면으로 전달
    }
}
