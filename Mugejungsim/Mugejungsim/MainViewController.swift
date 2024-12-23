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
        label.text = "Mugejungsim"
        label.font = .h1
        label.textColor = .black
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
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
