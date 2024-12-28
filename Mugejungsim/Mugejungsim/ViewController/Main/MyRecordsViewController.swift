import UIKit

class MyRecordsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let myPageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.tintColor = .gray
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // 상단 제목 카드 뷰
    let titleCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginlogo") // 로고 이미지 파일 필요
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 상단 제목 레이블
    let titleLabel: UILabel = {
        let label1 = UILabel()
        label1.text = "무게중심 님의 여행 기록"
        label1.font = UIFont(name: "Pretendard-Bold", size: 22)
        label1.textColor = .black
        label1.numberOfLines = 1
        label1.textAlignment = .center
        label1.translatesAutoresizingMaskIntoConstraints = false
        return label1
    }()
    
    let subLabel: UILabel = {
        let label2 = UILabel()
        label2.text = "지금까지의 여행을 모아보세요!"
        label2.font = .systemFont(ofSize: 14, weight: .regular)
        label2.textColor = .gray
        label2.numberOfLines = 1
        label2.textAlignment = .center
        label2.translatesAutoresizingMaskIntoConstraints = false
        return label2
    }()
    
    // 커스텀 스타일의 Segmented Control
    let segmentedControlContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = false
        view.backgroundColor = UIColor(red: 110/255, green: 110/255, blue: 222/255, alpha: 1.0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["여행 기록", "오브제"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .clear
        control.selectedSegmentTintColor = .white
        control.layer.cornerRadius = 12
        control.clipsToBounds = true // 필수 설정
        
        // 기본 및 선택된 텍스트 스타일 설정
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 110/255, green: 110/255, blue: 222/255, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        
        control.setTitleTextAttributes(normalAttributes, for: .normal)
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        
        // 선택된 세그먼트의 CornerRadius 설정
        control.addTarget(self, action: #selector(updateSegmentedControlCorners), for: .valueChanged)
        return control
    }()
    
    @objc private func updateSegmentedControlCorners() {
        for subview in segmentedControl.subviews {
            subview.layer.cornerRadius = 12 // 전체 RoundedCorners와 동일하게 설정
            subview.clipsToBounds = true
        }
    }
    
    
    // 스크롤 가능한 ScrollView
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // 여행 기록 리스트를 표시할 CollectionView
    let scrollableTravelCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    let scrollableObjectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let contextMenu: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true // 초기에는 숨김 상태
        return view
    }()
    // 우측 하단 핑크 버튼
    let floatingButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 110/255, green: 110/255, blue: 222/255, alpha: 1.0)
        button.setTitle("＋", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let contextMenuContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true // 초기에는 숨김 상태
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
        setupCollectionView()
        setupContextMenu() // contextMenuContainer를 설정
    }
    private func createMenuButton(title: String, iconName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(" \(title)", for: .normal) // 텍스트와 아이콘 사이 간격을 위한 공백 추가
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        
        // 제공한 이미지 파일을 버튼 아이콘으로 설정
        let iconImage = UIImage(named: iconName) // iconName을 파일 이름으로 사용
        button.setImage(iconImage, for: .normal)
        
        button.tintColor = .black // 아이콘 색상 설정
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .center // 텍스트와 아이콘을 버튼의 가운데로 정렬
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44) // 버튼 높이 설정
        ])
        
        return button
    }
    
    private func setupContextMenu() {
        // 컨텍스트 메뉴 추가
        view.addSubview(contextMenuContainer)
        
        // 메뉴 버튼 생성
        let addButton = createMenuButton(title: "여행 추가", iconName: "image-add") // "image-add"는 추가 버튼 아이콘의 파일 이름
        let deleteButton = createMenuButton(title: "여행 삭제", iconName: "trash") // "trash"는 삭제 버튼 아이콘의 시스템 이름
        
        // 버튼에 액션 추가
        addButton.addTarget(self, action: #selector(addTripTapped), for: .touchUpInside)
        
        // 구분선 추가
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 110/255, green: 110/255, blue: 222/255, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        // 컨테이너에 버튼 및 구분선 추가
        contextMenuContainer.addSubview(addButton)
        contextMenuContainer.addSubview(divider)
        contextMenuContainer.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            // 컨테이너 크기 및 위치
            contextMenuContainer.widthAnchor.constraint(equalToConstant: 146),
            contextMenuContainer.heightAnchor.constraint(equalToConstant: 90),
            contextMenuContainer.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor),
            contextMenuContainer.bottomAnchor.constraint(equalTo: floatingButton.topAnchor, constant: -10),
            
            // 추가 버튼
            addButton.topAnchor.constraint(equalTo: contextMenuContainer.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: contextMenuContainer.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: contextMenuContainer.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 45),
            
            // 구분선
            divider.topAnchor.constraint(equalTo: addButton.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: contextMenuContainer.leadingAnchor, constant: 1),
            divider.trailingAnchor.constraint(equalTo: contextMenuContainer.trailingAnchor, constant: -1),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            // 삭제 버튼
            deleteButton.topAnchor.constraint(equalTo: divider.bottomAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: contextMenuContainer.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contextMenuContainer.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc private func addTripTapped() {
        // CreateViewController로 이동
        let createViewController = CreateViewController()
        createViewController.modalPresentationStyle = .fullScreen // 모달로 띄우는 경우
        self.present(createViewController, animated: false, completion: nil)
    }
    
    
    @objc private func toggleContextMenu() {
        UIView.animate(withDuration: 0.3) {
            self.contextMenuContainer.isHidden.toggle()
        }
    }
    private func setupUI() {
        // UI 요소 추가
        view.addSubview(logoImageView)
        view.addSubview(titleCardView)
        titleCardView.addSubview(titleLabel)
        titleCardView.addSubview(subLabel)
        
        view.addSubview(segmentedControlContainer)
        segmentedControlContainer.addSubview(segmentedControl)
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollableTravelCollectionView)
        
        view.addSubview(floatingButton)
        view.addSubview(myPageButton)
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            logoImageView.widthAnchor.constraint(equalToConstant: 134),
            logoImageView.heightAnchor.constraint(equalToConstant: 25),
            
            // Title Card View
            titleCardView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            titleCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            titleCardView.heightAnchor.constraint(equalToConstant: 93),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: titleCardView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 47),
            
            // Sub Label
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 47),
            
            // Segmented Control Container
            segmentedControlContainer.topAnchor.constraint(equalTo: titleCardView.bottomAnchor, constant: 30),
            segmentedControlContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 108),
            segmentedControlContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -108),
            segmentedControlContainer.heightAnchor.constraint(equalToConstant: 40),
            
            // Segmented Control
            segmentedControl.centerXAnchor.constraint(equalTo: segmentedControlContainer.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedControlContainer.centerYAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: segmentedControlContainer.widthAnchor, multiplier: 0.95),
            segmentedControl.heightAnchor.constraint(equalTo: segmentedControlContainer.heightAnchor, multiplier: 0.9),
            
            // My Page Button
            myPageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            myPageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            myPageButton.widthAnchor.constraint(equalToConstant: 50),
            myPageButton.heightAnchor.constraint(equalToConstant: 50),
            
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: segmentedControlContainer.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            // CollectionView
            scrollableTravelCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollableTravelCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollableTravelCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollableTravelCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollableTravelCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollableTravelCollectionView.heightAnchor.constraint(equalToConstant: 800),
            
            // Floating Button
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            
        ])
    }
    
    private func setupActions() {
        // 플로팅 버튼 클릭 이벤트 설정
        floatingButton.addTarget(self, action: #selector(toggleContextMenu), for: .touchUpInside)
        
        // 세그먼트 컨트롤 값 변경 이벤트 설정
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }
    
    private func setupCollectionView() {
        // 각 CollectionView의 delegate와 dataSource 설정
        scrollableTravelCollectionView.delegate = self
        scrollableTravelCollectionView.dataSource = self
        scrollableTravelCollectionView.register(TravelRecordCell.self, forCellWithReuseIdentifier: "TravelRecordCell")
        
        scrollableObjectCollectionView.delegate = self
        scrollableObjectCollectionView.dataSource = self
        scrollableObjectCollectionView.register(TravelRecordCell.self, forCellWithReuseIdentifier: "TravelRecordCell")
    }
    
    @objc private func segmentedControlChanged() {
        // 선택된 세그먼트 인덱스에 따라 다른 CollectionView 표시
        switch segmentedControl.selectedSegmentIndex {
        case 0: // 여행 기록
            scrollableObjectCollectionView.removeFromSuperview()
            scrollView.addSubview(scrollableTravelCollectionView)
            NSLayoutConstraint.activate([
                scrollableTravelCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                scrollableTravelCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                scrollableTravelCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                scrollableTravelCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                scrollableTravelCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                scrollableTravelCollectionView.heightAnchor.constraint(equalToConstant: 800)
            ])
        case 1: // 오브제
            scrollableTravelCollectionView.removeFromSuperview()
            scrollView.addSubview(scrollableObjectCollectionView)
            NSLayoutConstraint.activate([
                scrollableObjectCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                scrollableObjectCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                scrollableObjectCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                scrollableObjectCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                scrollableObjectCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                scrollableObjectCollectionView.heightAnchor.constraint(equalToConstant: 800)
            ])
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == scrollableTravelCollectionView {
            return 12 // 여행 기록 아이템 개수
        } else if collectionView == scrollableObjectCollectionView {
            return 8 // 오브제 아이템 개수
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TravelRecordCell", for: indexPath) as! TravelRecordCell
        
        if collectionView == scrollableTravelCollectionView {
            let imageName = "image\(indexPath.row + 1)"
            cell.imageView.image = UIImage(named: imageName)
            cell.titleLabel.text = "기록 \(indexPath.row + 1)"
        } else if collectionView == scrollableObjectCollectionView {
            let imageName = "object\(indexPath.row + 1)"
            cell.imageView.image = UIImage(named: imageName)
            cell.titleLabel.text = "오브제 \(indexPath.row + 1)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 3
        return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == scrollableTravelCollectionView {
            // 여행 기록 클릭 시 CollectionPhotosViewController로 화면 전환
            print("여행 기록 셀 클릭됨: \(indexPath.row)")
            let collectionPhotosVC = CollectionPhotosViewController()
            collectionPhotosVC.modalPresentationStyle = .fullScreen
            present(collectionPhotosVC, animated: true, completion: nil)
        } else if collectionView == scrollableObjectCollectionView {
            // 오브제 클릭 시 ObjectModalViewController 모달 띄우기
            print("오브제 셀 클릭됨: \(indexPath.row)")
            let objectModalVC = ObjectModalViewController()
            objectModalVC.modalPresentationStyle = .overFullScreen
            present(objectModalVC, animated: false, completion: nil)
        }
    }
    
    
    class TravelRecordCell: UICollectionViewCell {
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            return imageView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 1
            label.backgroundColor = UIColor(white: 0, alpha: 0.5)
            label.textColor = .white
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addSubview(imageView)
            contentView.addSubview(titleLabel)
            
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
}
