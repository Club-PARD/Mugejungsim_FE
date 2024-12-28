import UIKit

class ObjectModalViewController: UIViewController {
    // MARK: - UI Elements

    private let overlayView: UIView = { // 배경
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    private let containerView: UIView = { // 모달 창 컨테이너
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let scrollView: UIScrollView = { // 스크롤 뷰
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = { // 스크롤 내용 컨테이너
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = { // 제목 레이블
        let label = UILabel()
        label.text = "OOO님의 여행 기록"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = { // 설명 레이블
        let label = UILabel()
        label.text = "당신의 여행 컬러는\n“비바 마젠타 입니다”"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bottleImageView: UIImageView = { // 유리병 이미지
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginlogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let closeButton: UIButton = { // 닫기 버튼
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let contentImageView: UIImageView = { // 전체 콘텐츠 이미지
        let imageView = UIImageView()
        imageView.image = UIImage(named: "green") // 여기에 표시할 이미지 이름
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    // MARK: - UI Setup

//    private func setupUI() {
//        view.addSubview(overlayView)
//        view.addSubview(containerView)
//        
//        containerView.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        
//        contentView.addSubview(closeButton)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(descriptionLabel)
//        contentView.addSubview(bottleImageView)
//        contentView.addSubview(contentImageView)
//    }
    // overlayView 제거
    private func setupUI() {
        view.addSubview(overlayView)
        view.addSubview(containerView)
        containerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(bottleImageView)
        contentView.addSubview(contentImageView)
    }

    // MARK: - Constraints
    

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Overlay View
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Container View
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 327),
            containerView.heightAnchor.constraint(equalToConstant: 600),

            // Scroll View
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Close Button
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            // Bottle Image View
            bottleImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            bottleImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bottleImageView.widthAnchor.constraint(equalToConstant: 127), // 고정된 너비 설정
            bottleImageView.heightAnchor.constraint(equalToConstant: 127), // 고정된 높이 설정

            // Content Image View
            contentImageView.topAnchor.constraint(equalTo: bottleImageView.bottomAnchor, constant: 10), // 공백을 줄임
            contentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15), // 좌측 여백
            contentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15), // 우측 여백
            contentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            contentImageView.heightAnchor.constraint(equalToConstant: 600) // 이미지 높이
        ])
    }


    // MARK: - Actions

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil) // 모달을 닫는 애니메이션 (기본 제공)
    }
}
