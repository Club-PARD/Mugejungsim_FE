//
//  ResultViewController.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/24/24.
//

/*
 필요사항
 1. 중앙 이미지 수정 필요
 */

import UIKit

class ResultViewController: UIViewController {
    
    // MARK: - Properties (UI Elements)
    
    let memoryLabel: UILabel = {
        let label = UILabel()
        // 나중에 기능 적용 시 username과 country text 넣어야 됨
        label.text = "OOO 님의\nOOO 여행 추억입니다."
        label.textColor = UIColor(red: 0.46, green: 0.45, blue: 0.76, alpha: 1)
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let touchLabel: UILabel = {
        let label = UILabel()
        label.text = "오브제를 터치하고\n움직여 보세요!"
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오브제 저장하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = false // 그림자가 잘리지 않도록 false로 설정
        button.translatesAutoresizingMaskIntoConstraints = false

        // 추가: 그라데이션 설정
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.44, green: 0.43, blue: 0.7, alpha: 1).cgColor,
            UIColor(red: 0.78, green: 0.55, blue: 0.75, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 8

        // DispatchQueue로 프레임 설정 (Auto Layout 이후)
        DispatchQueue.main.async {
            gradientLayer.frame = button.bounds
        }

        button.layer.insertSublayer(gradientLayer, at: 0)

        // 그림자 설정
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4 // 더 강하게 강조
        button.layer.shadowOffset = CGSize(width: 0, height: 2)

        return button
    }()
    
    let openPreviewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "moments"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 버튼 액션 연결
        openPreviewButton.addTarget(self, action: #selector(openUSDZPreviewController), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        view.addSubview(memoryLabel)
        view.addSubview(touchLabel)
        view.addSubview(openPreviewButton)
        view.addSubview(saveButton)
        
        setConstraints()
    }

    // MARK: - Constraints Setup
    
    private func setConstraints(){
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // openPreviewButton 위치 (화면 정중앙)
            openPreviewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openPreviewButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            openPreviewButton.widthAnchor.constraint(equalToConstant: 150), // 버튼 너비
            openPreviewButton.heightAnchor.constraint(equalToConstant: 150), // 버튼 높이
            // touchLabel
            touchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            touchLabel.bottomAnchor.constraint(equalTo: openPreviewButton.topAnchor, constant: -20),
            // memoryLabel
            memoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memoryLabel.bottomAnchor.constraint(equalTo: touchLabel.topAnchor, constant: -10),
            // saveButton
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Button Actions
    // 저장 버튼 푸시 함수
    @objc func saveButtonTapped(){
        print("성공!")
        
        // 페이지 이동 필요
    }
    
    // USDZPreviewViewController로 이동
    @objc func openUSDZPreviewController() {
        let USDZPreviewVC = USDZPreviewViewController() // USDZModal 페이지 호출
        USDZPreviewVC.modalPresentationStyle = .fullScreen
        present(USDZPreviewVC, animated: true, completion: nil)
    }
}
