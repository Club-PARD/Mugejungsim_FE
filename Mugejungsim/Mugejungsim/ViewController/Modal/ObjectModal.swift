//
//  ObjectModal.swift
//  Mugejungsim
//
//  Created by KIM JIWON on 12/28/24.
//

import UIKit

class ObjectModal: UIViewController {

    var recordID: String = ""
    
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
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)

        updateLabelText()
        updateImages()
        
//        guard let recordUUID = UUID(uuidString: recordID) else {
//            print("유효하지 않은 recordID: \(recordID)")
//            return
//        }
//            
//        if let record = TravelRecordManager.shared.getRecord(by: recordUUID) {
//            print("CheckObjeImageViewController에서 데이터 확인:")
//            print("Record ID: \(record.id)")
//            print("Title: \(record.title)")
//            print("oneLine1: \(record.oneLine1)")
//            print("oneLine2: \(record.oneLine2)")
//            updateLabelText()
//            updateImages()
//        } else {
//            print("recordID에 해당하는 기록을 찾을 수 없습니다.")
//        }
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
        
        view.addSubview(homeButton)
        
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
            homeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            homeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

//            homeButton.widthAnchor.constraint(equalToConstant: 328),
            homeButton.heightAnchor.constraint(equalToConstant: 52),
        ])
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
    
    @objc private func homeButtonTapped() {
        print("Home button frame: \(homeButton.frame)")
        print("Home button isHidden: \(homeButton.isHidden)")
        print("Home button isUserInteractionEnabled: \(homeButton.isUserInteractionEnabled)")
        
        let myRecordsVC = MyRecordsViewController()
        myRecordsVC.modalPresentationStyle = .fullScreen
        present(myRecordsVC, animated: true, completion: nil)
    }
    
    private func updateImages() {
        // 병 이미지도 여기서 관리하라!
        guard let recordID = Int(recordID) else {
            print("유효하지 않은 recordID: \(recordID)")
            return
        }
        let record = TravelRecordManager.shared.getRecord(by: recordID)
        
        // bottle(glass)
        // letter
        switch record?.oneLine1 {
        case "value1":
            glassImage.image = UIImage(named: "Dreamy Pink")
            letterImage.image = UIImage(named: "pink")
        case "value2":
            glassImage.image = UIImage(named: "Cloud Whisper")
            letterImage.image = UIImage(named: "whisper")
        case "value3":
            glassImage.image = UIImage(named: "Sunburst Yellow")
            letterImage.image = UIImage(named: "yellow")
        case "value4":
            glassImage.image = UIImage(named: "Radiant Orange")
            letterImage.image = UIImage(named: "orange")
        case "value5":
            glassImage.image = UIImage(named: "Serene Sky")
            letterImage.image = UIImage(named: "serene_sky")
        case "value6":
            glassImage.image = UIImage(named: "Midnight Depth")
            letterImage.image = UIImage(named: "midnight_depth")
        case "value7":
            glassImage.image = UIImage(named: "Wanderer's Flame")
            letterImage.image = UIImage(named: "wandarer")
        case "value8":
            glassImage.image = UIImage(named: "Storybook Brown")
            letterImage.image = UIImage(named: "brown")
        case "value9":
            glassImage.image = UIImage(named: "Ember Red")
            letterImage.image = UIImage(named: "red")
        case "value10":
            glassImage.image = UIImage(named: "Meadow Green")
            letterImage.image = UIImage(named: "green")
        default:
            glassImage.image = UIImage(named: "Storybook Brown")
            letterImage.image = UIImage(named: "brown")
        }
    }
    
    private func updateLabelText() {
        // recordID 유효성 확인
        guard let recordUUID = Int(recordID) else {
            print("유효하지 않은 recordID: \(recordID)")
            return
        }
        // 기록 가져오기
        guard let record = TravelRecordManager.shared.getRecord(by: recordUUID) else {
            print("recordID에 해당하는 기록을 찾을 수 없습니다.")
            return
        }
        
        // oneLine1 값을 확인하고 contentLabel 업데이트
        let labelText: String
        switch record.oneLine1 {
        case "value1":
            labelText = "당신의 여행 컬러는\n\"Dreamy Pink\"입니다."
        case "value2":
            labelText = "당신의 여행 컬러는\n\"Cloud Whisper\"입니다."
        case "value3":
            labelText = "당신의 여행 컬러는\n\"Sunburst Yellow\"입니다."
        case "value4":
            labelText = "당신의 여행 컬러는\n\"Radiant Orange\"입니다."
        case "value5":
            labelText = "당신의 여행 컬러는\n\"Serene Sky\"입니다."
        case "value6":
            labelText = "당신의 여행 컬러는\n\"Midnight Depth\"입니다."
        case "value7":
            labelText = "당신의 여행 컬러는\n\"Wanderer’s Flame\"입니다."
        case "value8":
            labelText = "당신의 여행 컬러는\n\"Storybook Brown\"입니다."
        case "value9":
            labelText = "당신의 여행 컬러는\n\"Ember Red\"입니다."
        case "value10":
            labelText = "당신의 여행 컬러는\n\"Meadow Green\"입니다."
        default:
            labelText = "당신의 여행 컬러는\n\"알 수 없음\"입니다."
        }
        
        // 업데이트된 텍스트를 라벨에 설정
        contentLabel.text = labelText
    }
}
