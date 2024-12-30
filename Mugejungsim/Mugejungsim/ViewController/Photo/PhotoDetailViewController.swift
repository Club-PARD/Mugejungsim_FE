import UIKit

class PhotoDetailViewController: UIViewController {
    
    
    var selectedPhotoData: PhotoData? // 선택한 데이터 저장
    
    private var imageView: UIImageView!
    private var categoryButtonsStackView: UIStackView! // 세부 카테고리를 표시할 스택뷰
    private var descriptionTextView: UITextView!
    
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

        // 삭제 버튼
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal) // 텍스트 색상 빨간색
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        deleteButton.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

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
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65), // 내비게이션 바 아래에 위치
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

            // 마지막 콘텐츠 제약 조건 (스크롤 뷰의 높이를 확장)
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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

        // 카테고리 버튼 추가
        let categories = photoData.category.split(separator: ",").map { String($0) }
        for category in categories {
            let button = createCategoryButton(with: category)
            categoryButtonsStackView.addArrangedSubview(button)
        }

        // 텍스트뷰에 설명 설정
        descriptionTextView.text = photoData.text

        // 이미지 개수 레이블 업데이트
        updateImageCountLabel()
    }
    
    func createCategoryButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 173).isActive = true
        button.heightAnchor.constraint(equalToConstant: 37).isActive = true
        return button
    }
    
    func updateImageCountLabel() {
        if let index = DataManager.shared.loadData().firstIndex(where: { $0.imagePath == selectedPhotoData?.imagePath }) {
            let currentIndex = index + 1 // 배열은 0부터 시작하므로 +1
            let totalCount = DataManager.shared.loadData().count
            imageCountLabel.text = "\(currentIndex) / 25"
        }
    }
    
    func presentDeleteModal(for photo: PhotoData) {
        let deleteVC = DeleteViewController()
        deleteVC.delegate = self
        present(deleteVC, animated: true, completion: nil)
    }
    
    @objc private func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func deletePhoto() {
        guard let photoData = selectedPhotoData else {
            print("삭제할 데이터가 없습니다.")
            return
        }

        let deleteVC = DeleteViewController()
        deleteVC.photoData = photoData
        deleteVC.delegate = self
        present(deleteVC, animated: true, completion: nil)
    }
}

extension PhotoDetailViewController: DeleteViewControllerDelegate {
    func didDelete() {
        print("사진과 기록이 삭제되었습니다.")

        // `SavedPhotosViewController`로 돌아가기
//        if let navigationController = self.navigationController,
//           let savedVC = navigationController.viewControllers.first(where: { $0 is SavedPhotosViewController }) as? SavedPhotosViewController {
//            savedVC.refreshData() // `SavedPhotosViewController`에서 데이터 갱신
//            navigationController.popViewController(animated: true) // 이전 화면으로 이동
//        } else {
//            dismiss(animated: true, completion: nil)
//        }
        
        
        print("사진과 기록이 삭제되었습니다.")
//
//        if let presentingVC = presentingViewController as? SavedPhotosViewController {
//            dismiss(animated: true) {
//                presentingVC.refreshData() // 데이터 갱신
//            }
//        } else {
            dismiss(animated: true, completion: nil)
//        }
    }
}
