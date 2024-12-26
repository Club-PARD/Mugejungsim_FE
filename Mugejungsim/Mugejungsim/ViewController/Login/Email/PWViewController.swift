import UIKit

class PWViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginlogo") // 로고 이미지 파일 필요
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력하세요."
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
            string: "비밀번호를 입력하세요.",
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
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
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
        // 텍스트가 있는 경우 버튼 스타일 변경
        if let text = emailTextField.text, !text.isEmpty {
            nextButton.setTitleColor(.white, for: .normal)
            nextButton.backgroundColor = UIColor(red: 117.0/255.0, green: 115.0/255.0, blue: 195.0/255.0, alpha: 1.0) // #7573C3
        } else {
            // 텍스트가 비어 있는 경우 버튼 기본 스타일로 복원
            nextButton.setTitleColor(.black, for: .normal)
            nextButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
    }
    
    // MARK: - Actions
    @objc private func nextButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "알림", message: "비밀번호를 입력하세요.")
            return
        }
        print("입력된 비밀번호: \(email)")
        // 다음 화면으로 전환하는 로직 추가
        let mainVC = NameViewController() 
        
        // UIView.transition을 이용한 부드러운 화면 전환
        UIView.transition(with: self.view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            UIApplication.shared.windows.first?.rootViewController = mainVC
        }, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

