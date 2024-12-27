//
//  DetailedPhotoViewController.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/27/24.
//

/*
 * 디스크립션라벨 배열에 각 이미지에 대한 목데이터를 받아와야 한다.
 * 디스플레이 텍스트뷰도 각 이미지에 대하여 저장된 텍스트를 받아와야 한다.
 * 텍스트가 없으면 텍스트 박스 지우는게 좋은 듯
 */

import UIKit

class DetailedPhotoViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2 // Border width
        imageView.layer.borderColor = UIColor.systemGray4.cgColor // Border color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "3 / 25" // Example count text
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Medium", size: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 각 사진에 대한 값들을 CategoryMockData에서 확인하여 출력하도록 만든다
    private let descriptionLabels: [PaddedLabel] = {
        let texts = ["음식이 정말 맛있었어요", "신선하고 깔끔했어요", "디저트가 예술이었어요"]
        return texts.map { text in
            let label = PaddedLabel()
            label.text = text
            label.textColor = .black
            label.font = UIFont(name: "Pretendard-Medium", size: 14)
            label.textAlignment = .left
            label.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.973, alpha: 1)
            label.layer.cornerRadius = 4
            label.layer.masksToBounds = true
            label.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // 좌우 패딩 추가
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }
    }()
    
    private let displayTextView: UITextView = {
        let textView = UITextView()
        textView.text = "대한민국은 아름다운 자연과 문화유산이 조화를 이루는 나라입니다. 국민 모두가 화합하며 평화를 사랑하는 나라로 발전해 나아가고 있습니다."
        textView.font = UIFont(name: "Pretendard-Regular", size: 15)
        textView.textColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        textView.textAlignment = .left
        textView.isEditable = false // 수정 불가
        textView.isSelectable = false // 선택 불가
        textView.layer.cornerRadius = 7
        textView.layer.borderWidth = 1.28
        textView.layer.borderColor = UIColor(red: 0.824, green: 0.824, blue: 0.961, alpha: 1).cgColor
        textView.backgroundColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 21.5, left: 24, bottom: 21.5, right: 24)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupCustomNavigationBar()
        setupUI()
        setupConstraints()
    }
    
    private func setupCustomNavigationBar() {
        let navBar = UIView()
        navBar.backgroundColor = .clear
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "X_Button"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navBar)
        navBar.addSubview(imageCountLabel)
        navBar.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 40),
                        
            imageCountLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            imageCountLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupUI() {
        view.addSubview(imageView)
        for label in descriptionLabels {
            view.addSubview(label)
        }
        view.addSubview(displayTextView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 270),
                    
            descriptionLabels[0].topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 19),
            descriptionLabels[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabels[0].heightAnchor.constraint(equalToConstant: 39),
                    
            descriptionLabels[1].topAnchor.constraint(equalTo: descriptionLabels[0].bottomAnchor, constant: 10),
            descriptionLabels[1].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabels[1].heightAnchor.constraint(equalToConstant: 39),
                    
            descriptionLabels[2].topAnchor.constraint(equalTo: descriptionLabels[1].bottomAnchor, constant: 10),
            descriptionLabels[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabels[2].heightAnchor.constraint(equalToConstant: 39),
            
            displayTextView.topAnchor.constraint(equalTo: descriptionLabels[2].bottomAnchor, constant: 19),
            displayTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: UILabel에 Padding을 넣기 위한 Class
class PaddedLabel: UILabel {
    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // 기본 패딩 값

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}
