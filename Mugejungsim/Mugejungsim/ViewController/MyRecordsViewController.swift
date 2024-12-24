import UIKit

class MyRecordsViewController: UIViewController {
    
    // 상단 제목 레이블
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "OOO 님의 여행 기록\n지금까지의 여행을 모아보세요!"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 기록/컬렉션 스위치
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["기록", "컬렉션"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .lightGray
        control.selectedSegmentTintColor = .systemPink
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    // 기록 리스트를 표시할 CollectionView
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
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
        button.backgroundColor = .systemPink
        button.setTitle("＋", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // UI 요소 추가
        view.addSubview(titleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        view.addSubview(floatingButton)
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    private func setupActions() {
        // 핑크 버튼 클릭 이벤트
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
    }
    
    @objc private func floatingButtonTapped() {
        // 팝업 메뉴 표시
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addAction = UIAlertAction(title: "여행 추가", style: .default) { _ in
            self.navigateToCreateViewController()
        }
        
        let sortAction = UIAlertAction(title: "여행 정렬", style: .default) { _ in
            print("여행 정렬 선택됨")
        }
        
        let deleteAction = UIAlertAction(title: "여행 삭제", style: .destructive) { _ in
            print("여행 삭제 선택됨")
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(sortAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func navigateToCreateViewController() {
        let createViewController = CreateViewController()
        createViewController.modalPresentationStyle = .fullScreen
        present(createViewController, animated: true, completion: nil)
    }
}
