//
//  StopSelectingViewController.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/24/24.
//


import UIKit

class StopSelectingViewController: UIViewController {

    // MARK: - UI Elements
    
    private let overlayView: UIView = { // 모달창 배경을 위한 변수
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.text = "한줄 남기기를\n그만두시겠어요?"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("그만두기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이어서 하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(hex: "#CFFFDD")
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        setActions()
    }
    
    // MARK: - UI Setup
    
    private func setUI() {
        view.addSubview(overlayView)
        view.addSubview(containerView)
        containerView.addSubview(promptLabel)
        containerView.addSubview(stopButton)
        containerView.addSubview(continueButton)
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // Overlay view (background)
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Container view
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            // Prompt label
            promptLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            promptLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            promptLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Stop button
            stopButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stopButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stopButton.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -10),
            stopButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Continue button
            continueButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            continueButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    
    private func setActions() {
        stopButton.addTarget(self, action: #selector(StopButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(ContinueButtonTapped), for: .touchUpInside)
    }
    
    @objc private func StopButtonTapped() {
        print("그만두기 버튼 클릭됨")
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func ContinueButtonTapped() {
        print("이어서 하기 버튼 클릭됨")
        dismiss(animated: true, completion: nil)
    }
}
