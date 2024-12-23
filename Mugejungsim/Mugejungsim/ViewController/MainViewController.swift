//
//  MainViewController.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/23/24.
//

import UIKit

class MainViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행기를 남겨보세요!"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let MyPageButton: UIButton = {
        let mine = UIButton()
        mine.translatesAutoresizingMaskIntoConstraints = false
        mine.layer.cornerRadius = 25
        mine.clipsToBounds = true
        mine.backgroundColor = UIColor.lightGray
        mine.setImage(UIImage(systemName: "person.circle"), for: .normal)
        mine.tintColor = .white
        return mine
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // UI 요소 추가
        view.addSubview(titleLabel)
        view.addSubview(MyPageButton)
        
        setConstraintsWithAutolayout()
    }
    
    func setConstraintsWithAutolayout() {
        // Title Label Constraints
        let titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130)
        let titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let titleLabelTrailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        let titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 124)
        
        // MyPage Button Constraints
        let buttonTopConstraint = MyPageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        let buttonTrailingConstraint = MyPageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        let buttonWidthConstraint = MyPageButton.widthAnchor.constraint(equalToConstant: 50)
        let buttonHeightConstraint = MyPageButton.heightAnchor.constraint(equalToConstant: 50)
        
        // Activate all constraints
        NSLayoutConstraint.activate([
            titleLabelTopConstraint,
            titleLabelLeadingConstraint,
            titleLabelTrailingConstraint,
            titleLabelHeightConstraint,
            buttonTopConstraint,
            buttonTrailingConstraint,
            buttonWidthConstraint,
            buttonHeightConstraint
        ])
    }
}
