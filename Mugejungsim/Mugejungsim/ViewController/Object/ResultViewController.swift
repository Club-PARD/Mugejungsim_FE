import UIKit

class ResultViewController: UIViewController {

    // MARK: - Properties (UI Elements)
    var recordID: String = "1"

    let memoryLabel: UILabel = {
        let label = UILabel()
        label.text = "OOO 님의 여행 오브제가\n완성되었어요!"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let touchLabel: UILabel = {
        let label = UILabel()
        label.text = "오브제를 터치하고 움직여 보세요!"
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.46, green: 0.45, blue: 0.76, alpha: 1)
        label.font = UIFont(name: "Pretendard-SemiBold", size: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오브제 저장하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let openPreviewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Storybook Brown"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let gradientLayer = CAGradientLayer()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        guard let recordUUID = UUID(uuidString: recordID) else {
            print("유효하지 않은 recordID: \(recordID)")
            return
        }
            
        if let record = TravelRecordManager.shared.getRecord(by: recordID) {
            print("ResultViewController에서 데이터 확인:")
            print("oneLine1: \(record.oneLine1)")
        } else {
            print("recordID에 해당하는 기록을 찾을 수 없습니다.")
        }
        
        // 버튼 액션 연결
        openPreviewButton.addTarget(self, action: #selector(openUSDZPreviewController), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        view.addSubview(memoryLabel)
        view.addSubview(touchLabel)
        view.addSubview(openPreviewButton)
        view.addSubview(saveButton)

        setConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradientLayer()
        setupShadowForSaveButton()
        updateImages()
    }

    // MARK: - Gradient Layer Setup

    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor(red: 0.44, green: 0.43, blue: 0.7, alpha: 1).cgColor,
            UIColor(red: 0.78, green: 0.55, blue: 0.75, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = saveButton.bounds
        gradientLayer.cornerRadius = 8

        if gradientLayer.superlayer == nil {
            saveButton.layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    // MARK: - Shadow Setup

    private func setupShadowForSaveButton() {
        saveButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        saveButton.layer.shadowOpacity = 1
        saveButton.layer.shadowRadius = 6
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    // MARK: - Constraints Setup

    private func setConstraints() {
        NSLayoutConstraint.activate([
            memoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 175),
            memoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            touchLabel.topAnchor.constraint(equalTo: memoryLabel.bottomAnchor, constant: 14),
            touchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            openPreviewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openPreviewButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            openPreviewButton.widthAnchor.constraint(equalToConstant: 200),
            openPreviewButton.heightAnchor.constraint(equalToConstant: 200),

            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Button Action
    @objc func saveButtonTapped() {
        print("성공!")
        let CheckObjeImageVC = CheckObjeImageViewController()
        CheckObjeImageVC.recordID = recordID
        CheckObjeImageVC.modalPresentationStyle = .fullScreen
        self.present(CheckObjeImageVC, animated: true, completion: nil)
    }

    @objc func openUSDZPreviewController() {
        let USDZPreviewVC = USDZPreviewViewController()
        USDZPreviewVC.modalPresentationStyle = .fullScreen
        present(USDZPreviewVC, animated: false, completion: nil)
    }
    
    private func updateImages() {
        // 병 이미지도 여기서 관리하라!
        guard let recordUUID = UUID(uuidString: recordID) else {
            print("유효하지 않은 recordID: \(recordID)")
            return
        }
        var record = TravelRecordManager.shared.getRecord(by: recordID)
        
        // bottle(glass)
        switch record?.oneLine1 {
        case "value1":
            openPreviewButton.setImage(UIImage(named: "Dreamy Pink"), for: .normal)
        case "value2":
            openPreviewButton.setImage(UIImage(named: "Cloud Whisper"), for: .normal)
        case "value3":
            openPreviewButton.setImage(UIImage(named: "Sunburst Yellow"), for: .normal)
        case "value4":
            openPreviewButton.setImage(UIImage(named: "Radiant Orange"), for: .normal)
        case "value5":
            openPreviewButton.setImage(UIImage(named: "Serene Sky"), for: .normal)
        case "value6":
            openPreviewButton.setImage(UIImage(named: "Midnight Depth"), for: .normal)
        case "value7":
            openPreviewButton.setImage(UIImage(named: "Wanderer's Flame"), for: .normal)
        case "value8":
            openPreviewButton.setImage(UIImage(named: "Storybook Brown"), for: .normal)
        case "value9":
            openPreviewButton.setImage(UIImage(named: "Ember Red"), for: .normal)
        case "value10":
            openPreviewButton.setImage(UIImage(named: "Meadow Green"), for: .normal)
        default:
            openPreviewButton.setImage(UIImage(named: "Storybook Brown"), for: .normal)
        }
        
        openPreviewButton.imageView?.contentMode = .scaleAspectFit
        openPreviewButton.imageEdgeInsets = .zero
    }

}
