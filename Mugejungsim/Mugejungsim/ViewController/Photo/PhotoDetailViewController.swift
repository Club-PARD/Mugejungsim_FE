import UIKit

class PhotoDetailViewController: UIViewController {
    
    var selectedPhotoData: PhotoData? // 선택한 데이터 저장
    var currentPhotoIndex: Int = 0 // 현재 사진의 인덱스
    var allPhotoData: [PhotoData] = [] // 전체 사진 데이터

    private var imageView: UIImageView!
    private var categoryButtonsStackView: UIStackView! // 세부 카테고리를 표시할 스택뷰
    private var descriptionTextView: UITextView!
    
    // 이미지 개수 레이블
    private var imageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1 / 1" // 초기값 설정
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Medium", size: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCustomNavigationBar()
        setupUI()
        populateData()
    }
    
    func setupCustomNavigationBar() {
        let navBar = UIView()
        navBar.backgroundColor = .white // 배경색 설정
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        // 뒤로가기 버튼
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "X_Button"), for: .normal) // 뒤로가기 버튼 이미지 설정
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 내비게이션 바에 뷰 추가
        navBar.addSubview(backButton)
        navBar.addSubview(imageCountLabel)
        view.addSubview(navBar)
        
        // 내비게이션 바 레이아웃
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 65),
            
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 26),
            
            imageCountLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            imageCountLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor)
        ])
    }
    
    func setupUI() {
        // 스크롤 뷰와 콘텐츠 뷰 추가
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 검정 박스(외곽) 설정
        let blackBoxView = UIView()
        blackBoxView.backgroundColor = .white
        blackBoxView.layer.cornerRadius = 10 // 박스에 라운드 효과 (필요 시)
        blackBoxView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(blackBoxView)
        
        // 이미지 뷰 설정
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // 이미지를 비율에 맞게 맞춤
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear // 이미지 배경 투명 설정
        imageView.translatesAutoresizingMaskIntoConstraints = false
        blackBoxView.addSubview(imageView)
        
        let categoryScrollView = UIScrollView()
        categoryScrollView.showsHorizontalScrollIndicator = false
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryScrollView)
        
        // 카테고리 버튼들을 담을 스택뷰 설정
        categoryButtonsStackView = UIStackView()
        categoryButtonsStackView.axis = .horizontal
        categoryButtonsStackView.alignment = .center
        categoryButtonsStackView.distribution = .equalSpacing
        categoryButtonsStackView.spacing = 10
        categoryButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        categoryScrollView.addSubview(categoryButtonsStackView)
        
        // 텍스트뷰 설정
        descriptionTextView = UITextView()
        descriptionTextView.backgroundColor = .white
        descriptionTextView.font = UIFont(name: "Pretendard-Regular", size: 15)
        descriptionTextView.textColor = .black
        descriptionTextView.isEditable = false
        descriptionTextView.layer.cornerRadius = 7
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor(red: 0.824, green: 0.824, blue: 0.961, alpha: 1).cgColor
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionTextView)
        
        // 스크롤 뷰와 콘텐츠 뷰의 제약 조건
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // 콘텐츠 뷰 내부 컴포넌트 레이아웃
        NSLayoutConstraint.activate([
            // 검정 박스
            blackBoxView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            blackBoxView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            blackBoxView.widthAnchor.constraint(equalToConstant: 444),
            blackBoxView.heightAnchor.constraint(equalToConstant: 324),
            
            // 이미지 뷰 (검정 박스 안에서 중앙 정렬)
            imageView.centerXAnchor.constraint(equalTo: blackBoxView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: blackBoxView.centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: blackBoxView.widthAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: blackBoxView.heightAnchor),
            
            // 카테고리 스크롤 뷰
            categoryScrollView.topAnchor.constraint(equalTo: blackBoxView.bottomAnchor, constant: 20),
            categoryScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 50),
            
            // 카테고리 스택뷰
            categoryButtonsStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryButtonsStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryButtonsStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryButtonsStackView.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryButtonsStackView.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor),
            
            // 텍스트 뷰
            descriptionTextView.topAnchor.constraint(equalTo: categoryButtonsStackView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 135),
            
            // 마지막 콘텐츠 제약 조건
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func populateData() {
        guard let photoData = selectedPhotoData else { return }
        // 이미지 로드
        if let url = URL(string: photoData.imagePath) {
            loadImageAsync(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.imageView.image = image ?? UIImage(named: "placeholder")
                }
            }
        }
        // 카테고리 버튼 초기화 후 추가
        categoryButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for category in photoData.categories {
            let button = createCategoryButton(with: category)
            categoryButtonsStackView.addArrangedSubview(button)
        }
        // 텍스트뷰 업데이트
        descriptionTextView.text = photoData.text
        updateImageCountLabel()
    }
    
    func loadImageAsync(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("이미지 로드 실패: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("HTTP 상태 코드 오류: \(httpResponse.statusCode)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("이미지 데이터가 유효하지 않거나 변환 실패")
                completion(nil)
                return
            }

            completion(image)
        }.resume()
    }
    
    func createCategoryButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        return button
    }
    
    func updateImageCountLabel() {
        let totalCount = allPhotoData.count
        imageCountLabel.text = "\(currentPhotoIndex + 1) / \(totalCount)"
    }
    
    @objc private func goBack() {
        dismiss(animated: true, completion: nil)
    }
}
