import UIKit

class PhotoDetailViewController: UIViewController {
    
    var selectedPhotoData: PhotoData? // 선택한 데이터 저장
    
    private var imageView: UIImageView!
    private var categoryLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    // 이미지 개수 레이블
    private var imageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1 / 25" // 초기값 설정
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Medium", size: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 내비게이션 바 설정
        setupCustomNavigationBar()
        
        // UI 구성
        setupUI()
        
        // 데이터 설정
        populateData()
    }
    
    func setupCustomNavigationBar() {
        let navBar = UIView()
        navBar.backgroundColor = .clear
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        // 뒤로가기 버튼
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "X_Button"), for: .normal) // 뒤로가기 버튼 이미지 설정
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navBar)
        navBar.addSubview(backButton)
        navBar.addSubview(imageCountLabel)
        
        // 내비게이션 바 레이아웃 설정
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 65),
            
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -28),
            
            imageCountLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            imageCountLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor)
        ])
    }
    
    func setupUI() {
        // 이미지 뷰 설정
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // 카테고리 레이블 설정
        categoryLabel = UILabel()
        categoryLabel.font = UIFont(name: "Pretendard-Bold", size: 16)
        categoryLabel.textColor = .darkGray
        categoryLabel.textAlignment = .center
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryLabel)
        
        // 설명 레이블 설정
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        // 레이아웃 설정
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            categoryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func populateData() {
        guard let photoData = selectedPhotoData else { return }
        
        // 이미지 로드
        if let image = DataManager.shared.loadImage(from: photoData.imagePath) {
            imageView.image = image
        } else {
            print("이미지를 로드할 수 없습니다: \(photoData.imagePath)")
        }
        
        // 카테고리 설정
        categoryLabel.text = "카테고리: \(photoData.category)"
        
        // 텍스트 설정
        descriptionLabel.text = photoData.text
        
        // 이미지 개수 레이블 업데이트
        updateImageCountLabel()
    }
    
    func updateImageCountLabel() {
        if let index = DataManager.shared.loadData().firstIndex(where: { $0.imagePath == selectedPhotoData?.imagePath }) {
            let currentIndex = index + 1 // 배열은 0부터 시작하므로 +1
            let totalCount = DataManager.shared.loadData().count
            imageCountLabel.text = "\(currentIndex) / \(totalCount)"
        }
    }
    
    @objc private func goBack() {
        dismiss(animated: true, completion: nil)
    }
}
