import UIKit

class OBViewController3: UIViewController {

    // dot1 이미지 뷰
    private let dotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dots3")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // 상단 텍스트 라벨
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "유리병 편지에 담긴\n여행의 추억을 확인해보세요!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 이미지 영역
    private let placeholderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "이미지는 GUI 다 완료후에\n이미지 추출로 넣을 예정"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()

    // 다음 버튼
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5338280797, green: 0.5380638838, blue: 0.8084236383, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false) // 내비게이션 바 숨기기
        setupUI()
    }

    private func setupUI() {
        view.addSubview(dotImageView)
        view.addSubview(titleLabel)
        view.addSubview(placeholderView)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            // Dot Image View Constraints
            dotImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 152),
            dotImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dotImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15), // 화면 너비의 15%
            dotImageView.heightAnchor.constraint(equalToConstant: 10),

            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: dotImageView.bottomAnchor, constant: 19),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Placeholder View Constraints
            placeholderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 39),
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8), // 화면 너비의 80%
            placeholderView.heightAnchor.constraint(equalTo: placeholderView.widthAnchor, multiplier: 0.93), // 기존 비율 유지

            // Next Button Constraints
            nextButton.topAnchor.constraint(equalTo: placeholderView.bottomAnchor, constant: 135),
            nextButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -35),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8), // 화면 너비의 80%
            nextButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    @objc private func nextButtonTapped() {
        let mainViewController = MainViewController()
        
        // 새 화면을 기존 뷰와 부드럽게 교체
        UIView.transition(with: self.view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            UIApplication.shared.windows.first?.rootViewController = mainViewController
        }, completion: nil)
    }
}
