import UIKit
import PhotosUI

class UploadViewController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행의 순간이 담긴\n사진을 업로드 해보세요!"
        label.textColor = .black
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let galleryLabel: UILabel = {
        let label = UILabel()
        label.text = "갤러리 업로드"
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cameraLabel: UILabel = {
        let label = UILabel()
        label.text = "카메라 촬영"
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("임시저장", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "out"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(galleryButton)
        view.addSubview(galleryLabel)
        view.addSubview(cameraButton)
        view.addSubview(cameraLabel)
        view.addSubview(saveButton)
        view.addSubview(backButton)
        view.addSubview(separator)
        
        NSLayoutConstraint.activate([
            // 뒤로가기 버튼 위치
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            // 임시저장 버튼 위치
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            saveButton.widthAnchor.constraint(equalToConstant: 52),
            saveButton.heightAnchor.constraint(equalToConstant: 23),
            
            // 구분선 위치
            separator.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            // 제목 라벨 위치
            titleLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 57),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // 카메라 촬영 버튼 위치
            cameraButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraButton.widthAnchor.constraint(equalToConstant: 133),
            cameraButton.heightAnchor.constraint(equalToConstant: 122),
            
            // 카메라 촬영 라벨 위치
            cameraLabel.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 10),
            cameraLabel.centerXAnchor.constraint(equalTo: cameraButton.centerXAnchor),
            
            // 갤러리 업로드 버튼 위치
            galleryButton.topAnchor.constraint(equalTo: cameraLabel.bottomAnchor, constant: 79),
            galleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            galleryButton.widthAnchor.constraint(equalTo: cameraButton.widthAnchor),
            galleryButton.heightAnchor.constraint(equalTo: cameraButton.heightAnchor),
            
            // 갤러리 업로드 라벨 위치
            galleryLabel.topAnchor.constraint(equalTo: galleryButton.bottomAnchor, constant: 10),
            galleryLabel.centerXAnchor.constraint(equalTo: galleryButton.centerXAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "사진 업로드"
    }
    
    @objc private func goBack() {
        if let navigationController = navigationController {
            // 네비게이션 컨트롤러를 사용하는 경우
            navigationController.popViewController(animated: true)
        } else {
            // 모달로 표시된 경우
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func openGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 25 // 최대 선택 가능 이미지 수
        config.filter = .images // 이미지만 필터링

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "카메라 오류", message: "이 기기에서 카메라를 사용할 수 없습니다.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc func nextButtonTapped() {
        let uploadViewController = UploadViewController()
        navigationController?.pushViewController(uploadViewController, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true) // 피커 종료
        var selectedImages: [UIImage] = [] // 선택한 이미지 저장

        // 선택한 이미지를 로드
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            selectedImages.append(image)
                            if selectedImages.count == results.count {
                                // 모든 이미지를 로드한 후 StoryEditorViewController로 이동
                                self?.navigateToStoryEditor(with: selectedImages)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func showPhotoEditor(with images: [UIImage]) {
        guard !images.isEmpty else {
            print("No images selected!")
            return
        }
    }
    
    // StoryEditorViewController로 이동하는 메서드
    private func navigateToStoryEditor(with images: [UIImage]) {
        let storyEditorVC = StoryEditorViewController()
        storyEditorVC.images = images // 선택된 이미지 전달
        storyEditorVC.modalPresentationStyle = .fullScreen // 전체 화면으로 표시
        present(storyEditorVC, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
