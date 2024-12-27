import UIKit

class CheckObjeImageViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "유리병 편지에 담긴 나만의 여행\n추억 컬러를 확인해보세요!"
        label.numberOfLines = 2
        label.textColor = UIColor(red: 0.46, green: 0.45, blue: 0.76, alpha: 1)
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let readButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("편지 읽기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = false // 그림자가 잘리지 않도록 false로 설정
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0.46, green: 0.45, blue: 0.76, alpha: 1)
        // 그림자 설정
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4 // 더 강하게 강조
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        return button
    }()
    
    let bottleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "moments") // 이미지 이름 확인
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // UI 요소 추가
        view.addSubview(textLabel)
        view.addSubview(readButton)
        view.addSubview(bottleImageView) // bottleImageView를 뷰에 추가
        
        // 버튼 액션 연결
        readButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        setConstraints()
    }
    
    // MARK: - Constraints Setup
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // bottleImageView 위치
            bottleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottleImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bottleImageView.widthAnchor.constraint(equalToConstant: 175), // 이미지 너비
            bottleImageView.heightAnchor.constraint(equalToConstant: 175), // 이미지 높이
            
            // textLabel 위치
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottleImageView.topAnchor, constant: -23),
            
            // readButton 위치
            readButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            readButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc func saveButtonTapped() {
        print("성공!")
        // 페이지 이동 추가
    }
}
