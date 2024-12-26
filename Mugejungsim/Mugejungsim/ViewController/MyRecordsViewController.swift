import UIKit

class MyRecordsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 상단 제목 레이블
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "OOO 님의 여행 기록\n지금까지의 여행을 모아보세요!"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black // 폰트 색상을 검은색으로 설정
        label.backgroundColor = .lightGray // 배경 색상을 연한 회색으로 설정
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 기록/컬렉션 스위치
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["나의 여행", "나의 오브제"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .white // 기본 배경색 흰색
        control.selectedSegmentTintColor = UIColor(red: 110/255, green: 110/255, blue: 222/255, alpha: 1.0) // #6E6EDE 색상
        
        // "나의 여행" 텍스트 스타일
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        
        // "나의 오브제" 텍스트 스타일
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        
        control.setTitleTextAttributes(normalAttributes, for: .normal) // 비활성화 상태
        control.setTitleTextAttributes(selectedAttributes, for: .selected) // 활성화 상태
        
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()


    // 스크롤 가능한 ScrollView
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // 기록 리스트를 표시할 CollectionView
    let scrollableCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // 우측 하단 핑크 버튼
    let floatingButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 110/255, green: 110/255, blue: 222/255, alpha: 1.0) // #6E6EDE 색상
        button.setTitle("＋", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    
    let MyPageButton: UIButton = {
        let mine = UIButton()
        mine.translatesAutoresizingMaskIntoConstraints = false
        mine.layer.cornerRadius = 25
        mine.clipsToBounds = true
        mine.backgroundColor = UIColor.lightGray
        mine.setImage(UIImage(systemName: "person.circle"), for: .normal)
        mine.tintColor = .white
        return mine
    }()

    // 이미지 데이터 배열
    let travelImages: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupActions()
        setupCollectionView()
    }

    private func setupUI() {
        // UI 요소 추가
        view.addSubview(titleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(scrollView)
        view.addSubview(floatingButton)
        view.addSubview(MyPageButton)
        
        // ScrollView에 CollectionView 추가
        scrollView.addSubview(scrollableCollectionView)
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            scrollableCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollableCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollableCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollableCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollableCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollableCollectionView.heightAnchor.constraint(equalToConstant: 800), // 원하는 높이 설정
            
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            MyPageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            MyPageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            MyPageButton.widthAnchor.constraint(equalToConstant: 50),
            MyPageButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func setupActions() {
        // 핑크 버튼 클릭 이벤트
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }

    private func setupCollectionView() {
        scrollableCollectionView.delegate = self
        scrollableCollectionView.dataSource = self
        scrollableCollectionView.register(TravelRecordCell.self, forCellWithReuseIdentifier: "TravelRecordCell")
    }

    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return travelImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TravelRecordCell", for: indexPath) as! TravelRecordCell
        let imageName = travelImages[indexPath.row]
        cell.imageView.image = UIImage(named: imageName)
        cell.titleLabel.text = "기록 \(indexPath.row + 1)"
        return cell
    }

    // MARK: - UICollectionView DelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 3 // 3열 레이아웃
        return CGSize(width: width, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("기록 \(indexPath.row + 1) 선택됨")
    }

    @objc private func floatingButtonTapped() {
        // 팝업 메뉴 표시
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addAction = UIAlertAction(title: "여행 추가", style: .default) { _ in
            self.navigateToCreateViewController()
        }
        
        let sortAction = UIAlertAction(title: "여행 정렬하기", style: .default) { _ in
            print("여행 정렬하기 선택됨")
        }
        
        let deleteAction = UIAlertAction(title: "여행 삭제하기", style: .destructive) { _ in
            print("여행 삭제하기 선택됨")
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(sortAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    @objc private func segmentedControlChanged() {
        print("Segmented Control Changed")
    }

    private func navigateToCreateViewController() {
        let createViewController = CreateViewController()
        createViewController.modalPresentationStyle = .fullScreen
        present(createViewController, animated: true, completion: nil)
    }
}

// MARK: - Custom UICollectionViewCell
class TravelRecordCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.backgroundColor = UIColor(white: 0, alpha: 0.5) // 반투명 검정 배경
        label.textColor = .white // 흰색 텍스트
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
