import UIKit

class CollectionPhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var savedData: [PhotoData] = [] // 저장된 사진 데이터
    var collectionView: UICollectionView!
//    var recordID: String = "" // 전달받은 레코드 ID
    var travelRecord: TravelRecord?

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
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
        setupCollectionView()

        if let travelRecord = travelRecord {
            titleLabel.text = travelRecord.title // 레코드 제목을 제목 레이블에 표시
            loadPhotosForRecord(travelRecord: travelRecord) // 사진 로드
        }
//        loadPhotosForRecord()
    }

    private func loadPhotosForRecord(travelRecord: TravelRecord) {
        APIService.shared.getUploadedImages(postId: travelRecord.id) { result in
            DispatchQueue.main.async { // UI 갱신은 메인 스레드에서
                switch result {
                case .success(let images):
                    print("Uploaded Images: \(images)")
                    self.savedData = images // 서버에서 받은 이미지 데이터를 저장
                    self.collectionView.reloadData() // 컬렉션 뷰 갱신
                case .failure(let error):
                    print("Failed to fetch images: \(error.localizedDescription)")
                    // 실패했을 경우 사용자에게 오류 메시지를 알릴 수 있습니다.
                    self.savedData.removeAll() // 실패시 데이터를 초기화
                    self.collectionView.reloadData() // 컬렉션 뷰 갱신
                }
            }
        }
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
        navBar.addSubview(titleLabel)
//        navBar.addSubview(imageCountLabel)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 65),

            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor)
        ])
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 64.59, height: 64.59)
        layout.minimumLineSpacing = 1.01
        layout.minimumInteritemSpacing = 1.01
        layout.sectionInset = UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SavedPhotoCell.self, forCellWithReuseIdentifier: "SavedPhotoCell")
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    @objc private func goBack() {
        dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedPhotoCell", for: indexPath) as! SavedPhotoCell
        let photoData = savedData[indexPath.row]
        print("이미지 경로: \(photoData.imagePath)") // 디버깅: 경로 확인

        cell.configure(with: photoData)
        print("Loaded photos: \(savedData)")
        print("이미지 경로: \(photoData.imagePath)")
        return cell
    }

}

// MARK: CollectionPhotosViewController
extension CollectionPhotosViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = savedData[indexPath.row]

        let detailVC = PhotoDetailViewController()
        detailVC.selectedPhotoData = selectedPhoto // 선택된 데이터 전달
        
        // 모달로 보여주기
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true, completion: nil)
    }
}
