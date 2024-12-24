//
//  ObjeCreationViewController.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/24/24.
//

import UIKit

class ObjeCreationViewController: UIViewController {
    
    private let items: [(value: String, title: String)] = [
        ("value1", "🥰 설레는 여행이었어요"),
        ("value2", "🫧 잊지 못할 여행이었어요"),
        ("value3", "🎉 즐거운 여행이었어요"),
        ("value4", "✨ 눈부신 여행이었어요"),
        ("value5", "️🕊️ 평화로운 여행이었어요"),
        ("value6", "💎 매력적인 여행이었어요"),
        ("value7", "🎶 흥미로운 여행이었어요"),
        ("value8", "🌈 특별한 여행이었어요"),
        ("value9", "🥹 감동적인 여행이었어요"),
        ("value10", "🍃 힐링되는 여행이었어요")
    ]
    
    // 제목 라벨
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "한줄 남기기로 오브제를 만들어보세요"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 서브텍스트 라벨
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 2개 선택"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 10)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 선택된 항목
    private var selectedItems: [String] = [] {
        didSet {
            updateCreateButtonState()
        }
    }
    
    // UI 요소
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오브제 만들기", for: .normal)
        button.backgroundColor = UIColor(hex: "#D9D9D9")
        button.setTitleColor(.black, for: .normal)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCustomNavigationBar()
        setupUI()
        setupConstraints() // 제약조건 함수 호출
    }
    
    // MARK: - 네비게이션 바 설정
    private func setupCustomNavigationBar() {
        let navBar = UIView()
        navBar.backgroundColor = .white
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "X_Button"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navBar)
        navBar.addSubview(separator)
        navBar.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 40),
            
            separator.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            closeButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UI 설정
    private func setupUI() {
        // 스크롤 뷰와 스택 뷰 설정
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // 텍스트 추가
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        // 항목 버튼 추가
        for (value, title) in items {
            let button = createItemButton(value: value, title: title)
            stackView.addArrangedSubview(button)
        }
        
        // 하단 "오브제 만들기" 버튼 추가
        view.addSubview(createButton)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    // MARK: - 제약조건 설정
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 스크롤 뷰
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -20),
            
            // 스택 뷰
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // "오브제 만들기" 버튼
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - 항목 버튼 생성
    private func createItemButton(value: String, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.accessibilityIdentifier = value
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(didTapItemButton(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func didTapItemButton(_ sender: UIButton) {
        guard let value = sender.accessibilityIdentifier else { return }
        
        if selectedItems.contains(value) {
            selectedItems.removeAll { $0 == value }
            sender.backgroundColor = .white
        } else {
            guard selectedItems.count < 2 else { return }
            selectedItems.append(value)
            sender.backgroundColor = UIColor(hex: "#CFFFDD")
        }
    }
    
    private func updateCreateButtonState() {
        if selectedItems.count == 2 {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(hex: "#19FF5E")
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(hex: "#D9D9D9")
        }
    }
    
    @objc private func didTapCreateButton() {
        print("선택된 값: \(selectedItems)")
    }
}

// MARK: - UIColor 확장
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
