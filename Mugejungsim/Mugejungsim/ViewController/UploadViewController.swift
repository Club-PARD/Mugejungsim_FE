import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행의 순간이 담긴\n사진을 업로드 해보세요!"
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
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    private func setupUI() {
        // UI 요소 추가
        view.addSubview(titleLabel)
        view.addSubview(galleryButton)
        view.addSubview(galleryLabel)
        view.addSubview(cameraButton)
        view.addSubview(cameraLabel)
        view.addSubview(saveButton)
        view.addSubview(separator)
        
        // 레이아웃 설정
        NSLayoutConstraint.activate([
            // 제목 라벨 위치
            titleLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 57),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // 갤러리 업로드 버튼 위치
            galleryButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            galleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            galleryButton.widthAnchor.constraint(equalToConstant: 133),
            galleryButton.heightAnchor.constraint(equalToConstant: 122),
            
            // 갤러리 업로드 라벨 위치
            galleryLabel.topAnchor.constraint(equalTo: galleryButton.bottomAnchor, constant: 10),
            galleryLabel.centerXAnchor.constraint(equalTo: galleryButton.centerXAnchor),
            
            // 카메라 촬영 버튼 위치
            cameraButton.topAnchor.constraint(equalTo: galleryLabel.bottomAnchor, constant: 89),
            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraButton.widthAnchor.constraint(equalTo: galleryButton.widthAnchor),
            cameraButton.heightAnchor.constraint(equalTo: galleryButton.heightAnchor),
            
            // 카메라 촬영 라벨 위치
            cameraLabel.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 10),
            cameraLabel.centerXAnchor.constraint(equalTo: cameraButton.centerXAnchor),
            
            // 임시 저장 버튼 위치
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 52),
            saveButton.heightAnchor.constraint(equalToConstant: 23),
            
            // 구분선 위치 (임시 저장 아래)
            separator.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc func openGallery() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showAlert(title: "갤러리 오류", message: "이 기기에서 갤러리를 사용할 수 없습니다.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "카메라 오류", message: "이 기기에서 카메라를 사용할 수 없습니다.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            let storyEditorVC = StoryEditorViewController()
            storyEditorVC.images = [selectedImage]
            navigationController?.pushViewController(storyEditorVC, animated: true)
        } else {
            showAlert(title: "이미지 오류", message: "이미지를 불러올 수 없습니다.")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
