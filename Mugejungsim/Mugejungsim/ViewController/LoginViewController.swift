//
//  LoginViewController.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/23/24.
//

import UIKit
import KakaoSDKUser

class LoginViewController: UIViewController {
    private let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        
        // 이미지 설정 (렌더링 모드 확인 및 디버깅)
        if let image = UIImage(named: "kakao")?.withRenderingMode(.alwaysOriginal) {
            button.setImage(image, for: .normal)
        } else {
            print("이미지 'kakao_login_medium_wide'를 로드할 수 없습니다. 파일 이름을 확인하세요.")
        }
        
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .clear // 기본 파란색 Tint 제거
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // 버튼 추가 및 레이아웃 설정
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
                loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                loginButton.widthAnchor.constraint(equalToConstant: 300),
                loginButton.heightAnchor.constraint(equalToConstant: 60),
            ])
    }
    
    private func setupActions() {
        // 버튼에 액션 연결
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    
    @objc private func didTapLogin() {
        // 카카오톡 앱을 통한 로그인
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print("카카오톡 로그인 실패: \(error.localizedDescription)")
                    self.showAlert(title: "로그인 실패", message: "카카오톡 로그인에 실패했습니다.")
                } else {
                    print("카카오톡 로그인 성공, 토큰: \(oauthToken?.accessToken ?? "")")
                    self.fetchUserInfo()
                }
            }
        } else {
            self.showAlert(title: "카카오톡 필요", message: "카카오톡 앱이 설치되어야 로그인을 진행할 수 있습니다.")
        }
    }
    
    private func fetchUserInfo() {
        // 사용자 정보 가져오기
        UserApi.shared.me { user, error in
            if let error = error {
                print("사용자 정보 가져오기 실패: \(error.localizedDescription)")
                self.showAlert(title: "에러", message: "사용자 정보를 가져오는 데 실패했습니다.")
            } else if let user = user {
                let nickname = user.kakaoAccount?.profile?.nickname ?? "사용자"
                print("사용자 정보 가져오기 성공: \(nickname)")
                
                // MainViewController로 닉네임 전달
                self.showMainViewController(with: nickname)
            }
        }
    }
    
    private func showMainViewController(with nickname: String) {
        // MainViewController 인스턴스 생성
        let mainViewController = MainViewController()
        //mainViewController.username = nickname
        
        // 화면 전환 (네비게이션 컨트롤러가 있을 경우 push, 없으면 present)
        if let navigationController = self.navigationController {
            navigationController.pushViewController(mainViewController, animated: true)
        } else {
            mainViewController.modalPresentationStyle = .fullScreen
            present(mainViewController, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
