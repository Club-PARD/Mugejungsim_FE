import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 색상 설정
        view.backgroundColor = UIColor.white
        
        // 로고 이미지 추가
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "moments")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        // 로고와 텍스트 레이아웃 설정
        NSLayoutConstraint.activate([
            // 로고 배치
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 220),
            logoImageView.heightAnchor.constraint(equalToConstant: 220),
        ])
        
        // 2초 후 메인 화면으로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // let mainVC = MainViewController()
            // let mainVC = LoginViewController()
           let mainVC = ObjeCreationViewController()
//            let mainVC = LoadingViewController()
//            let mainVC = ResultViewController()
//            let mainVC = UploadViewController()
//            let mainVC = MyRecordsViewController()
//            let mainVC = CreateViewController()
            mainVC.modalTransitionStyle = .crossDissolve
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: true, completion: nil)
        }
    }
}
