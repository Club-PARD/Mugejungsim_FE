import UIKit
import PhotosUI

class StoryEditorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, PHPickerViewControllerDelegate {

    // MARK: - Properties
    var images: [UIImage] = [] // 선택된 이미지 배열
    var texts: [String] = []   // 각 이미지에 대응하는 텍스트 배열
    private var mainImageView: UIImageView!
    private var thumbnailCollectionView: UICollectionView!
    private var textView: UITextView!
    private var categoryContainer: UIView!
    private var contentView: UIView!
    private var currentIndex: Int = 0 // 현재 선택된 이미지 인덱스
    private var characterCountLabel: UILabel!
    private let maxCharacterCount = 100
    private var doneToolbar: UIToolbar!
    private var categoryNumber : String = ""
    // MARK: - 카테고리 관련 Properties
        private var categoryOverlayView: UIView? // Overlay View

    
//    private let scrollView = UIScrollView()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        let plusImageView = UIImageView()
        plusImageView.image = UIImage(named: "plus")
        plusImageView.contentMode = .scaleAspectFit
        plusImageView.translatesAutoresizingMaskIntoConstraints = false

        let countLabel = UILabel()
        countLabel.text = "0/25"
        countLabel.textColor = UIColor.systemGray
        countLabel.font = UIFont.systemFont(ofSize: 8.59)
        countLabel.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [plusImageView, countLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.78
        stackView.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])

        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 3.3
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.systemGray.cgColor

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
        updateImageCountLabels()
        setupUI()

        
        setupToolbar() // 키보드 위 툴바 설정
        setupKeyboardObservers() // 키보드 이벤트 감지 설정
        setupCategoryButtons()
    }
    
    deinit {
        removeKeyboardObservers()
    }

    @objc private func openGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 25
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
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
        setupScrollView()
    }
    
    
    private func setupScrollView() {
        // ScrollView 생성
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)

        // ScrollView ContentView 생성
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // ScrollView와 ContentView의 제약 조건
        NSLayoutConstraint.activate([
            // ScrollView 제약 조건
            scrollView.topAnchor.constraint(equalTo: thumbnailCollectionView.bottomAnchor, constant: 15),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView 제약 조건
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // 가로 스크롤 방지
        ])
        self.contentView = contentView // 스크롤 뷰 안에 카테고리, 텍스트뷰 등을 배치하기 위해 contentView를 사용
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

        textView.inputAccessoryView = doneToolbar
    }

    @objc private func dismissKeyboard() {
        textView.resignFirstResponder()
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
        layout.itemSize = CGSize(width: 62.86, height: 62.86)
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
        categoryContainer = UIView()
        categoryContainer.translatesAutoresizingMaskIntoConstraints = false
        categoryContainer.backgroundColor = UIColor.systemGray6
        categoryContainer.layer.cornerRadius = 10
        contentView.addSubview(categoryContainer)

        let categoryLabel = UILabel()
        categoryLabel.text = "카테고리 선택"
        categoryLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        categoryLabel.textColor = .black
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryContainer.addSubview(categoryLabel)

        NSLayoutConstraint.activate([
            // 카테고리 컨테이너 제약 조건
            categoryContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            categoryContainer.leadingAnchor.constraint(equalTo: addButton.leadingAnchor), // addButton의 leading과 동일하게 설정

            categoryContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // 카테고리 라벨 제약 조건
            categoryLabel.centerYAnchor.constraint(equalTo: categoryContainer.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor)

        ])
    }

    private func setupExpressionField() {
        let expressionLabel = UILabel()
        expressionLabel.text = "글로 표현해보세요!"
        expressionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        expressionLabel.textColor = .black
        expressionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(expressionLabel)

        NSLayoutConstraint.activate([
            // "글로 표현해보세요!"를 categoryButtons 아래에 위치
            expressionLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 114.49),
            expressionLabel.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor),
            expressionLabel.trailingAnchor.constraint(equalTo: categoryContainer.trailingAnchor)

        ])
    }

    private func setupTextInputField() {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.systemGray6
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.systemGray4.cgColor
        view.addSubview(backgroundView)

        textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .black
        textView.text = texts.first ?? ""
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 40) // 오른쪽 여백 추가
        textView.inputAccessoryView = doneToolbar
        backgroundView.addSubview(textView) // textView를 backgroundView에 추가

        characterCountLabel = UILabel()
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.text = "0 / \(maxCharacterCount)"
        characterCountLabel.textColor = .systemGray
        characterCountLabel.font = UIFont.systemFont(ofSize: 15)
        backgroundView.addSubview(characterCountLabel) // characterCountLabel을 backgroundView에 추가

        NSLayoutConstraint.activate([
            // Text Input Background
            backgroundView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 147.98),
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 163),

            // TextView
            textView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -8),

            // Character Count Label
            characterCountLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -23),
            characterCountLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -25)
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
        mainImageView.image = images[currentIndex]
        textView.text = texts[currentIndex]
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
        textView.text = texts[currentIndex]
        updateImageCountLabels()
    }

    func textViewDidChange(_ textView: UITextView) {
        let characterCount = textView.text.count
        characterCountLabel.text = "\(characterCount) / \(maxCharacterCount)"
        characterCountLabel.textColor = characterCount > maxCharacterCount ? .systemRed : .systemGray
        texts[currentIndex] = textView.text ?? "" // 잠시 보류
    }
    
    private func setupCategoryButtons() {
        // ScrollView 생성
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = false // 세로 스크롤 비활성화
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = false // 세로 방향 바운스 비활성화
        scrollView.showsHorizontalScrollIndicator = false // 스크롤바 제거
        view.addSubview(scrollView)

        // StackView 생성
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        // 버튼 데이터
        let buttonTitles = ["문화 · 경험", "AAAAA", "BBBBB", "CCCCC", "DDDDD"] // 필요한 버튼 제목
        for title in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
            button.layer.cornerRadius = 18.5
            button.layer.borderWidth = 1
            button.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.widthAnchor.constraint(equalToConstant: 86).isActive = true
            button.heightAnchor.constraint(equalToConstant: 37).isActive = true
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        // ScrollView와 StackView 제약 조건
        NSLayoutConstraint.activate([
        // ScrollView 제약 조건
            scrollView.topAnchor.constraint(equalTo: categoryContainer.bottomAnchor, constant: 22.5),
            scrollView.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: categoryContainer.trailingAnchor),

        // StackView 제약 조건
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }

    @objc private func categoryButtonTapped(_ sender: UIButton) {
        // 카테고리 버튼 클릭 시 호출
        guard let title = sender.titleLabel?.text else { return }
        let mockData = MockData()
        var categoryIndex: Int?

        // 버튼 타이틀에 따라 인덱스 설정
        switch title {
        case "문화 · 경험": categoryIndex = 0
        case "AAAAA": categoryIndex = 1
        case "BBBBB": categoryIndex = 2
        case "CCCCC": categoryIndex = 3
        case "DDDDD": categoryIndex = 4
        default: return
        }

        guard let index = categoryIndex, let data = mockData.rows[index] else {
            print("데이터 없음")
            return
        }

        if categoryOverlayView == nil {
            categoryOverlayView = createCategoryOverlay(with: data)
            if let overlayView = categoryOverlayView {
                view.addSubview(overlayView)
                NSLayoutConstraint.activate([
                    overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    overlayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                    overlayView.heightAnchor.constraint(equalToConstant: 300)
                ])
                UIView.animate(withDuration: 0.3) {
                    overlayView.alpha = 1.0
                }
            }
        } else {
            hideCategoryOverlay()
        }
    }
    
    private func createCategoryOverlay(with data: [String]) -> UIView {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.white
        overlay.layer.cornerRadius = 15
        overlay.layer.borderWidth = 1
        overlay.layer.borderColor = UIColor.systemGray4.cgColor
        overlay.alpha = 0

        // ScrollView 생성
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        overlay.addSubview(scrollView)

        // StackView 생성
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        // 데이터에 따라 버튼 생성
        for item in data {
            let button = UIButton(type: .system)
            button.setTitle(item, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = UIColor.systemGray6
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray5.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            button.addTarget(self, action: #selector(categoryItemSelected(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

        // ScrollView 및 StackView 제약 조건 설정
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: overlay.topAnchor, constant: 15),
            scrollView.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 15),
            scrollView.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -15),
            scrollView.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -15),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // 가로 스크롤 방지
        ])

        return overlay
    }
    
    @objc private func categoryItemSelected(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        print("선택된 아이템: \(title)")
        hideCategoryOverlay()
    }

    private func hideCategoryOverlay() {
        if let overlayView = categoryOverlayView {
            UIView.animate(withDuration: 0.3, animations: {
                overlayView.alpha = 0
            }) { _ in
                overlayView.removeFromSuperview()
                self.categoryOverlayView = nil
            }
        }
    }
}
