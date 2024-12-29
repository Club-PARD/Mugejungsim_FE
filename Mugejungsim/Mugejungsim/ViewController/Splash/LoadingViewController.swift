import UIKit

class LoadingViewController: UIViewController {
    
    var recordID : String = ""
    // "오브제 만드는 중" 라벨
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "나만의 오브제를\n만드는 중이에요!"
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 로딩 중 이미지
    private let loadingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "moments"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        startLoading()
    }
    
    // UI 설정
    private func setupUI() {
        view.addSubview(loadingLabel)
        view.addSubview(loadingImageView)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // 로딩 라벨 위치 (이미지 위)
            loadingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 175),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loadingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            loadingImageView.widthAnchor.constraint(equalToConstant: 175),
            loadingImageView.heightAnchor.constraint(equalToConstant: 175),

        ])
    }
    
    // 로딩 시작
    private func startLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.goToNextPage()
        }
    }
    
    // 다음 화면으로 이동
    private func goToNextPage() {
        // 다음 화면 이동 코드
        let resultVC = ResultViewController()
        resultVC.recordID = recordID
        resultVC.modalTransitionStyle = .crossDissolve // 오픈 모션
        resultVC.modalPresentationStyle = .fullScreen
        self.present(resultVC, animated: true, completion: nil)
        print("recordID: \(recordID)")
        print("ResultVC로 이동 성공")
    }
}
