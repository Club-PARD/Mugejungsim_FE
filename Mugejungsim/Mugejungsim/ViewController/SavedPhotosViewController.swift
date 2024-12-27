import UIKit

class SavedPhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var savedData: [PhotoData] = []
    var collectionView: UICollectionView!
    
    private var imageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 25"
        label.textColor = .black
        
        label.font = UIFont(name: "Pretendard-Medium", size: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("한 줄 남기기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
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
    
    let saveAndHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장하고 홈으로 돌아가기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = false // 그림자가 잘리지 않도록 false로 설정
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "#F4F5FB")
        // 그림자 설정
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4 // 더 강하게 강조
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 내비게이션 바 설정
        setupCustomNavigationBar()
        
        // 데이터 로드
        savedData = DataManager.shared.loadData()
        
        // 이미지 개수 레이블 업데이트
        updateImageCountLabel()
        
        // 컬렉션 뷰 설정
        setupCollectionView()
        
        view.addSubview(lineButton)
        view.addSubview(saveAndHomeButton)
        
        lineButton.addTarget(self, action: #selector(lineButtonTapped), for: .touchUpInside)
        saveAndHomeButton.addTarget(self, action: #selector(saveAndHomeButtonTapped), for: .touchUpInside)
        
        setupButtonsConstraints()
    }
    
    
    func setupButtonsConstraints() {
        NSLayoutConstraint.activate([
            lineButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            lineButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lineButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lineButton.heightAnchor.constraint(equalToConstant: 50),
            
            saveAndHomeButton.bottomAnchor.constraint(equalTo: lineButton.topAnchor, constant: -10),
            saveAndHomeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveAndHomeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveAndHomeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCustomNavigationBar() {
        let navBar = UIView()
        navBar.backgroundColor = .clear
        navBar.translatesAutoresizingMaskIntoConstraints = false
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "out"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navBar)
        navBar.addSubview(backButton)
        navBar.addSubview(imageCountLabel)
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 40),
            
            
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 24),
            
            imageCountLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            imageCountLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor)
        ])
    }
    
    // MARK: - Update Image Count Label
    private func updateImageCountLabel() {
        // 현재 저장된 사진 수 / 25로 설정애0
        let currentCount = savedData.count
        
        imageCountLabel.text = "\(currentCount) / 25"
    }
    
    // MARK: - Collection View Setup
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
            
        // Cell 크기 설정 (64.59)
        layout.itemSize = CGSize(width: 64.59, height: 64.59)
            
        // Cell 간격 설정 (1.01)
        layout.minimumLineSpacing = 1.01 // 줄 간격
        layout.minimumInteritemSpacing = 1.01 // 열 간격
            
        // Section Insets 설정 (좌우 여백)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
            
        // CollectionView 생성
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SavedPhotoCell.self, forCellWithReuseIdentifier: "SavedPhotoCell")
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
            
        // CollectionView 제약조건 설정
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
        
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedData.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedPhotoCell", for: indexPath) as! SavedPhotoCell
        let data = savedData[indexPath.row]
        cell.configure(with: data) // Display only the photo
        return cell
    }
        
    @objc private func goBack() {
        //        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
        
    // MARK: - Button Actions
    
    @objc func lineButtonTapped() {
        print("Line Button Tapped!")
        // 저장하고 한 줄 넘기기 페이지로 이동
        let OCVC = ObjeCreationViewController() // 이동할 ViewController 인스턴스 생성
        OCVC.modalTransitionStyle = .crossDissolve
        OCVC.modalPresentationStyle = .fullScreen
        self.present(OCVC, animated: true, completion: nil)
        print("OCVC로 이동 성공")
    }
        
        @objc func saveAndHomeButtonTapped() {
            print("Save and Home Button Tapped!")
            
            // 네비게이션 컨트롤러 확인
            guard let navigationController = self.navigationController else {
                print("NavigationController가 없습니다. 네비게이션 스택에 추가 후 다시 시도하세요.")
                
                // 네비게이션 컨트롤러가 없을 경우 루트 뷰 컨트롤러 변경
                let mainViewController = MainViewController()
                let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                window?.rootViewController = UINavigationController(rootViewController: mainViewController)
                window?.makeKeyAndVisible()
                return
            }
            
            // MainViewController로 이동
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                navigationController.setViewControllers([mainViewController], animated: true)
            } else {
                print("MainViewController를 초기화할 수 없습니다. 스토리보드 ID를 확인하세요.")
            }
        }
    }

