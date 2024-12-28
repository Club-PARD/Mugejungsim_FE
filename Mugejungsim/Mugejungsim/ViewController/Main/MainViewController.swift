//import UIKit
//
//class MainViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .white
//        
//        // 타이틀 라벨 생성
//        let titleLabel: UILabel = {
//            let label = UILabel()
//            label.text = "무게중심 님의\n여행기를 남겨보세요!"
//            label.font = UIFont.font(.pretendardSemiBold, ofSize: 22.46)
//            label.textColor = .black
//            label.textAlignment = .center
//            label.numberOfLines = 0
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
//        
//        let imageView: UIView = {
//            let view = UIView()
//            view.backgroundColor = .lightGray
//            view.layer.cornerRadius = 10
//            view.clipsToBounds = true
//            view.translatesAutoresizingMaskIntoConstraints = false
//            
//            let placeholderLabel = UILabel()
//            placeholderLabel.text = "로고 이미지\nor\n3D 이미지"
//            placeholderLabel.font = .systemFont(ofSize: 25, weight: .regular)
//            placeholderLabel.textColor = .black
//            placeholderLabel.textAlignment = .center
//            placeholderLabel.numberOfLines = 0
//            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
//            
//            view.addSubview(placeholderLabel)
//            
//            // 중앙 정렬 오토레이아웃
//            NSLayoutConstraint.activate([
//                placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//            ])
//            
//            return view
//        }()
//
//        // 버튼 생성
//        let button: UIButton = {
//            let button = UIButton(type: .system)
//            button.setTitleColor(.white, for: .normal)
//            button.backgroundColor = UIColor(red: 117/255, green: 115/255, blue: 195/255, alpha: 1) // #7573C3
//            button.layer.cornerRadius = 8
//            button.clipsToBounds = false // 섀도우를 표시하려면 `clipsToBounds`를 false로 설정
//            button.translatesAutoresizingMaskIntoConstraints = false
//
//            // 텍스트 스타일 설정
//            let attributedText = NSMutableAttributedString(
//                string: "여행 기록 만들기",
//                attributes: [
//                    .font: UIFont(name: "Pretendard-SemiBold", size: 16) ?? UIFont.font(.pretendardSemiBold, ofSize: 16),
//                    .kern: -0.3 // 자간 설정
//                ]
//            )
//            button.setAttributedTitle(attributedText, for: .normal)
//
//            // Drop shadow 설정
//            button.layer.shadowColor = UIColor.black.cgColor // 섀도우 색상
//            button.layer.shadowOpacity = 0.15 // 섀도우 투명도 (15%)
//            button.layer.shadowOffset = CGSize(width: 1.95, height: 1.95) // X: 1.95, Y: 1.95
//            button.layer.shadowRadius = 2.6 // Blur 값
//
//            return button
//        }()
//        
//        // 버튼 클릭 이벤트 추가
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        
//        // 뷰에 추가
//        view.addSubview(titleLabel)
//        view.addSubview(imageView)
//        view.addSubview(button)
//        
//        // 오토레이아웃 설정
//        NSLayoutConstraint.activate([
//            // 타이틀 라벨
//            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 218),
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            // 이미지 영역
//            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 51),
//            imageView.widthAnchor.constraint(equalToConstant: 237),
//            imageView.heightAnchor.constraint(equalToConstant: 219),
//            
//            // 버튼
//            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -158),
//            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            button.widthAnchor.constraint(equalToConstant: 327),
//            button.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//    
//    // 버튼 클릭 이벤트 처리
//    @objc private func buttonTapped() {
//        let createViewController = CreateViewController()
//        createViewController.modalPresentationStyle = .fullScreen // 화면 전체로 표시 (선택 사항)
//        present(createViewController, animated: true, completion: nil)
//    }
//}
