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
        label.text = "OOO 님의\n OOO 여행 추억입니다."
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let touchLabel: UILabel = {
        let label = UILabel()
        label.text = "터치해 보세요!"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오브제 저장하기", for: .normal)
        button.backgroundColor = UIColor(hex: "#19FF5E")
        button.setTitleColor(.black, for: .normal)
        button.isEnabled = true // 버튼 활성화
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let openPreviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "moments"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
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
    }
    
    // USDZPreviewViewController로 이동
    @objc func openUSDZPreviewController() {
        let USDZPreviewVC = USDZPreviewViewController() // USDZModal 페이지 호출
        USDZPreviewVC.modalPresentationStyle = .fullScreen
        present(USDZPreviewVC, animated: true, completion: nil)
    }
}
