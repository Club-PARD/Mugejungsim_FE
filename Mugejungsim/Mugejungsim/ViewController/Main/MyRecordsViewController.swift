import UIKit

class MyRecordsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var travelRecords: [TravelRecord] = [] // 여행 기록 데이터
    private var recordCount: Int = 0
    private var objectCount: Int = 0
        
    private let logoImageView0: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "person") // 로고 이미지 파일 필요
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 245/255, alpha: 1.0).cgColor // d2d2f5 색상
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false // 그림자가 레이어를 넘어서 보이도록 설정
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
        label1.text = "\(LoginViewController.name) 님의 여행 기록"
        label1.font = UIFont(name: "Pretendard-Bold", size: 22)
        label1.textColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        label1.numberOfLines = 1
        label1.textAlignment = .center
        label1.translatesAutoresizingMaskIntoConstraints = false
        return label1
    }()
    
    let subLabel: UILabel = {
        let label2 = UILabel()
        label2.text = "여행의 추억을 유리병 편지에 담아보세요!"
        label2.font = UIFont(name: "Pretendard-Medium", size: 15)
        label2.textColor = #colorLiteral(red: 0.4588235294, green: 0.4509803922, blue: 0.7647058824, alpha: 1)
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
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 1.95, height: 1.95)
        view.layer.shadowRadius = 2.6
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
//        control.addTarget(self, action: #selector(updateSegmentedControlCorners), for: .valueChanged)
        return control
    }()
    
    @objc private func updateSegmentedControlCorners() {
        for subview in segmentedControl.subviews {
            subview.clipsToBounds = true
        }
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceHorizontal = false
        return scrollView
    }()
    
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
        view.isHidden = true
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
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupActions()
        setupCollectionView()
        setupContextMenu()
        
        loadTravelRecords() // 데이터셋 로드
        updateCollectionViewHeight()
        updateScrollViewContentSize()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadTravelRecords()
//        segmentedControlChanged()
//    }
    
    private func createMenuButton(title: String, iconName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(" \(title)", for: .normal) // 텍스트와 아이콘 사이 간격을 위한 공백 추가
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        
        let iconImage = UIImage(named: iconName)
        button.setImage(iconImage, for: .normal)
        
        button.tintColor = .black
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return button
    }
    
    private func setupContextMenu() {
        view.addSubview(contextMenuContainer)
        
        let addButton = createMenuButton(title: "여행 추가", iconName: "image-add")
        let deleteButton = createMenuButton(title: "여행 삭제", iconName: "trash")
        
        addButton.addTarget(self, action: #selector(addTripTapped), for: .touchUpInside)
        
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 110/255, green: 110/255, blue: 222/255, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
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
        createViewController.modalPresentationStyle = .fullScreen
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
//        view.addSubview(myPageButton)
        view.addSubview(logoImageView0)

        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            logoImageView.widthAnchor.constraint(equalToConstant: 134),
            logoImageView.heightAnchor.constraint(equalToConstant: 25),
            
            // Title Card View
            titleCardView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 23),
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
//            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainer.leadingAnchor),
//            segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlContainer.trailingAnchor),
//            segmentedControl.topAnchor.constraint(equalTo: segmentedControlContainer.topAnchor),
//            segmentedControl.bottomAnchor.constraint(equalTo: segmentedControlContainer.bottomAnchor),
//            
            // My Page Button
//            myPageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//            myPageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            myPageButton.widthAnchor.constraint(equalToConstant: 50),
//            myPageButton.heightAnchor.constraint(equalToConstant: 50),
            // segmentedControl
            segmentedControl.centerXAnchor.constraint(equalTo: segmentedControlContainer.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedControlContainer.centerYAnchor, constant: -0.5),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainer.leadingAnchor, constant: 0.5), // 좌측 여백
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlContainer.trailingAnchor, constant: -0.5), // 우측 여백
            segmentedControl.heightAnchor.constraint(equalToConstant: 38),
            
            // logoImageView0
            logoImageView0.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            logoImageView0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: segmentedControlContainer.bottomAnchor, constant: 33),
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
            subLabel.text = "여행의 추억을 유리병 편지에 담아보세요!"
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
            subLabel.text = "여행의 색이 담긴 유리병 편지를 읽어보세요!"
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
            print("T count: \(recordCount)")
            return recordCount
        } else if collectionView == scrollableObjectCollectionView {
            print("O count: \(objectCount)")
            return objectCount

        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TravelRecordCell", for: indexPath) as! TravelRecordCell
        var record: TravelRecord
        if collectionView == scrollableTravelCollectionView {
            record = travelRecords[indexPath.row] // 여행 기록 데이터
        } else if collectionView == scrollableObjectCollectionView {
            let filteredRecords = travelRecords.filter { $0.bottle != "" }
            record = filteredRecords[indexPath.row] // 오브제 데이터
        } else {
            return UICollectionViewCell() // 기본적으로 빈 셀을 리턴
        }
        
        if collectionView == scrollableTravelCollectionView {
            switch record.bottle {
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
                cell.imageView.image = UIImage(named: "한줄남기기X") // 기본 이미지
            }
            cell.titleLabel.text = record.title // 여행 기록 제목
            print("Cell \(indexPath.row): \(record)")
        } else if collectionView == scrollableObjectCollectionView {
            switch record.bottle {
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
                cell.imageView.image = UIImage(named: "Storybook Brown")
            }
            cell.titleLabel.text = record.title // 오브제 이름
            print("OBJ Cell \(indexPath.row): \(record)")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
            if selectedRecord.bottle == "" {
                let ObjeCreateVC = ObjeCreationViewController()
                ObjeCreateVC.travelRecord = selectedRecord
                ObjeCreateVC.modalPresentationStyle = .fullScreen
                present(ObjeCreateVC, animated: true, completion: nil)
            }
            let collectionPhotosVC = CollectionPhotosViewController()
            collectionPhotosVC.travelRecord = selectedRecord // 선택된 여행 기록 전달
            collectionPhotosVC.modalPresentationStyle = .fullScreen
            present(collectionPhotosVC, animated: true, completion: nil)
        } else if collectionView == scrollableObjectCollectionView {
            let filteredRecords = travelRecords.filter { $0.bottle != "" }
            let selectedRecord = filteredRecords[indexPath.row]
            print("오브제 셀 클릭됨: \(indexPath.row), 선택된 레코드 ID: \(selectedRecord.id)")
            let objectModalVC = ObjectModal()
            objectModalVC.travelRecord = selectedRecord
            objectModalVC.modalPresentationStyle = .fullScreen
            present(objectModalVC, animated: false, completion: nil)
        }
    }
    
    private func loadTravelRecords() {
        // API 호출
        APIService.shared.getUserPosts(userId: TravelRecordManager.shared.userId!) { [weak self] result in
            switch result {
            case .success(let records):
                // 서버에서 받은 데이터 업데이트
                let updatedRecords: [TravelRecord] = records.compactMap { record in
                    let uuid: Int
                    if let idString = record.id as? String, let generatedUUID = Int(idString) {
                        uuid = generatedUUID
                    } else {
                        uuid = Int() // ID가 유효하지 않을 경우 새 UUID 생성
                        print("Created new UUID for invalid record ID: \(record.id)")
                    }
                    return TravelRecord(
                        id: record.id,
                        pid: "",
                        title: record.title,
                        startDate: record.startDate,
                        endDate: record.endDate,
                        location: record.location,
                        companion: record.companion,
                        bottle: record.bottle,
                        stories: record.stories,
                        oneLine1: record.bottle,
                        oneLine2: ""
                    )
                    print("\(record.id)")
                    print("\(record.bottle)")
                    print("\(record.title)")
                }
                DispatchQueue.main.async {
                    self?.travelRecords = updatedRecords
                    self?.recordCount = updatedRecords.count
                    self?.objectCount = updatedRecords.filter { $0.bottle != "" }.count
                    self?.scrollableTravelCollectionView.reloadData()
                    self?.updateCollectionViewHeight() // 높이 업데이트
                    self?.updateScrollViewContentSize()
                    print("불러온 여행 기록 개수: \(updatedRecords.count)")
                    print("recordCount: \(self?.recordCount ?? 0), objectCount: \(self?.objectCount ?? 0)")
                }
            case .failure(let error):
                print("여행 기록을 불러오는 중 오류 발생: \(error.localizedDescription)")
            }
        }
    }

    private func reloadTravelRecords() {
        loadTravelRecords()
        scrollableTravelCollectionView.reloadData()
        updateCollectionViewHeight()
        updateScrollViewContentSize()
    }
    
    private func updateScrollViewContentSize() {
        let collectionViewHeight = calculateCollectionViewHeight()
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

    // 셀 재사용 전에 초기화
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = nil
    }
}
