import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // 타이틀 라벨 생성
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "무게중심 님의 \n여행기를 남겨보세요!"
            label.font = .systemFont(ofSize: 25, weight: .bold)
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let imageView: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGray
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let placeholderLabel = UILabel()
            placeholderLabel.text = "로고 이미지\nor\n3D 이미지"
            placeholderLabel.font = .systemFont(ofSize: 25, weight: .regular)
            placeholderLabel.textColor = .black
            placeholderLabel.textAlignment = .center
            placeholderLabel.numberOfLines = 0
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(placeholderLabel)
            
            // 중앙 정렬 오토레이아웃
            NSLayoutConstraint.activate([
                placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            return view
        }()

        // 버튼 생성
        let button: UIButton = {
            let button = UIButton(type: .system)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 117/255, green: 115/255, blue: 195/255, alpha: 1) // #7573C3
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false

            // 텍스트 스타일 설정
            let attributedText = NSMutableAttributedString(
                string: "여행 기록 만들기",
                attributes: [
                    .font: UIFont(name: "Pretendard-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold),
                    .kern: -0.3 // 자간 설정
                ]
            )
            button.setAttributedTitle(attributedText, for: .normal)
            return button
        }()
        
        // 버튼 클릭 이벤트 추가
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // 뷰에 추가
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(button)
        
        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            // 타이틀 라벨
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 218),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 이미지 영역
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 237),
            imageView.heightAnchor.constraint(equalToConstant: 237),
            
            // 버튼
            button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 327),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // 버튼 클릭 이벤트 처리
    @objc private func buttonTapped() {
        let createViewController = CreateViewController()
        createViewController.modalPresentationStyle = .fullScreen // 화면 전체로 표시 (선택 사항)
        present(createViewController, animated: true, completion: nil)
    }
}
