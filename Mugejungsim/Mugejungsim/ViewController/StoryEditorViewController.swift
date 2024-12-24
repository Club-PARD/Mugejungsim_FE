import UIKit

class StoryEditorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    // MARK: - Properties
    var images: [UIImage] = [] // 선택된 이미지 배열
    var texts: [String] = [] // 각 이미지에 대응하는 텍스트 배열
    private var mainImageView: UIImageView!
    private var thumbnailCollectionView: UICollectionView!
    private var textField: UITextField!
    private var currentIndex: Int = 0 // 현재 선택된 이미지 인덱스
    private var originalViewFrame: CGRect? // 키보드 이동을 위한 원래 프레임

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        texts = Array(repeating: "", count: images.count) // 텍스트 배열 초기화
        view.backgroundColor = .white
        setupUI()
        setupKeyboardObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self) // 옵저버 해제
    }

    // MARK: - UI Setup
    private func setupUI() {
        setupMainImageView()
        setupTextInputField()
        setupThumbnailCollectionView()
        setupSaveButton()
    }

    private func setupMainImageView() {
        mainImageView = UIImageView()
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.image = images.first
        view.addSubview(mainImageView)

        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }

    private func setupTextInputField() {
        textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "이미지에 대한 텍스트를 입력하세요."
        textField.text = texts[currentIndex]
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

    private func setupSaveButton() {
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveAndExit))
        navigationItem.rightBarButtonItem = saveButton
    }

    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        if originalViewFrame == nil {
            originalViewFrame = view.frame
        }

        let keyboardHeight = keyboardFrame.height
        let overlap = textField.frame.maxY - (view.frame.height - keyboardHeight)

        if overlap > 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -overlap - 20
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if let originalFrame = originalViewFrame {
            UIView.animate(withDuration: 0.3) {
                self.view.frame = originalFrame
            }
        }
    }

    // MARK: - Actions
    @objc private func updateText(_ textField: UITextField) {
        texts[currentIndex] = textField.text ?? ""
    }

    @objc private func saveAndExit() {
        print("저장된 텍스트: \(texts)") // 저장 로직 추가 가능
        navigationController?.popViewController(animated: true)
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

// MARK: - ThumbnailCell
class ThumbnailCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
