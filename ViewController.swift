//
//  ViewController.swift
//  willbarber
//
//  Created by Daniel Woldetsadik on 8/16/25.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    private let backgroundLogoView = BackgroundLogoView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Don't setup UI since we're not showing this view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Navigate to home screen after view appears
        navigateToHome()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Background Logo - Large and prominent like in the images
        view.addSubview(backgroundLogoView)
        view.sendSubviewToBack(backgroundLogoView)
        
        // Title Label
        titleLabel.text = "Bear Cuts"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        // Subtitle Label
        subtitleLabel.text = "Professional Haircuts & Styling"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        subtitleLabel.textColor = .darkGray
        subtitleLabel.textAlignment = .center
        view.addSubview(subtitleLabel)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        backgroundLogoView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Background Logo - Large and prominent like in the images
            backgroundLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundLogoView.widthAnchor.constraint(equalToConstant: 400),
            backgroundLogoView.heightAnchor.constraint(equalToConstant: 400),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Navigation
    private func navigateToHome() {
        let homeVC = HomeViewController()
        let navController = UINavigationController(rootViewController: homeVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

