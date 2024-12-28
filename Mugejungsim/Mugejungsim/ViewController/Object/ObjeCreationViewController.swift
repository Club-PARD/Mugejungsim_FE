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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    
    // 제목 라벨
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "한줄 남기기로 오브제를 만들어\n어행을 추억해 보세요!"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 서브텍스트 라벨
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 2개까지 선택할 수 있어요. (0 / 2)"
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 선택된 항목
    private var selectedItems: [String] = [] {
        didSet {
            updateCreateButtonState()
            subtitleLabel.text = "최대 2개까지 선택할 수 있어요. (\(selectedItems.count) / 2)"
        }
    }
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오브제 만들기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "#D9D9D9")
        button.layer.cornerRadius = 8
        button.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: 8).cgPath
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        button.layer.masksToBounds = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCustomNavigationBar()
        setupUI()
        setupConstraints() // 제약조건 함수 호출
        
        // creatButton에 초기 그림자 고정
        DispatchQueue.main.async {
            self.createButton.layer.shadowPath = UIBezierPath(roundedRect: self.createButton.bounds, cornerRadius: 8).cgPath
        }
    }
    
    // MARK: - 네비게이션 바
    private func setupCustomNavigationBar() {
        let navBar = UIView()
        navBar.backgroundColor = .clear
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        // closeButton -> 취소 확인 모달창으로 이동 필요
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "X_Button"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navBar)
        navBar.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 40),
            
            closeButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didTapCloseButton() {
        let stopSelectingVC = StopSelectingViewController()
        stopSelectingVC.modalTransitionStyle = .crossDissolve
        stopSelectingVC.modalPresentationStyle = .overFullScreen
        self.present(stopSelectingVC, animated: true, completion: nil)
    }
    
    // MARK: - Set UI
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(stackView)
        
        for (value, title) in items {
            let button = createItemButton(value: value, title: title)
            stackView.addArrangedSubview(button)
        }
    
        view.addSubview(createButton)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    // MARK: - 제약조건
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -20),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 9),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    // MARK: - 항목 버튼 생성 : 항목에 대한 버튼 구현 위한 함수, 버튼 탭 함수
    private func createItemButton(value: String, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.accessibilityIdentifier = value
        button.setTitleColor(UIColor(hex: "#555558"), for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1).cgColor
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 39).isActive = true
        button.addTarget(self, action: #selector(didTapItemButton(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func didTapItemButton(_ sender: UIButton) {
        guard let value = sender.accessibilityIdentifier else { return }
        
        if selectedItems.contains(value) {
            // 선택 해제
            selectedItems.removeAll { $0 == value }
            sender.backgroundColor = .white
            sender.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1).cgColor
            sender.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14) // Regular 폰트로 변경
        } else {
            // 최대 선택 개수 초과 방지
            guard selectedItems.count < 2 else { return }
            selectedItems.append(value)
            sender.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
            sender.layer.borderColor = UIColor(red: 0.43, green: 0.43, blue: 0.87, alpha: 1).cgColor
            sender.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14) 
        }
    }
    
    private func updateCreateButtonState() {
        if selectedItems.count == 2 {
            createButton.isEnabled = true
            createButton.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16)
            createButton.setTitleColor(.white, for: .normal)
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor(red: 0.44, green: 0.43, blue: 0.7, alpha: 1).cgColor,
                UIColor(red: 0.78, green: 0.55, blue: 0.75, alpha: 1).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = createButton.bounds
            gradientLayer.cornerRadius = 8
            createButton.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            createButton.isEnabled = false
            createButton.titleLabel?.textColor = UIColor(red: 0.67, green: 0.67, blue: 0.67, alpha: 1)
            createButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
            // Layer 제거
            createButton.layer.sublayers?.forEach {
                if $0 is CAGradientLayer {
                    $0.removeFromSuperlayer()
                }
            }
            createButton.backgroundColor = UIColor(hex: "#D9D9D9")
        }
        // subtitleLabel 텍스트 색상 변경
        subtitleLabel.textColor = selectedItems.isEmpty
            ? UIColor(hex: "#AAAAAA") // 아무것도 선택하지 않았을 때
            : UIColor(hex: "#7573C3") // 선택했을 때

        createButton.layer.shadowPath = UIBezierPath(roundedRect: createButton.bounds, cornerRadius: 8).cgPath
        createButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        createButton.layer.shadowOpacity = 1
        createButton.layer.shadowRadius = 1
        createButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        createButton.layer.masksToBounds = false
    }
    
    @objc private func didTapCreateButton() {
        print("선택된 값: \(selectedItems)")
        goToNextPage()
    }
    
    private func goToNextPage() {
        let resultVC = LoadingViewController() // 이동할 ViewController 인스턴스 생성
        resultVC.modalTransitionStyle = .crossDissolve // 화면 전환 스타일 설정 (페이드 효과)
        resultVC.modalPresentationStyle = .fullScreen
        self.present(resultVC, animated: true, completion: nil)
        print("ResultVC로 이동 성공")
    }
}
