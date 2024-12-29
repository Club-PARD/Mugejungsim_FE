//
//  ShareViewController.swift
//  Mugejungsim
//
//  Created by KIM JIWON on 12/28/24.
//

import UIKit

class ShareViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let ButtontContentView = UIView()
    
    private let mode : String = ""
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "당신의 여행 컬러는\n\"바바 마젠타입니다.\""
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let glassImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "moments")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    private let letterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "yellow")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    private let homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("홈으로 돌아가기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.setTitleColor(.white, for: .normal) // 폰트 색상을 흰색으로 설정
        button.backgroundColor = UIColor(red: 0.46, green: 0.45, blue: 0.76, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: 8).cgPath
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(contentLabel)
        contentView.addSubview(glassImage)
        contentView.addSubview(letterImage)
        contentView.addSubview(homeButton)
        
        setupConstraints()
        setupCustomNavigationBar()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            glassImage.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 20),
            glassImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            glassImage.widthAnchor.constraint(equalToConstant: 200),
            glassImage.heightAnchor.constraint(equalToConstant: 200),

            letterImage.topAnchor.constraint(equalTo: glassImage.bottomAnchor, constant: 20),
            letterImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            letterImage.widthAnchor.constraint(equalToConstant: 328),
            letterImage.heightAnchor.constraint(equalToConstant: 610),
            
            homeButton.topAnchor.constraint(equalTo: letterImage.bottomAnchor, constant: 20),
            homeButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            homeButton.widthAnchor.constraint(equalToConstant: 328),
            homeButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    private func updateGlassImage(basedOn condition: String) {
        // 병 이미지도 여기서 관리하라!
        //
        //
        //
        //
        switch condition {
        case "1":
            glassImage.image = UIImage(named: "brown")
        case "2":
            glassImage.image = UIImage(named: "green")
        case "3":
            glassImage.image = UIImage(named: "midnight_depth")
        case "4":
            glassImage.image = UIImage(named: "orange")
        case "5":
            glassImage.image = UIImage(named: "pink")
        case "6":
            glassImage.image = UIImage(named: "red")
        case "7":
            glassImage.image = UIImage(named: "serene_sky")
        case "8":
            glassImage.image = UIImage(named: "wandarer")
        case "9":
            glassImage.image = UIImage(named: "whisper")
        case "10":
            glassImage.image = UIImage(named: "yellow")
        default:
            glassImage.image = UIImage(named: "brown")
        }
    }
    
    // MARK: - 네비게이션 바
    private func setupCustomNavigationBar() {
        let navBar = UIView()
        navBar.backgroundColor = .clear
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "out"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(navBar)
        navBar.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 20),
        ])
    }
    
    @objc private func didTapCloseButton() {
        let stopSelectingVC = StopSelectingViewController()
        stopSelectingVC.modalTransitionStyle = .crossDissolve
        stopSelectingVC.modalPresentationStyle = .overFullScreen
        self.present(stopSelectingVC, animated: true, completion: nil)
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
}
