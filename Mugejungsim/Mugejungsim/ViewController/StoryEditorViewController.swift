import UIKit
import PhotosUI

class StoryEditorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, PHPickerViewControllerDelegate {

    // MARK: - Properties
    var images: [UIImage] = [] // 선택된 이미지 배열
    var texts: [String] = []   // 각 이미지에 대응하는 텍스트 배열
    private var mainImageView: UIImageView!
    private var thumbnailCollectionView: UICollectionView!
    private var textField: UITextField!
    private var categoryContainer: UIView!
    private var currentIndex: Int = 0 // 현재 선택된 이미지 인덱스
    private var characterCountLabel: UILabel!
    private var expressionTextView: UITextView!
    private let maxCharacterCount = 100
    
    private var doneToolbar: UIToolbar!


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
        
        setupToolbar() // 키보드 위 툴바 설정
        setupKeyboardObservers() // 키보드 이벤트 감지 설정
    }
    
    deinit {
            removeKeyboardObservers()
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
        setupCategorySection()
        setupExpressionField()
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
    
    private func setupToolbar() {
            doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
            doneToolbar.barStyle = .default

            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissKeyboard))
            doneToolbar.items = [flexibleSpace, doneButton]
            doneToolbar.sizeToFit()

            textField.inputAccessoryView = doneToolbar
        }

        @objc private func dismissKeyboard() {
            view.endEditing(true)
        }

        private func setupKeyboardObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        private func removeKeyboardObservers() {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        @objc private func keyboardWillShow(_ notification: Notification) {
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardFrame.height / 2
            }
        }

        @objc private func keyboardWillHide(_ notification: Notification) {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = 0
            }
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

    private func setupCategorySection() {
        // 카테고리 섹션 컨테이너
        categoryContainer = UIView()
        categoryContainer.translatesAutoresizingMaskIntoConstraints = false
        categoryContainer.backgroundColor = UIColor.systemGray6 // 배경 색상
        categoryContainer.layer.cornerRadius = 10 // 배경 둥글게 처리
        view.addSubview(categoryContainer)


        // 카테고리 텍스트
        let categoryLabel = UILabel()
        categoryLabel.text = "카테고리 선택"
        categoryLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        categoryLabel.textColor = .black
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryContainer.addSubview(categoryLabel)
        
        // 버튼 뒤 배경 색상 영역 (UIView)
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1) // 배경 색상 설정
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        categoryContainer.addSubview(backgroundView)

        // 버튼
        let categoryButton = UIButton(type: .system)
        categoryButton.setTitle("문화 · 경험", for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1) // 버튼 배경색
        categoryButton.layer.cornerRadius = 18.5 // 버튼 둥글게 처리
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(categoryButton)

        // 제약 조건
        NSLayoutConstraint.activate([
            // 카테고리 컨테이너 위치 및 크기
            categoryContainer.topAnchor.constraint(equalTo: thumbnailCollectionView.bottomAnchor, constant: 29.01),
            categoryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            categoryContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            // 카테고리 라벨 위치
            categoryLabel.centerYAnchor.constraint(equalTo: categoryContainer.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor),
            
            
            // 배경 뷰 위치 및 크기
            backgroundView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 15),
            backgroundView.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            backgroundView.heightAnchor.constraint(equalToConstant: 37), // 원하는 배경 높이

            // 버튼 위치
            categoryButton.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 15),
            categoryButton.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor),
            categoryButton.widthAnchor.constraint(equalToConstant: 86),
            categoryButton.heightAnchor.constraint(equalToConstant: 37)
        ])
    }
    
    private func setupExpressionField() {
        // "글로 표현해보세요!" 라벨
        let expressionLabel = UILabel()
        expressionLabel.text = "글로 표현해보세요!"
        expressionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        expressionLabel.textColor = .black
        expressionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(expressionLabel)

        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // "글로 표현해보세요!" 라벨
            expressionLabel.topAnchor.constraint(equalTo: categoryContainer.bottomAnchor, constant: 81),
            expressionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            expressionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }

    private func setupTextInputField() {
        // 텍스트 필드 뒤 배경
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.systemGray6
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.systemGray4.cgColor
        view.addSubview(backgroundView)

        // 텍스트 필드
        textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = ""
        textField.text = texts.first ?? ""
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(updateText(_:)), for: .editingChanged)
        view.addSubview(textField)

        // 문자 수 라벨
        characterCountLabel = UILabel()
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.text = "0 / \(maxCharacterCount)"
        characterCountLabel.textColor = .systemGray
        characterCountLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(characterCountLabel)

        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 배경 뷰
            backgroundView.topAnchor.constraint(equalTo: categoryContainer.bottomAnchor, constant: 114.49),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            backgroundView.heightAnchor.constraint(equalToConstant: 163.51),

            // 텍스트 필드
            textField.topAnchor.constraint(equalTo: categoryContainer.topAnchor, constant: 136),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -49),
            textField.heightAnchor.constraint(equalToConstant: 18),

            // 문자 수 라벨
            characterCountLabel.topAnchor.constraint(equalTo: categoryContainer.topAnchor, constant: 237),
            characterCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -49)
        ])
    }

    @objc private func updateText(_ textField: UITextField) {
        let characterCount = textField.text?.count ?? 0
        characterCountLabel.text = "\(characterCount) / \(maxCharacterCount)"
        characterCountLabel.textColor = characterCount > maxCharacterCount ? .systemRed : .systemGray
        texts[currentIndex] = textField.text ?? ""
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
        mainImageView.image = images[currentIndex]
        textField.text = texts[currentIndex]
        updateImageCountLabels()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCell
        cell.imageView.image = images[indexPath.item]
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
        return cell
    }

    @objc private func deleteImage(_ sender: UIButton) {
        guard images.count > 1 else {
            let alert = UIAlertController(title: "삭제 불가", message: "최소 1장의 사진은 남아있어야 합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let index = sender.tag
        guard index >= 0 && index < images.count else { return }

        images.remove(at: index)
        texts.remove(at: index)
        if currentIndex == index {
            currentIndex = max(0, currentIndex - 1)
        }

        thumbnailCollectionView.reloadData()
        mainImageView.image = images[currentIndex]
        textField.text = texts[currentIndex]
        updateImageCountLabels()
    }
}

extension StoryEditorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = textView.text.count
        characterCountLabel.text = "\(characterCount) / \(maxCharacterCount)"
        characterCountLabel.textColor = characterCount > maxCharacterCount ? .systemRed : .systemGray
    }
}

