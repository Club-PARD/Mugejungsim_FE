//
//  LoadingViewController.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/24/24.
//

import UIKit

class LoadingViewController: UIViewController {
    
    // "오브제 만드는 중" 라벨
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "오브제 만드는 중"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 로딩 중 이미지
    private let loadingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "moments")) // "snow"는 프로젝트의 이미지 파일 이름
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        startLoading()
    }
    
    // UI 설정
    private func setupUI() {
        view.addSubview(loadingLabel)
        view.addSubview(loadingImageView)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // 로딩 이미지 위치
            loadingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            loadingImageView.widthAnchor.constraint(equalToConstant: 100),
            loadingImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // 로딩 라벨 위치 (이미지 위)
            loadingLabel.bottomAnchor.constraint(equalTo: loadingImageView.topAnchor, constant: -80),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // 로딩 시작
    private func startLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.goToNextPage()
        }
    }
    
    // 다음 화면으로 이동
    private func goToNextPage() {
        // 다음 화면 이동 코드
        let resultVC = ResultViewController()
        resultVC.modalTransitionStyle = .crossDissolve
        resultVC.modalPresentationStyle = .fullScreen
        self.present(resultVC, animated: true, completion: nil)
        print("ResultVC로 이동 성공")
    }
}
