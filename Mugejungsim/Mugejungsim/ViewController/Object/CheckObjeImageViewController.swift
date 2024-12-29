import UIKit

class CheckObjeImageViewController: UIViewController {
    
    // MARK: - UI Elements
    var recordID: String = ""
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "유리병 편지에 담긴 나만의 여행\n추억 컬러를 확인해보세요!"
        label.numberOfLines = 2
        label.textColor = UIColor(red: 0.46, green: 0.45, blue: 0.76, alpha: 1)
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let readButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("편지 읽기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = false // 그림자가 잘리지 않도록 false로 설정
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0.46, green: 0.45, blue: 0.76, alpha: 1)
        // 그림자 설정
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4 // 더 강하게 강조
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // UI 요소 추가
        view.addSubview(textLabel)
        view.addSubview(readButton)
        
        // 버튼 액션 연결
        readButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        setConstraints()
        
        guard let recordUUID = UUID(uuidString: recordID) else {
            print("유효하지 않은 recordID: \(recordID)")
            return
        }
            
        if let record = TravelRecordManager.shared.getRecord(by: recordUUID) {
            print("CheckObjeImageViewController에서 데이터 확인:")
            print("Record ID: \(record.id)")
            print("Title: \(record.title)")
            print("oneLine1: \(record.oneLine1)")
            print("oneLine2: \(record.oneLine2)")
        } else {
            print("recordID에 해당하는 기록을 찾을 수 없습니다.")
        }
        
    }
    
    // MARK: - Constraints Setup
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // textLabel 위치
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // readButton 위치
            readButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            readButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Button Actions
    @objc func saveButtonTapped() {
        print("성공!")
        let ShareVC = ShareViewController()
        ShareVC.recordID = recordID
        ShareVC.modalPresentationStyle = .fullScreen
        self.present(ShareVC, animated: true, completion: nil)
    }
}
