import UIKit
import KakaoSDKUser


class LoginViewController: UIViewController {
    
    var name : String = ""
    var provider : String = ""
    var userId: Int? // 서버에서 받은 userId를 저장
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginlogo") // 로고 이미지 파일 필요
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("구글로 시작하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.medium
        button.layer.borderColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "google")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -18, bottom: 0, right: 8)
        button.contentHorizontalAlignment = .center
        button.addShadow() // Shadow 추가
        return button
    }()
    
    private let kakaoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("카카오로 시작하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.medium
        button.layer.borderColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "kakao")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -18, bottom: 0, right: 8)
        button.contentHorizontalAlignment = .center
        button.addShadow() // Shadow 추가
        return button
    }()
    
    private let emailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이메일로 시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.font(.pretendardSemiBold, ofSize: 16)
        button.layer.borderColor = #colorLiteral(red: 0.4588235294, green: 0.4509803922, blue: 0.7647058824, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.backgroundColor = #colorLiteral(red: 0.4588235294, green: 0.4509803922, blue: 0.7647058824, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addShadow() // Shadow 추가
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(googleButton)
        view.addSubview(kakaoButton)
        view.addSubview(emailButton)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 226),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 205),
            logoImageView.heightAnchor.constraint(equalToConstant: 30),
            
            googleButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 70),
            googleButton.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor),
            googleButton.widthAnchor.constraint(equalToConstant: 327),
            googleButton.heightAnchor.constraint(equalToConstant: 52),
            
            kakaoButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 10),
            kakaoButton.centerXAnchor.constraint(equalTo: googleButton.centerXAnchor),
            kakaoButton.widthAnchor.constraint(equalToConstant: 327),
            kakaoButton.heightAnchor.constraint(equalTo: googleButton.heightAnchor),
            
            emailButton.topAnchor.constraint(equalTo: kakaoButton.bottomAnchor, constant: 10),
            emailButton.centerXAnchor.constraint(equalTo: googleButton.centerXAnchor),
            emailButton.widthAnchor.constraint(equalToConstant: 327),
            emailButton.heightAnchor.constraint(equalTo: googleButton.heightAnchor),
            
            googleButton.imageView!.widthAnchor.constraint(equalToConstant: 21),
            googleButton.imageView!.heightAnchor.constraint(equalToConstant: 21.6),
            
            kakaoButton.imageView!.widthAnchor.constraint(equalToConstant: 27),
            kakaoButton.imageView!.heightAnchor.constraint(equalToConstant: 27)
        ])
        
        googleButton.addTarget(self, action: #selector(handleOtherButtons), for: .touchUpInside)
        kakaoButton.addTarget(self, action: #selector(didTapKakaoLogin), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(handleEmailButton), for: .touchUpInside)
    }
    
    @objc private func handleOtherButtons() {
        showAlert(title: "알림", message: "이 버튼은 현재 지원되지 않습니다.")
    }
    
    @objc private func handleEmailButton() {
        let emailVC = EmailViewController()
        emailVC.modalPresentationStyle = .fullScreen
        present(emailVC, animated: true, completion: nil)
    }
    
    @objc private func didTapKakaoLogin() {
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
        UserApi.shared.me { user, error in
            if let error = error {
                print("사용자 정보 가져오기 실패: \(error.localizedDescription)")
                self.showAlert(title: "에러", message: "사용자 정보를 가져오는 데 실패했습니다.")
            } else if let user = user {
                let nickname = user.kakaoAccount?.profile?.nickname ?? "사용자"
                let provider = "kakao"
                
                // 서버로 로그인 정보 전송 후 userId 받아오기
                self.sendLoginDataToServer(name: nickname, provider: provider) { userId in
                    if let userId = userId {
                        TravelRecordManager.shared.userId = userId // userId 저장
                        print("서버에서 받은 userId: \(userId)")
                        
                        // 다음 화면으로 이동
                        self.navigateToOnboarding(with: nickname)
                    } else {
                        print("userId를 받지 못했습니다.")
                        self.showAlert(title: "오류", message: "서버에서 사용자 정보를 처리할 수 없습니다.")
                    }
                }
            }
        }
    }
    
    private func navigateToOnboarding(with nickname: String) {
        let onboardingVC = OBViewController1()
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func sendLoginDataToServer(name: String, provider: String, completion: @escaping (Int?) -> Void) {
        let url = URL(string: "http://172.17.208.113:8080/api/users/save")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: String] = [
            "name": name,
            "provider": provider
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let userId = json["userId"] as? Int {
                    DispatchQueue.main.async {
                        completion(userId)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
}

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor // 섀도우 색상
        self.layer.shadowOpacity = 0.25 // 섀도우 투명도 (25%)
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5) // X: 0.5, Y: 0.5
        self.layer.shadowRadius = 1 // Blur 값: 1
        self.layer.masksToBounds = false
    }
}
