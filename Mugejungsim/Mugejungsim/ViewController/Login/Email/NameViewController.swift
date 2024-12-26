import UIKit

class NameViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginlogo") // 로고 이미지 파일 필요
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력하세요."
        textField.backgroundColor = .white
        textField.borderStyle = .none // 기본 테두리를 제거
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false

        // 테두리 색상 설정
        textField.layer.borderColor = UIColor(white: 170.0/255.0, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 4

        // 플레이스홀더 색상 설정
        textField.attributedPlaceholder = NSAttributedString(
            string: "닉네임을 입력하세요.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 170.0/255.0, alpha: 1.0)]
        )

        // 텍스트 필드 내부 간격 설정
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 0)) // leading 간격
        textField.leftView = paddingView
        textField.leftViewMode = .always

        // 텍스트 입력 시 글씨 색상 설정
        textField.textColor = .black

        return textField
    }()
    
    private let charCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/6" // 초기 값
        label.textColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9309713244, green: 0.9309713244, blue: 0.9309713244, alpha: 1)
        button.layer.cornerRadius = 4
        button.addShadow() // Drop shadow 추가
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupTextFieldObservers()
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        emailTextField.addSubview(charCountLabel) // charCountLabel을 텍스트 필드에 추가
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            // 로고 이미지 위치
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 226),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 205),
            logoImageView.heightAnchor.constraint(equalToConstant: 30),
            
            // 이메일 라벨 위치
            emailLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 60),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // 이메일 입력 필드 위치
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 9),
            emailTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 52),
            
            // 글자 수 표시 라벨 위치 (텍스트 필드 내부)
            charCountLabel.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor),
            charCountLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: -22),
            
            // 다음 버튼 위치
            nextButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            nextButton.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setupTextFieldObservers() {
        // 텍스트 필드 값 변경 감지
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        // 글자 수 업데이트
        let text = emailTextField.text ?? ""
        let charCount = min(text.count, 6) // 최대 6글자 제한
        charCountLabel.text = "\(charCount)/6"
        
        // 텍스트 필드 글자 제한
        if text.count > 6 {
            emailTextField.text = String(text.prefix(6))
        }
        
        // 버튼 스타일 업데이트
        if charCount > 0 {
            nextButton.setTitleColor(.white, for: .normal)
            nextButton.backgroundColor = UIColor(red: 117.0/255.0, green: 115.0/255.0, blue: 195.0/255.0, alpha: 1.0) // #7573C3
        } else {
            nextButton.setTitleColor(.black, for: .normal)
            nextButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
    }
    
    private func navigateToOnboarding() {
        let onboardingVC = OBViewController1()
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func nextButtonTapped() {
        guard let nickname = emailTextField.text, !nickname.isEmpty else {
            showAlert(title: "알림", message: "닉네임을 입력하세요.")
            return
        }
        print("입력된 닉네임: \(nickname)")
        navigateToOnboarding()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
