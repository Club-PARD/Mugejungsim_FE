import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate {
    private let maxTitleLength = 10

    var startDateYear: String?
    var startDateMonth: String?
    var startDateDay: String?
    var endDateYear: String?
    var endDateMonth: String?
    var endDateDay: String?
    
    // Local Flow 위한 변수
    var travelRecordID: String = ""
    var travelTitle: String = ""
    var companion: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var location: String = ""
    
    let startDateStackView = CreateViewController.createDateStackView(title: "시작일자")
    let endDateStackView = CreateViewController.createDateStackView(title: "종료일자")
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행기 제목"
        label.font =  UIFont(name: "Pretendard-ExtraBold", size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let titleCount: UILabel = {
            let label = UILabel()
            label.text = "0 / 10"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .gray
            return label
        }()
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요"
        textField.font = UIFont(name: "Pretendard-Regular", size: 16)
        textField.borderStyle = .none
        textField.tintColor = UIColor(red: 0.431, green: 0.431, blue: 0.871, alpha: 1) // 6E6EDE
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    let saveButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("임시저장", for: .normal)
            button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
            button.setTitleColor(UIColor(red: 0.824, green: 0.824, blue: 0.824, alpha: 1), for: .normal)
            button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    let titleUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "여행 일자"
        label.font =  UIFont(name: "Pretendard-ExtraBold", size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    @objc private func didTapSaveButton() {
        print("SaveButton 누름")
        
        // SaveDraftModal 모달을 present
        let saveDraftModal = SaveDraftModal()
        saveDraftModal.modalPresentationStyle = .overFullScreen // 전체 화면 모달로 띄움
        present(saveDraftModal, animated: true, completion: nil)
    }

    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "여행 장소"
        label.font =  UIFont(name: "Pretendard-ExtraBold", size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let locationCount: UILabel = {
        let label = UILabel()
        label.text = "0 / 10"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "여행지를 입력하세요"
        textField.font = UIFont(name: "Pretendard-Regular", size: 16)
        textField.borderStyle = .none
        textField.tintColor = UIColor(red: 0.431, green: 0.431, blue: 0.871, alpha: 1) // 6E6EDE
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let locationUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let companionLabel: UILabel = {
        let label = UILabel()
        label.text = "누구와"
        label.font =  UIFont(name: "Pretendard-ExtraBold", size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var companionButtons: [UIButton] = []
    var selectedCompanion: UIButton?
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        if let customFont = UIFont(name: "Pretendard-Regular", size: 15) {
            button.titleLabel?.font = customFont
        }
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    let clearButton1: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal) // X 버튼 아이콘 설정
        button.tintColor = .lightGray // 버튼 색상 설정
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearTextField), for: .touchUpInside) // X 버튼 클릭 시 동작
        return button
    }()
    let clearButton2: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal) // X 버튼 아이콘 설정
        button.tintColor = .lightGray // 버튼 색상 설정
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearTextField), for: .touchUpInside) // X 버튼 클릭 시 동작
        return button
    }()
    
    // MARK: - View Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        view.addSubview(titleCount)
//        configureTextFieldDelegates(in: startDateStackView)
//        configureTextFieldDelegates(in: endDateStackView)
//
//        titleTextField.delegate = self
//        locationTextField.delegate = self
//
//        setupCustomNavigationBar()
//        setupUI()
//        setupCompanionButtons()
//        setupObservers()
//
//        titleCount.translatesAutoresizingMaskIntoConstraints = false
//        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
//        titleTextField.delegate = self
//        locationTextField.delegate = self
//
//        titleCount.translatesAutoresizingMaskIntoConstraints = false
//
//
//    }
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            view.addSubview(titleCount)
            configureTextFieldDelegates(in: startDateStackView)
            configureTextFieldDelegates(in: endDateStackView)
            
            titleTextField.delegate = self
            locationTextField.delegate = self
            
            setupCustomNavigationBar()
            setupUI()
            setupCompanionButtons()
            setupObservers()

            titleCount.translatesAutoresizingMaskIntoConstraints = false
            titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
            titleTextField.delegate = self
            locationTextField.delegate = self
            
            titleCount.translatesAutoresizingMaskIntoConstraints = false
        }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
            let textCount = textField.text?.count ?? 0
            if textCount > maxTitleLength {
                textField.text = String(textField.text?.prefix(maxTitleLength) ?? "")
            }
            titleCount.text = "\(textField.text?.count ?? 0) / \(maxTitleLength)"
            
            // "임시저장" 버튼 글씨 색 변경
            if let text = textField.text, !text.isEmpty {
                saveButton.setTitleColor(.black, for: .normal)  // 글씨 색을 검정색으로 변경
            } else {
                saveButton.setTitleColor(UIColor(red: 0.824, green: 0.824, blue: 0.824, alpha: 1), for: .normal)  // 글씨 색을 회색으로 변경
            }
        }
    
    private func setupCustomNavigationBar() {
        let navBar = UIView()
        navBar.backgroundColor = .clear
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "여행 기록 쓰기"
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back_button"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add navBar and its subviews
        view.addSubview(navBar)
        navBar.addSubview(separator)
        navBar.addSubview(titleLabel)
        navBar.addSubview(backButton)
        navBar.addSubview(saveButton)
        
        // Add `titleCount` to the same view hierarchy as `titleTextField`
        view.addSubview(titleCount)
        view.addSubview(titleTextField)

        // Setup constraints
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 48),
            
            separator.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 24),
            separator.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -24),
            separator.heightAnchor.constraint(equalToConstant: 0.3),
            
            titleLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 24),
            
            saveButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -24),
                 
        ])
    }
    
    @objc private func clearTextField() {
        titleTextField.text = "" // titleTextField의 텍스트를 비움
        locationTextField.text = "" // locationTextField의 텍스트를 비움
        titleCount.text = "0 / 10" // titleTextField에 텍스트가 비었으므로 카운트를 초기화
        locationCount.text = "0 / 10" // locationTextField에 텍스트가 비었으므로 카운트를 초기화
        validateInputs() // 유효성 검사 다시 실행
    }
    
    @objc private func didTapBackButton() {
        let stopWritingVC = StopWritingViewController()
        stopWritingVC.modalPresentationStyle = .overFullScreen
        stopWritingVC.delegate = self // Delegate 설정
        present(stopWritingVC, animated: false, completion: nil) // 애니메이션 제거
    }
    
    

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(titleUnderline)
        view.addSubview(dateLabel)
        view.addSubview(startDateStackView)
        view.addSubview(endDateStackView)
        view.addSubview(locationLabel)
        view.addSubview(locationTextField)
        view.addSubview(locationUnderline)
        view.addSubview(locationCount)
        view.addSubview(companionLabel)
        view.addSubview(nextButton)
        view.addSubview(clearButton1) // X 버튼을 추가
        clearButton1.widthAnchor.constraint(equalToConstant: 20).isActive = true
        clearButton1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.addSubview(saveButton)  // saveButton 추가

        view.addSubview(clearButton2) // X 버튼을 추가
        clearButton2.widthAnchor.constraint(equalToConstant: 20).isActive = true
        clearButton2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleCount.translatesAutoresizingMaskIntoConstraints = false

        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)

        // titleLabel과 titleTextField가 동일한 부모 뷰에 속하도록 constraint 수정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            titleUnderline.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 2),
            titleUnderline.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            titleUnderline.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            titleUnderline.heightAnchor.constraint(equalToConstant: 1),
            
            clearButton1.topAnchor.constraint(equalTo: titleTextField.topAnchor, constant: 16), // X 버튼을 텍스트 필드 중앙에 배치
            clearButton1.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor), // 텍스트 필드의 오른쪽에 배치
            
            titleCount.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5),
            titleCount.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleUnderline.bottomAnchor, constant: 24),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            startDateStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            startDateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            startDateStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            
            endDateStackView.topAnchor.constraint(equalTo: startDateStackView.bottomAnchor, constant: 16),
            endDateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            endDateStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            
            locationLabel.topAnchor.constraint(equalTo: endDateStackView.bottomAnchor, constant: 24),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            locationTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            locationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            locationTextField.heightAnchor.constraint(equalToConstant: 40),
            
            clearButton2.topAnchor.constraint(equalTo: locationTextField.topAnchor, constant: 16), // X 버튼을 텍스트 필드 중앙에 배치
            clearButton2.trailingAnchor.constraint(equalTo: locationTextField.trailingAnchor), // 텍스트 필드의 오른쪽에 배치
          
            locationUnderline.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 2),
            locationUnderline.leadingAnchor.constraint(equalTo: locationTextField.leadingAnchor),
            locationUnderline.trailingAnchor.constraint(equalTo: locationTextField.trailingAnchor),
            locationUnderline.heightAnchor.constraint(equalToConstant: 1),
            
            locationCount.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 5),
            locationCount.trailingAnchor.constraint(equalTo: locationTextField.trailingAnchor),
            
            companionLabel.topAnchor.constraint(equalTo: locationUnderline.bottomAnchor, constant: 24),
            companionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.topAnchor.constraint(equalTo: titleUnderline.bottomAnchor, constant: -125),  // 적절한 위치 설정
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 19),
            saveButton.widthAnchor.constraint(equalToConstant: 49),
                 
        ])
    }

    
    private func setupCompanionButtons() {
        let options = ["혼자", "가족과", "친구와", "연인과", "기타"]
        var previousButton: UIButton?
        
        for (index, option) in options.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 18.5
            button.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(companionButtonTapped(_:)), for: .touchUpInside)
            companionButtons.append(button)
            view.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 76),
                button.heightAnchor.constraint(equalToConstant: 37)
            ])
            
            if index < 4 {
                if previousButton == nil {
                    button.topAnchor.constraint(equalTo: companionLabel.bottomAnchor, constant: 14).isActive = true
                    button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
                } else {
                    button.topAnchor.constraint(equalTo: previousButton!.topAnchor).isActive = true
                    button.leadingAnchor.constraint(equalTo: previousButton!.trailingAnchor, constant: 8).isActive = true
                }
            } else {
                if index == 4 {
                    button.topAnchor.constraint(equalTo: companionButtons[0].bottomAnchor, constant: 8).isActive = true
                    button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
                } else {
                    button.topAnchor.constraint(equalTo: companionButtons[4].topAnchor).isActive = true
                    button.leadingAnchor.constraint(equalTo: companionButtons[index - 1].trailingAnchor, constant: 8).isActive = true
                }
            }
            
            previousButton = button
        }
    }
    
    @objc func companionButtonTapped(_ sender: UIButton) {
        if selectedCompanion == sender {
            sender.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
            sender.setTitleColor(.black, for: .normal)
            selectedCompanion = nil
        } else {
            companionButtons.forEach {
                $0.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
                $0.setTitleColor(.black, for: .normal)
            }
            sender.backgroundColor = UIColor(red: 0.459, green: 0.451, blue: 0.765, alpha: 1)
            sender.setTitleColor(.white, for: .normal)
            selectedCompanion = sender
        }
        validateInputs()
    }
    
    static func createDateStackView(title: String) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1)
        
        let yearField = CreateViewController.createDateField(placeholder: "YYYY")
        yearField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yearField.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        let yearLabel = UILabel()
        yearLabel.text = "년"
        yearLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        yearLabel.textColor = .black
        
        let yearStack = UIStackView(arrangedSubviews: [yearField, yearLabel])
        yearStack.axis = .horizontal
        yearStack.spacing = 4
        yearStack.alignment = .center
        
        let monthField = CreateViewController.createDateField(placeholder: "MM")
        monthField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthField.widthAnchor.constraint(equalToConstant: 43)
        ])
        let monthLabel = UILabel()
        monthLabel.text = "월"
        monthLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        monthLabel.textColor = .black
        
        let monthStack = UIStackView(arrangedSubviews: [monthField, monthLabel])
        monthStack.axis = .horizontal
        monthStack.spacing = 4
        monthStack.alignment = .center
        
        let dayField = CreateViewController.createDateField(placeholder: "DD")
        dayField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayField.widthAnchor.constraint(equalToConstant: 43)
        ])
        let dayLabel = UILabel()
        dayLabel.text = "일"
        dayLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        dayLabel.textColor = .black
        
        let dayStack = UIStackView(arrangedSubviews: [dayField, dayLabel])
        dayStack.axis = .horizontal
        dayStack.spacing = 4
        dayStack.alignment = .center
        
        let fieldsStack = UIStackView(arrangedSubviews: [yearStack, monthStack, dayStack])
        fieldsStack.axis = .horizontal
        fieldsStack.spacing = 8
        fieldsStack.isLayoutMarginsRelativeArrangement = true
        fieldsStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8) // 패딩 적용
        fieldsStack.distribution = .equalSpacing
        fieldsStack.alignment = .center
        
        let stack = UIStackView(arrangedSubviews: [label, fieldsStack])
        stack.axis = .vertical
        stack.spacing = 13
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }
    
    static func createDateField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont(name: "Pretendard-Regular", size: 20)
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        
        let underline = UIView()
        underline.backgroundColor = .lightGray
        underline.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(underline)
        
        underline.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        underline.trailingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
        underline.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 2).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return textField
    }
    
    func setupObservers() {
        [titleTextField, locationTextField].forEach {
            $0.addTarget(self, action: #selector(validateInputs), for: .editingChanged)
        }
    }
    
    /// `모든 텍스트 안에 delegate 설정
    private func configureTextFieldDelegates(in stackView: UIStackView) {
        for subview in stackView.arrangedSubviews {
            if let innerStackView = subview as? UIStackView {
                configureTextFieldDelegates(in: innerStackView)
            } else if let textField = subview as? UITextField {
                textField.delegate = self
                textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
                
                // 키보드 완료 버튼 추가
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
                let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
                let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                toolbar.setItems([flexibleSpace, doneButton], animated: false)
                // 모든 키보드
                titleTextField.inputAccessoryView = toolbar
                locationTextField.inputAccessoryView = toolbar
                textField.inputAccessoryView = toolbar
            }
        }
    }
   


    @objc private func doneButtonTapped() {
        view.endEditing(true) // 키보드 닫기
    }

    private func getAllTextFields() -> [UITextField] {
        var allTextFields: [UITextField] = []
        allTextFields.append(titleTextField)
        collectTextFields(from: startDateStackView, into: &allTextFields)
        collectTextFields(from: endDateStackView, into: &allTextFields)
        allTextFields.append(locationTextField)
        return allTextFields
    }
    
    // date text가 입력되는지 확인하는 디버깅 function
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let placeholder = textField.placeholder else { return }
        
        // textField가 특정 stackView의 자손인지 확인
        func isTextFieldInViewHierarchy(_ textField: UITextField, parentView: UIView) -> Bool {
            var currentView: UIView? = textField
            while let superview = currentView?.superview {
                if superview == parentView {
                    return true
                }
                currentView = superview
            }
            return false
        }
        switch placeholder {
        case "YYYY":
            if isTextFieldInViewHierarchy(textField, parentView: startDateStackView) {
                startDateYear = text
            } else if isTextFieldInViewHierarchy(textField, parentView: endDateStackView) {
                endDateYear = text
            }
        case "MM":
            if isTextFieldInViewHierarchy(textField, parentView: startDateStackView) {
                startDateMonth = text
            } else if isTextFieldInViewHierarchy(textField, parentView: endDateStackView) {
                endDateMonth = text
            }
        case "DD":
            if isTextFieldInViewHierarchy(textField, parentView: startDateStackView) {
                startDateDay = text
            } else if isTextFieldInViewHierarchy(textField, parentView: endDateStackView) {
                endDateDay = text
            }
        default: break
        }
        
        print("시작일자: \(startDateYear ?? "없음")-\(startDateMonth ?? "없음")-\(startDateDay ?? "없음")")
        print("종료일자: \(endDateYear ?? "없음")-\(endDateMonth ?? "없음")-\(endDateDay ?? "없음")")
        
        // 유효성 검사 실행
        validateInputs()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 모든 텍스트 필드 순서대로 배열화
        var allTextFields: [UITextField] = []
        
        // 텍스트 필드 탐색
        allTextFields.append(titleTextField)
        collectTextFields(from: startDateStackView, into: &allTextFields)
        collectTextFields(from: endDateStackView, into: &allTextFields)
        allTextFields.append(locationTextField)
        
        // 현재 텍스트 필드의 인덱스를 찾고 다음 텍스트 필드로 이동
        if let currentIndex = allTextFields.firstIndex(of: textField) {
            if currentIndex < allTextFields.count - 1 {
                let nextTextField = allTextFields[currentIndex + 1]
                nextTextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    /// `UIStackView` 안의 모든 텍스트 필드를 탐색하여 배열에 추가
    private func collectTextFields(from stackView: UIStackView, into textFields: inout [UITextField]) {
        for subview in stackView.arrangedSubviews {
            if let innerStackView = subview as? UIStackView {
                collectTextFields(from: innerStackView, into: &textFields)
            } else if let textField = subview as? UITextField {
                textFields.append(textField)
            }
        }
    }
    /// Validate Check Function
    @objc func validateInputs() {
        let isTitleFilled = !(titleTextField.text?.isEmpty ?? true)
        let isLocationFilled = !(locationTextField.text?.isEmpty ?? true)
        let isCompanionSelected = selectedCompanion != nil
        let isStartDateValid = isValidDate(year: startDateYear ?? "0000", month: startDateMonth ?? "00", day: startDateDay ?? "00")
        let isEndDateValid = isValidDate(year: endDateYear ?? "0000", month: endDateMonth ?? "00", day: endDateDay ?? "00")
            
        let isAllValid = isTitleFilled && isLocationFilled && isCompanionSelected && isStartDateValid && isEndDateValid
        
        nextButton.isEnabled = isAllValid
        nextButton.backgroundColor = isAllValid ? UIColor(red: 0.459, green: 0.451, blue: 0.765, alpha: 1) : UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        nextButton.setTitleColor(isAllValid ? .white : .black, for: .normal)
    }
    
    private func isValidDateField(_ text: String, type: String) -> Bool {
        switch type {
        case "YYYY":
            return text.count == 4 && Int(text) != nil
        case "MM":
            if let month = Int(text) {
                return month >= 1 && month <= 12
            }
            return false
        case "DD":
            if let day = Int(text) {
                return day >= 1 && day <= 31
            }
            return false
        default:
            return false
        }
    }
    
    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트
        guard let currentText = textField.text else { return true }
        
        // 변경될 텍스트
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 입력 중 상태 확인 (한국어 조합 등)
        if let markedTextRange = textField.markedTextRange {
            // 조합 중인 텍스트는 허용
            if textField.position(from: markedTextRange.start, offset: 0) != nil {
                return true
            }
        }
        // 삭제 동작 처리 (replacementString이 빈 문자열이면 삭제)
        if string.isEmpty { return true }
        
        // 길이 제한 및 유효성 검사
        switch textField.placeholder {
        case "YYYY":
            return updatedText.count <= 4 // 최대 4자
        case "MM":
            if updatedText.count <= 2, let month = Int(updatedText), month >= 1 && month <= 12 {
                return true
            }
            return false // 잘못된 입력
        case "DD":
            if updatedText.count <= 2, let day = Int(updatedText), day >= 1 && day <= 31 {
                return true
            }
            return false // 잘못된 입력
        default:
            return true // 제한 없음
        }
    }
    
    @objc func nextButtonTapped() {
        travelTitle = titleTextField.text ?? "없음"
        companion = selectedCompanion?.title(for: .normal) ?? "없음"
        startDate = "\(startDateYear ?? "0000")-\(startDateMonth ?? "00")-\(startDateDay ?? "00")"
        endDate = "\(endDateYear ?? "0000")-\(endDateMonth ?? "00")-\(endDateDay ?? "00")"
        location = locationTextField.text ?? "없음"
        
        print("제목: \(travelTitle)")
        print("누구와: \(companion)")
        print("시작일자: \(startDate)")
        print("종료일자: \(endDate)")
        print("장소: \(location)")
        
        let newRecord = TravelRecord(
            title: travelTitle,
            description: "\(companion) | \(startDate) ~ \(endDate)",
            date: startDate,
            location: location,
            oneLine1: "",
            oneLine2: ""
        )
        
        // 기록 추가
        TravelRecordManager.shared.addRecord(newRecord)
        // 데이터 저장
        var records = DataManager.shared.loadTravelRecords()
        records.append(newRecord)
        DataManager.shared.saveTravelRecords(records)
                
        // 저장된 기록 출력
        print("여행 기록이 저장되었습니다.")
        print("저장된 기록: \(newRecord)")
        print("기록 ID: \(newRecord.id)")
        
        let uploadViewController = UploadViewController()
        uploadViewController.recordID = newRecord.id.uuidString //
        uploadViewController.modalPresentationStyle = .fullScreen // 전체 화면 표시
        uploadViewController.modalTransitionStyle = .crossDissolve // 전환 애니메이션
        present(uploadViewController, animated: true, completion: nil)
    }
    
    private func isValidDate(year: String, month: String, day: String) -> Bool {
        guard let yearInt = Int(year), yearInt >= 1000, yearInt <= 9999 else { return false }
        guard let monthInt = Int(month), monthInt >= 1, monthInt <= 12 else { return false }
        guard let dayInt = Int(day), dayInt >= 1 else { return false }
        let daysInMonth: [Int: Int] = [
            1: 31, 2: (yearInt % 4 == 0 && (yearInt % 100 != 0 || yearInt % 400 == 0)) ? 29 : 28,
            3: 31, 4: 30, 5: 31, 6: 30,
            7: 31, 8: 31, 9: 30, 10: 31,
            11: 30, 12: 31
        ]
        return dayInt <= (daysInMonth[monthInt] ?? 0)
    }
    
}

extension CreateViewController: StopWritingViewControllerDelegate {
    func didStopWriting() {
        // MainViewController로 이동
        if let window = UIApplication.shared.windows.first {
            let mainVC = CreateViewController()
            let navController = UINavigationController(rootViewController: mainVC)
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}

