//
//  MainViewController.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/23/24.
//

import UIKit

class MainViewController : UIViewController {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "여행기를 남겨보세요!"
        label.font = .h1
        label.textColor = .black
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        setConstraint()
    }
    
    func setConstraint(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo:view.topAnchor, constant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 23),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -23),
            titleLabel.heightAnchor.constraint(equalToConstant: 124),
            
        ])
    }
}
