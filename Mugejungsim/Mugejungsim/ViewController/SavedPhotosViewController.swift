import UIKit

class SavedPhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var savedData: [PhotoData] = []
    var collectionView: UICollectionView!
    
    private var imageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 25"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        // 현재 저장된 사진 수 / 25로 설정
        let currentCount = savedData.count
        imageCountLabel.text = "\(currentCount)/25"
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
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 101),
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
        navigationController?.popViewController(animated: true)
    }
}
