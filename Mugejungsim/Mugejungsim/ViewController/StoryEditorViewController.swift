import UIKit
import PhotosUI

class StoryEditorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, PHPickerViewControllerDelegate {

    // MARK: - Properties
    var images: [UIImage] = [] // 선택된 이미지 배열
    var texts: [String] = []   // 각 이미지에 대응하는 텍스트 배열
    private var mainImageView: UIImageView!
    private var thumbnailCollectionView: UICollectionView!
    private var textField: UITextField!
    private var currentIndex: Int = 0 // 현재 선택된 이미지 인덱스

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        // "+" 이미지
        let plusImageView = UIImageView()
        plusImageView.image = UIImage(named: "plus")
        plusImageView.contentMode = .scaleAspectFit
        plusImageView.translatesAutoresizingMaskIntoConstraints = false

        // 숫자 Label
        let countLabel = UILabel()
        countLabel.text = "0/25"
        countLabel.textColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        countLabel.font = UIFont.systemFont(ofSize: 8.59)
        countLabel.textAlignment = .center

        // StackView 설정
        let stackView = UIStackView(arrangedSubviews: [plusImageView, countLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.78 // "+"와 숫자 간 간격 설정
        stackView.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(stackView)

        // StackView 제약 조건 설정
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])

        // 버튼 스타일 설정
        button.backgroundColor =   #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // 버튼 배경색 설정
        button.layer.cornerRadius = 3.3
        button.layer.borderWidth = 1.0 // 테두리 두께 설정
        button.layer.borderColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1) // 테두리 색상 설정

        return button
    }()

    private let imageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/25"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        texts = Array(repeating: "", count: images.count)
        view.backgroundColor = .white

        addButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)

        setupCustomNavigationBar()
        setupUI()
        updateImageCountLabels()
    }

    @objc private func openGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 25 // 최대 선택 가능 이미지 수
        config.filter = .images // 이미지만 필터링

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self // Delegate 설정
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        var selectedImages: [UIImage] = []
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            selectedImages.append(image)
                            if selectedImages.count == results.count {
                                self?.addSelectedImages(selectedImages)
                            }
                        }
                    }
                }
            }
        }
    }

    private func addSelectedImages(_ newImages: [UIImage]) {
        images.append(contentsOf: newImages)
        texts.append(contentsOf: Array(repeating: "", count: newImages.count))
        updateImageCountLabels()
        thumbnailCollectionView.reloadData()
    }

    private func setupUI() {
        setupMainImageView()
        setupThumbnailSection()
        setupTextInputField()
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

        let saveButton = UIButton(type: .system)
        saveButton.setTitle("임시저장", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        saveButton.setTitleColor(UIColor.lightGray, for: .normal)
        saveButton.addTarget(self, action: #selector(saveTemporarily), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(navBar)
        navBar.addSubview(backButton)
        navBar.addSubview(saveButton)
        navBar.addSubview(imageCountLabel)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 40),

            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 24),

            saveButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -24),

            imageCountLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            imageCountLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor)
        ])
    }

    private func setupMainImageView() {
        mainImageView = UIImageView()
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.backgroundColor = .clear
        mainImageView.layer.borderWidth = 0
        mainImageView.layer.borderColor = UIColor.clear.cgColor
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.image = images.first ?? UIImage()
        view.addSubview(mainImageView)

        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            mainImageView.widthAnchor.constraint(equalToConstant: 327),
            mainImageView.heightAnchor.constraint(equalToConstant: 263)
        ])
    }

    private func setupThumbnailSection() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 62.86, height: 62.86) // Thumbnail 크기 설정
        layout.minimumLineSpacing = 11.45

        thumbnailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
        thumbnailCollectionView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailCollectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: "ThumbnailCell")
        thumbnailCollectionView.backgroundColor = .white
        containerView.addSubview(thumbnailCollectionView)

        containerView.addSubview(addButton)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 14.12),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            containerView.heightAnchor.constraint(equalToConstant: 70),

            addButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            addButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 62.86),
            addButton.heightAnchor.constraint(equalToConstant: 62.86),

            thumbnailCollectionView.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 11.45),
            thumbnailCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            thumbnailCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            thumbnailCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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
            textField.topAnchor.constraint(equalTo: thumbnailCollectionView.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func updateImageCountLabels() {
        imageCountLabel.text = "\(currentIndex + 1) / \(images.count > 0 ? images.count : 25)"
        if let stackView = addButton.subviews.first as? UIStackView,
           let countLabel = stackView.arrangedSubviews.last as? UILabel {
            countLabel.text = "\(images.count) / 25"
        }
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveTemporarily() {
        print("임시 저장 버튼 클릭")
    }

    @objc private func updateText(_ textField: UITextField) {
        texts[currentIndex] = textField.text ?? ""
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 현재 선택된 인덱스 업데이트
        currentIndex = indexPath.item

        // 메인 이미지와 텍스트 필드 업데이트
        mainImageView.image = images[currentIndex]
        textField.text = texts[currentIndex]
        updateImageCountLabels()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCell

        // 이미지 설정
        cell.imageView.image = images[indexPath.item]

        // 삭제 버튼 설정
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)

        return cell
    }

    @objc private func deleteImage(_ sender: UIButton) {
        // Ensure at least one image remains
        guard images.count > 1 else {
            let alert = UIAlertController(title: "삭제 불가", message: "최소 1장의 사진은 남아있어야 합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let index = sender.tag
        guard index >= 0 && index < images.count else { return }

        // Remove image and text at the specified index
        images.remove(at: index)
        texts.remove(at: index)

        // Update the current index if the deleted image was selected
        if currentIndex == index {
            currentIndex = max(0, currentIndex - 1)
        }

        // Reload collection view and update main image and text field
        thumbnailCollectionView.reloadData()
        mainImageView.image = images[currentIndex]
        textField.text = texts[currentIndex]
        updateImageCountLabels()
    }
}
