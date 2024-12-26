import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행 기록 제목"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요"
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = .lightGray
        textField.layer.cornerRadius = 8
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startDateStackView: UIStackView = {
        let yearField = UITextField()
        yearField.placeholder = "년"
        yearField.font = .systemFont(ofSize: 14)
        yearField.backgroundColor = .lightGray
        yearField.layer.cornerRadius = 8
        yearField.textAlignment = .center
        
        let monthField = UITextField()
        monthField.placeholder = "월"
        monthField.font = .systemFont(ofSize: 14)
        monthField.backgroundColor = .lightGray
        monthField.layer.cornerRadius = 8
        monthField.textAlignment = .center
        
        let dayField = UITextField()
        dayField.placeholder = "일"
        dayField.font = .systemFont(ofSize: 14)
        dayField.backgroundColor = .lightGray
        dayField.layer.cornerRadius = 8
        dayField.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [yearField, monthField, dayField])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let endDateStackView: UIStackView = {
        let yearField = UITextField()
        yearField.placeholder = "년"
        yearField.font = .systemFont(ofSize: 14)
        yearField.backgroundColor = .lightGray
        yearField.layer.cornerRadius = 8
        yearField.textAlignment = .center
        
        let monthField = UITextField()
        monthField.placeholder = "월"
        monthField.font = .systemFont(ofSize: 14)
        monthField.backgroundColor = .lightGray
        monthField.layer.cornerRadius = 8
        monthField.textAlignment = .center
        
        let dayField = UITextField()
        dayField.placeholder = "일"
        dayField.font = .systemFont(ofSize: 14)
        dayField.backgroundColor = .lightGray
        dayField.layer.cornerRadius = 8
        dayField.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [yearField, monthField, dayField])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "여행지 입력"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "여행지를 입력하세요"
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = .lightGray
        textField.layer.cornerRadius = 8
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nextButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("다음", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 25
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
            return button
        }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupUI()
            addDoneButtonToAllInputs()
            setupNavigationBar()
            setTextFieldDelegates()
        }
    
    // 텍스트 필드의 delegate 설정
        private func setTextFieldDelegates() {
            let allTextFields = [titleTextField] +
                startDateStackView.arrangedSubviews.compactMap { $0 as? UITextField } +
                endDateStackView.arrangedSubviews.compactMap { $0 as? UITextField } +
                [locationTextField]
            
            for textField in allTextFields {
                textField.delegate = self
            }
        }
    
    // UITextFieldDelegate 메서드
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // 모든 텍스트 필드 배열 생성
            let allTextFields = [titleTextField] +
                startDateStackView.arrangedSubviews.compactMap { $0 as? UITextField } +
                endDateStackView.arrangedSubviews.compactMap { $0 as? UITextField } +
                [locationTextField]
            
            // 현재 텍스트 필드의 인덱스를 확인
            if let currentIndex = allTextFields.firstIndex(of: textField) {
                let nextIndex = currentIndex + 1
                
                // 다음 텍스트 필드가 있으면 포커스를 이동
                if nextIndex < allTextFields.count {
                    allTextFields[nextIndex].becomeFirstResponder()
                } else {
                    // 마지막 텍스트 필드라면 키보드 닫기
                    textField.resignFirstResponder()
                }
            }
            return true
        }
    
    // MARK: - Add Done Button to Inputs
    func addDoneButtonToAllInputs() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        let allInputs = [titleTextField] + startDateStackView.arrangedSubviews.compactMap { $0 as? UITextField } + endDateStackView.arrangedSubviews.compactMap { $0 as? UITextField } + [locationTextField]
        for input in allInputs {
            input.inputAccessoryView = toolbar
        }
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    // MARK: - Setup Navigation Bar
    func setupNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        let navigationItem = UINavigationItem()
        
        let backButton = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backTapped))
        let saveButton = UIBarButtonItem(title: "임시저장", style: .plain, target: self, action: #selector(saveTapped))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveButton
        
        navigationBar.items = [navigationItem]
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func backTapped() {
        let stopWritingVC = StopWritingViewController()
        stopWritingVC.modalTransitionStyle = .crossDissolve
        stopWritingVC.modalPresentationStyle = .overFullScreen
        self.present(stopWritingVC, animated: true, completion: nil)
    }
    
    @objc func saveTapped() {
        print("임시저장 버튼 클릭됨")
    }
    
    // MARK: - Actions
        @objc func nextButtonTapped() {
            // Check if the title is filled
            guard let titleText = titleTextField.text, !titleText.isEmpty else {
                showAlert(message: "여행 기록 제목을 입력하세요.")
                return
            }

            // Check if the start date fields are filled
            let startDateFields = startDateStackView.arrangedSubviews.compactMap { $0 as? UITextField }
            guard startDateFields.allSatisfy({ !$0.text!.isEmpty }) else {
                showAlert(message: "시작 날짜를 모두 입력하세요.")
                return
            }

            // Check if the end date fields are filled
            let endDateFields = endDateStackView.arrangedSubviews.compactMap { $0 as? UITextField }
            guard endDateFields.allSatisfy({ !$0.text!.isEmpty }) else {
                showAlert(message: "종료 날짜를 모두 입력하세요.")
                return
            }

            // Check if the location is filled
            guard let locationText = locationTextField.text, !locationText.isEmpty else {
                showAlert(message: "여행지를 입력하세요.")
                return
            }

            let uploadViewController = UploadViewController()
                uploadViewController.modalPresentationStyle = .fullScreen // 전체 화면 표시
                uploadViewController.modalTransitionStyle = .crossDissolve // 전환 애니메이션
                present(uploadViewController, animated: true, completion: nil)
        }
    
    // Helper method to show alert
        func showAlert(message: String) {
            let alertController = UIAlertController(title: "입력 필요", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(startDateStackView)
        view.addSubview(endDateStackView)
        view.addSubview(locationLabel)
        view.addSubview(locationTextField)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            startDateStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            startDateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startDateStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            endDateStackView.topAnchor.constraint(equalTo: startDateStackView.bottomAnchor, constant: 16),
            endDateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            endDateStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            locationLabel.topAnchor.constraint(equalTo: endDateStackView.bottomAnchor, constant: 24),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            locationTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            locationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            locationTextField.heightAnchor.constraint(equalToConstant: 40),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
