import UIKit

class MyRecordsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var travelRecords: [TravelRecord] = [] // 여행 기록 데이터
    
    let myPageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.tintColor = .gray
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        view.layer.cornerRadius = 8
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
        control.clipsToBounds = true // 필수 설정
        
        // 기본 및 선택된 텍스트 스타일 설정
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 110/255, green: 110/255, blue: 222/255, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
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
            subview.clipsToBounds = true
        }
    }
    
    // 스크롤 가능한 ScrollView
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceHorizontal = false
        return scrollView
    }()
    
    // 여행 기록 리스트를 표시할 CollectionView
    let scrollableTravelCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let scrollableObjectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
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
        
        loadTravelRecords() // 데이터셋 로드
        updateCollectionViewHeight()
        updateScrollViewContentSize()
        view.setNeedsLayout()
        view.layoutIfNeeded()
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
            contextMenuContainer.widthAnchor.constraint(equalToConstant: 146),
            contextMenuContainer.heightAnchor.constraint(equalToConstant: 90),
            contextMenuContainer.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor),
            contextMenuContainer.bottomAnchor.constraint(equalTo: floatingButton.topAnchor, constant: -10),
            
            addButton.topAnchor.constraint(equalTo: contextMenuContainer.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: contextMenuContainer.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: contextMenuContainer.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 45),
            
            divider.topAnchor.constraint(equalTo: addButton.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: contextMenuContainer.leadingAnchor, constant: 1),
            divider.trailingAnchor.constraint(equalTo: contextMenuContainer.trailingAnchor, constant: -1),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            deleteButton.topAnchor.constraint(equalTo: divider.bottomAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: contextMenuContainer.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contextMenuContainer.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc private func addTripTapped() {
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
            segmentedControlContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            segmentedControlContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            segmentedControlContainer.heightAnchor.constraint(equalToConstant: 40),
            
            // Segmented Control
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainer.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlContainer.trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlContainer.topAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: segmentedControlContainer.bottomAnchor),
            
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
            scrollableTravelCollectionView.heightAnchor.constraint(equalToConstant: calculateCollectionViewHeight()),
            
            // Floating Button
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    private func setupActions() {
        floatingButton.addTarget(self, action: #selector(toggleContextMenu), for: .touchUpInside)                   // 플로팅 버튼 클릭 이벤트 설정
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)            // 세그먼트 컨트롤 값 변경 이벤트 설정
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
        print("Segmented control changed to index: \(segmentedControl.selectedSegmentIndex)")

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
                scrollableTravelCollectionView.heightAnchor.constraint(equalToConstant: calculateCollectionViewHeight()),
            ])
            reloadTravelRecords() // 여행 기록 데이터를 다시 로드
            print("Reloaded Travel Records. Count: \(travelRecords.count)")
            travelRecords.forEach { record in
                print("TravelRecord - Title: \(record.title), OneLine1: \(record.oneLine1)!")
            }
        case 1: // 오브제
            scrollableTravelCollectionView.removeFromSuperview()
            scrollView.addSubview(scrollableObjectCollectionView)
            NSLayoutConstraint.activate([
                scrollableObjectCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                scrollableObjectCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                scrollableObjectCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                scrollableObjectCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                scrollableObjectCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                scrollableObjectCollectionView.heightAnchor.constraint(equalToConstant: calculateCollectionViewHeight()),
            ])
            reloadTravelRecords() // 여행 기록 데이터를 다시 로드
            print("Reloaded Travel Records. Count: \(travelRecords.count)")
            travelRecords.forEach { record in
                print("TravelRecord - Title: \(record.title), OneLine1: \(record.oneLine1)!")
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == scrollableTravelCollectionView {
            print("T count: \(travelRecords.count)")
            return travelRecords.count // 여행 기록 데이터 개수
        } else if collectionView == scrollableObjectCollectionView {
            print("O count: \(travelRecords.count)")
//            return objects.count // 오브제 데이터 개수
            return travelRecords.count // 여행 기록 데이터 개수

        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TravelRecordCell", for: indexPath) as! TravelRecordCell
        let record = travelRecords[indexPath.row]
        if collectionView == scrollableTravelCollectionView {
            switch record.oneLine1 {
            case "value1":
                cell.imageView.image = UIImage(named: "핑크")
            case "value2":
                cell.imageView.image = UIImage(named: "클라우디")
            case "value3":
                cell.imageView.image = UIImage(named: "밝은 노랑")
            case "value4":
                cell.imageView.image = UIImage(named: "골드주황")
            case "value5":
                cell.imageView.image = UIImage(named: "하늘색")
            case "value6":
                cell.imageView.image = UIImage(named: "네이비")
            case "value7":
                cell.imageView.image = UIImage(named: "보라색")
            case "value8":
                cell.imageView.image = UIImage(named: "브라운")
            case "value9":
                cell.imageView.image = UIImage(named: "레드")
            case "value10":
                cell.imageView.image = UIImage(named: "연두색")
            default:
                cell.imageView.image = UIImage(named: "브라운") // 기본 이미지
            }
            cell.titleLabel.text = record.title // 여행 기록 제목
            print("pass")
        } else if collectionView == scrollableObjectCollectionView {
//            print("oneLine1 value: \(record.oneLine1)") // 추가된 디버깅
            switch record.oneLine1 {
            case "value1":
                cell.imageView.image = UIImage(named: "Dreamy Pink")
            case "value2":
                cell.imageView.image = UIImage(named: "Cloud Whisper")
            case "value3":
                cell.imageView.image = UIImage(named: "Sunburst Yellow")
            case "value4":
                cell.imageView.image = UIImage(named: "Radiant Orange")
            case "value5":
                cell.imageView.image = UIImage(named: "Serene Sky")
            case "value6":
                cell.imageView.image = UIImage(named: "Midnight Depth")
            case "value7":
                cell.imageView.image = UIImage(named: "Wanderer's Flame")
            case "value8":
                cell.imageView.image = UIImage(named: "Storybook Brown")
            case "value9":
                cell.imageView.image = UIImage(named: "Ember Red")
            case "value10":
                cell.imageView.image = UIImage(named: "Meadow Green")
            default:
                cell.imageView.image = UIImage(named: "Storybook Brown") // 기본 이미지
            }
            cell.titleLabel.text = record.title // 오브제 이름
            print("Shit")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.frame.width - 48) / 3
//        return CGSize(width: width, height: 150)
        let itemsPerRow: CGFloat = 3
        let totalSpacing: CGFloat = 48 // 16 * 3 (두 셀 사이의 간격)
        let width = (collectionView.frame.width - totalSpacing) / itemsPerRow
        return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == scrollableTravelCollectionView {
            // 여행 기록 클릭 시 CollectionPhotosViewController로 화면 전환
            let selectedRecord = travelRecords[indexPath.row]
            print("여행 기록 셀 클릭됨: \(indexPath.row)")
            let collectionPhotosVC = CollectionPhotosViewController()
            collectionPhotosVC.modalPresentationStyle = .fullScreen
            collectionPhotosVC.recordID = selectedRecord.id.uuidString // 레코드 ID 전달
            present(collectionPhotosVC, animated: true, completion: nil)
        } else if collectionView == scrollableObjectCollectionView {
            let selectedRecord = travelRecords[indexPath.row]
            // 오브제 클릭 시 ObjectModalViewController 모달 띄우기
            print("오브제 셀 클릭됨: \(indexPath.row)")
            
            let objectModalVC = ObjectModal()
            objectModalVC.recordID = selectedRecord.id.uuidString
            objectModalVC.modalPresentationStyle = .fullScreen
            present(objectModalVC, animated: false, completion: nil)
        }
    }
    
    private func loadTravelRecords() {
        // 샘플 데이터를 TravelRecordManager에서 가져오기
        travelRecords = TravelRecordManager.shared.getAllRecords()
        print("Loaded travel records count: \(travelRecords.count)")
        travelRecords.forEach { record in
            print("TravelRecord - Title: \(record.title), OneLine1: \(record.oneLine1)")
        }
    }

    private func reloadTravelRecords() {
        travelRecords = TravelRecordManager.shared.getAllRecords()
        scrollableTravelCollectionView.reloadData()
        updateCollectionViewHeight()
        updateScrollViewContentSize()
    }
    
    private func updateScrollViewContentSize() {
        let collectionViewHeight = calculateCollectionViewHeight()
        let totalHeight = collectionViewHeight + 300 // 다른 요소 높이 합 (적절히 조정)

        scrollView.contentSize = CGSize(width: view.frame.width - 40, height: totalHeight) // width 고정
        print("Updated ScrollView content size: \(scrollView.contentSize)")
    }
    
    private func updateCollectionViewHeight() {
        let newHeight = calculateCollectionViewHeight()
        print("Calculated CollectionView height: \(newHeight)")

        
        scrollableTravelCollectionView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
        scrollableObjectCollectionView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
    }
    
    func calculateCollectionViewHeight() -> CGFloat {
        let itemsPerRow: CGFloat = 3 // 한 줄에 표시할 셀 수
        let itemHeight: CGFloat = 150 // 각 셀의 높이
        let spacing: CGFloat = 16 // 셀 간 간격

        let rowCount = ceil(CGFloat(travelRecords.count) / itemsPerRow)
        return (rowCount * itemHeight) + ((rowCount - 1) * spacing)
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
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.backgroundColor = .white
        label.textColor = .black
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
