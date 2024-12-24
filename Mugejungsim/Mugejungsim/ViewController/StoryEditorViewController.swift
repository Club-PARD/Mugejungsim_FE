import UIKit

class StoryEditorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    // MARK: - Properties
    var images: [UIImage] = [] // 선택된 이미지 배열
    var texts: [String] = [] // 각 이미지에 대응하는 텍스트 배열
    private var mainImageView: UIImageView!
    private var thumbnailCollectionView: UICollectionView!
    private var textField: UITextField!
    private var currentIndex: Int = 0 // 현재 선택된 이미지 인덱스

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveAndExit), for: .touchUpInside) // saveAndExit 연결
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        texts = Array(repeating: "", count: images.count) // 텍스트 배열 초기화
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
    }

    deinit {
        NotificationCenter.default.removeObserver(self) // 옵저버 해제
    }

    // MARK: - UI Setup
    private func setupUI() {
        setupSeparator()
        setupMainImageView()
        setupTextInputField()
        setupThumbnailCollectionView()
        setupBackAndSaveButtons()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Story Editor"
    }

    private func setupMainImageView() {
        mainImageView = UIImageView()
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.image = images.first ?? UIImage() // 배열이 비어있을 경우 대비
        view.addSubview(mainImageView)

        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            mainImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }

    private func setupTextInputField() {
        textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter text for this image"
        textField.text = texts.first ?? ""
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(updateText(_:)), for: .editingChanged)
        view.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupThumbnailCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumLineSpacing = 10

        thumbnailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
        thumbnailCollectionView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailCollectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: "ThumbnailCell")
        thumbnailCollectionView.backgroundColor = .white
        view.addSubview(thumbnailCollectionView)

        NSLayoutConstraint.activate([
            thumbnailCollectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            thumbnailCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            thumbnailCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            thumbnailCollectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupSeparator() {
        view.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupBackAndSaveButtons() {
        view.addSubview(backButton)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Actions
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveTemporarily() {
        print("Temporary save complete!")
    }

    @objc private func updateText(_ textField: UITextField) {
        texts[currentIndex] = textField.text ?? ""
    }

    @objc private func saveAndExit() {
        var photoDataList: [PhotoData] = []
        for (index, image) in images.enumerated() {
            if let imagePath = DataManager.shared.saveImage(image) {
                let photoData = PhotoData(imagePath: imagePath, text: texts[index])
                photoDataList.append(photoData)
            }
        }
        DataManager.shared.addNewData(photoData: photoDataList)

        // 이동
        let savedPhotosVC = SavedPhotosViewController()
        navigationController?.pushViewController(savedPhotosVC, animated: true)
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
        mainImageView.image = images[currentIndex]
        textField.text = texts[currentIndex]
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
