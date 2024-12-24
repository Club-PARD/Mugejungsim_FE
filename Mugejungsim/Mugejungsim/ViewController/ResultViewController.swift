//
//  ResultViewController.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/24/24.
//

import UIKit

class ResultViewController: UIViewController {
    
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

    // 버튼 선언
    let openPreviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "snow"), for: .normal) // 수정되어야함
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        // 버튼 액션 연결
        openPreviewButton.addTarget(self, action: #selector(openUSDZPreviewController), for: .touchUpInside)

        // 서브뷰 추가
        view.addSubview(memoryLabel)
        view.addSubview(touchLabel)
        view.addSubview(openPreviewButton)

        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // openPreviewButton 위치 (화면 정중앙)
            openPreviewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openPreviewButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            openPreviewButton.widthAnchor.constraint(equalToConstant: 150), // 버튼 너비
            openPreviewButton.heightAnchor.constraint(equalToConstant: 150), // 버튼 높이
            
            // touchLabel 위치 (openPreviewButton 위)
            touchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            touchLabel.bottomAnchor.constraint(equalTo: openPreviewButton.topAnchor, constant: -20),
            
            // memoryLabel 위치 (touchLabel 위)
            memoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memoryLabel.bottomAnchor.constraint(equalTo: touchLabel.topAnchor, constant: -10)
        ])
    }

    @objc func openUSDZPreviewController() {
        let USDZPreviewVC = USDZPreviewViewController() // USDZModal 페이지 호출
        USDZPreviewVC.modalPresentationStyle = .fullScreen
        present(USDZPreviewVC, animated: true, completion: nil)
    }
}
