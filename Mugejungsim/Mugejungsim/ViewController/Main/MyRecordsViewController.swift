import UIKit

class MyRecordsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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

    // 상단 제목 레이블
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "무게중심 님의 여행 기록\n지금까지의 여행을 모아보세요!"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 기록/컬렉션 스위치
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["나의 여행", "나의 오브제"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .white
        control.selectedSegmentTintColor = UIColor(red: 110/255, green: 110/255, blue: 222/255, alpha: 1.0) // #6E6EDE 색상

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]

        control.setTitleTextAttributes(normalAttributes, for: .normal)
        control.setTitleTextAttributes(selectedAttributes, for: .selected)

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
        button.backgroundColor = UIColor(red: 110/255, green: 110/255, blue: 222/255, alpha: 1.0)
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
        setupCollectionView()
    }

    private func setupUI() {
        // UI 요소 추가
        view.addSubview(titleCardView)
        titleCardView.addSubview(titleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(scrollView)
        view.addSubview(floatingButton)

        // ScrollView에 CollectionView 추가
        scrollView.addSubview(scrollableCollectionView)

        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // Title Card View
            titleCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 106),
            titleCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleCardView.heightAnchor.constraint(equalToConstant: 93),

            // Title Label
            titleLabel.centerXAnchor.constraint(equalTo: titleCardView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleCardView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleCardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: titleCardView.trailingAnchor, constant: -16),

            // Segmented Control
            segmentedControl.topAnchor.constraint(equalTo: titleCardView.bottomAnchor, constant: 36),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),

            // ScrollView
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),

            // CollectionView
            scrollableCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollableCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollableCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollableCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollableCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollableCollectionView.heightAnchor.constraint(equalToConstant: 800),

            // Floating Button
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupActions() {
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }

    private func setupCollectionView() {
        scrollableCollectionView.delegate = self
        scrollableCollectionView.dataSource = self
        scrollableCollectionView.register(TravelRecordCell.self, forCellWithReuseIdentifier: "TravelRecordCell")
    }

    // MARK: - Actions
    @objc private func floatingButtonTapped() {
        print("Floating Button Tapped")
    }

    @objc private func segmentedControlChanged() {
        print("Segmented Control Changed")
    }

    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TravelRecordCell", for: indexPath) as! TravelRecordCell
        cell.imageView.image = UIImage(systemName: "photo")
        cell.titleLabel.text = "기록 \(indexPath.row + 1)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 3
        return CGSize(width: width, height: 150)
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
