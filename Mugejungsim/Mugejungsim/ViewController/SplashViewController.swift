//
//  SplashViewController.swift
//  Mugejungsim
//
//  Created by 현승훈 on 12/23/24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 색상 설정
        view.backgroundColor = UIColor.white
        
        // 로고 이미지 추가
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "newjeans")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        // 앱 이름 텍스트 추가
        let appNameLabel = UILabel()
        appNameLabel.text = "Moments"
        appNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        appNameLabel.textColor = UIColor.black
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appNameLabel)
        
        // 로고와 텍스트 레이아웃 설정
        NSLayoutConstraint.activate([
            // 로고 배치
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            // 텍스트 배치
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // 2초 후 메인 화면으로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let mainVC = MainViewController()
//            let mainVC = LoginViewController()
            mainVC.modalTransitionStyle = .crossDissolve
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: true, completion: nil)
        }
    }
}
