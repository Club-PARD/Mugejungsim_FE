import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate {
    
    var startDateYear: String?
    var startDateMonth: String?
    var startDateDay: String?
    var endDateYear: String?
    var endDateMonth: String?
    var endDateDay: String?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행기 제목"
        label.font =  UIFont(name: "Pretendard-ExtraBold", size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요"
        textField.font = UIFont(name: "Pretendard-Regular", size: 16)
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
    
    let startDateStackView = CreateViewController.createDateStackView(title: "시작일자")
    let endDateStackView = CreateViewController.createDateStackView(title: "종료일자")
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "여행 장소"
        label.font =  UIFont(name: "Pretendard-ExtraBold", size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "여행지를 입력하세요"
        textField.font = UIFont(name: "Pretendard-Regular", size: 16)
        textField.borderStyle = .none
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
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureTextFieldDelegates(in: startDateStackView)
        configureTextFieldDelegates(in: endDateStackView)
        titleTextField.delegate = self
        locationTextField.delegate = self
        
        setupCustomNavigationBar()
        setupUI()
        setupCompanionButtons()
        setupObservers()
        
    }
    
    private func setupCustomNavigationBar() {
        let navBar = UIView()
        navBar.backgroundColor = .clear
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()  // center 고정
        titleLabel.text = "여행 기록 쓰기"
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let backButton = UIButton(type: .system)  // 왼쪽 고정
        backButton.setImage(UIImage(named: "back_button"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        let saveButton = UIButton(type: .system) // 오른쪽 고정
        saveButton.setTitle("임시저장", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        saveButton.setTitleColor(UIColor(red: 0.824, green: 0.824, blue: 0.824, alpha: 1), for: .normal)
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(navBar)
        navBar.addSubview(separator)
        navBar.addSubview(titleLabel)
        navBar.addSubview(backButton)
        navBar.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 40),
            
            separator.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 24),
            separator.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -24),
            separator.heightAnchor.constraint(equalToConstant: 0.3),
            
            titleLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 24),
            
            saveButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func didTapBackButton() {
        print("backButton 누름")
        let stopWritingVC = StopWritingViewController()
        stopWritingVC.modalTransitionStyle = .crossDissolve
        stopWritingVC.modalPresentationStyle = .overFullScreen
        self.present(stopWritingVC, animated: true, completion: nil)
    }
    
    @objc private func didTapSaveButton() {
        print("SaveButton 누름")
        // 저장 기능 필요
        // 이것에 대한 구체적인 논의 필요
        //
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
        view.addSubview(companionLabel)
        view.addSubview(nextButton)
        
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
            
            locationUnderline.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 2),
            locationUnderline.leadingAnchor.constraint(equalTo: locationTextField.leadingAnchor),
            locationUnderline.trailingAnchor.constraint(equalTo: locationTextField.trailingAnchor),
            locationUnderline.heightAnchor.constraint(equalToConstant: 1),
            
            companionLabel.topAnchor.constraint(equalTo: locationUnderline.bottomAnchor, constant: 24),
            companionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
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
        fieldsStack.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8) // 패딩 적용
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
                
                // 키보드 액세서리 추가
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
                
                let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
                            
                let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                toolbar.setItems([flexibleSpace, doneButton], animated: false)
                            
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
    
    @objc func nextButtonTapped() {
        let title = titleTextField.text ?? "없음"
        let companion = selectedCompanion?.title(for: .normal) ?? "없음"
        let startDate = "\(startDateYear ?? "0000")-\(startDateMonth ?? "00")-\(startDateDay ?? "00")"
        let endDate = "\(endDateYear ?? "0000")-\(endDateMonth ?? "00")-\(endDateDay ?? "00")"
        let location = locationTextField.text ?? "없음"
        
        print("제목: \(title)")
        print("누구와: \(companion)")
        print("시작일자: \(startDate)")
        print("종료일자: \(endDate)")
        print("장소: \(location)")
        
        let uploadViewController = UploadViewController()
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
