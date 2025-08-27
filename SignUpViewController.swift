//
//  SignUpViewController.swift
//  willbarber
//
//  Created by Daniel Woldetsadik on 8/16/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    // MARK: - UI Elements
    private let backgroundLogoView = BackgroundLogoView()
    private let darkOverlayView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let displayNameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let phoneTextField = UITextField()
    
    private let signUpButton = UIButton(type: .system)
    private let backToLoginButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Background Logo
        view.addSubview(backgroundLogoView)
        
        // Dark Overlay
        darkOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(darkOverlayView)
        
        // Title Label
        titleLabel.text = "Create Account"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        // Subtitle Label
        subtitleLabel.text = "Join Bear Cuts"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        view.addSubview(subtitleLabel)
        
        // Display Name Text Field
        displayNameTextField.placeholder = "Full Name"
        displayNameTextField.borderStyle = .none
        displayNameTextField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        displayNameTextField.layer.cornerRadius = 8
        displayNameTextField.layer.borderWidth = 1
        displayNameTextField.layer.borderColor = UIColor.white.cgColor
        displayNameTextField.textColor = .black
        displayNameTextField.font = UIFont.systemFont(ofSize: 16)
        displayNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        displayNameTextField.leftViewMode = .always
        view.addSubview(displayNameTextField)
        
        // Email Text Field
        emailTextField.placeholder = "Email (Gmail only)"
        emailTextField.borderStyle = .none
        emailTextField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.textColor = .black
        emailTextField.font = UIFont.systemFont(ofSize: 16)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        emailTextField.leftViewMode = .always
        view.addSubview(emailTextField)
        
        // Password Text Field
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.textColor = .black
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        passwordTextField.leftViewMode = .always
        view.addSubview(passwordTextField)
        
        // Confirm Password Text Field
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.borderStyle = .none
        confirmPasswordTextField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        confirmPasswordTextField.layer.cornerRadius = 8
        confirmPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.layer.borderColor = UIColor.white.cgColor
        confirmPasswordTextField.textColor = .black
        confirmPasswordTextField.font = UIFont.systemFont(ofSize: 16)
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        confirmPasswordTextField.leftViewMode = .always
        view.addSubview(confirmPasswordTextField)
        
        // Phone Text Field
        phoneTextField.placeholder = "Phone Number"
        phoneTextField.borderStyle = .none
        phoneTextField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        phoneTextField.layer.cornerRadius = 8
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor.white.cgColor
        phoneTextField.textColor = .black
        phoneTextField.font = UIFont.systemFont(ofSize: 16)
        phoneTextField.keyboardType = .phonePad
        phoneTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        phoneTextField.leftViewMode = .always
        view.addSubview(phoneTextField)
        
        // Sign Up Button
        signUpButton.setTitle("Create Account", for: .normal)
        signUpButton.backgroundColor = UIColor(hex: "#803FFF") ?? UIColor.purple
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 8
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.addSubview(signUpButton)
        
        // Back to Login Button
        backToLoginButton.setTitle("Already have an account? Sign In", for: .normal)
        backToLoginButton.setTitleColor(.white, for: .normal)
        backToLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(backToLoginButton)
        
        // Loading Indicator
        loadingIndicator.color = UIColor(hex: "#803FFF") ?? UIColor.purple
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        backgroundLogoView.translatesAutoresizingMaskIntoConstraints = false
        darkOverlayView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        displayNameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        backToLoginButton.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Background Logo
            backgroundLogoView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundLogoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundLogoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundLogoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Dark Overlay
            darkOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            darkOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            darkOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            darkOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Display Name Text Field
            displayNameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            displayNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            displayNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            displayNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Email Text Field
            emailTextField.topAnchor.constraint(equalTo: displayNameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password Text Field
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Confirm Password Text Field
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Phone Text Field
            phoneTextField.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Sign Up Button
            signUpButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Back to Login Button
            backToLoginButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            backToLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        backToLoginButton.addTarget(self, action: #selector(backToLoginTapped), for: .touchUpInside)
        
        // Add text field editing actions
        phoneTextField.addTarget(self, action: #selector(phoneTextFieldChanged), for: .editingChanged)
    }
    
    // MARK: - Button Actions
    @objc private func signUpButtonTapped() {
        guard let displayName = displayNameTextField.text, !displayName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid Gmail address")
            return
        }
        
        if password != confirmPassword {
            showAlert(title: "Error", message: "Passwords do not match")
            return
        }
        
        if password.count < 6 {
            showAlert(title: "Error", message: "Password must be at least 6 characters long")
            return
        }
        
        if !isValidPhoneNumber(phone) {
            showAlert(title: "Invalid Phone", message: "Please enter a valid phone number")
            return
        }
        
        loadingIndicator.startAnimating()
        signUpButton.isEnabled = false
        
        // Create user account
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.signUpButton.isEnabled = true
                
                if let error = error {
                    self?.showAlert(title: "Sign Up Failed", message: error.localizedDescription)
                } else if let user = result?.user {
                    // Save additional user data to Firestore
                    self?.saveUserData(user: user, displayName: displayName, phone: phone)
                }
            }
        }
    }
    
    @objc private func backToLoginTapped() {
        dismiss(animated: true)
    }
    
    @objc private func phoneTextFieldChanged() {
        formatPhoneNumber()
    }
    
    // MARK: - Helper Methods
    private func saveUserData(user: User, displayName: String, phone: String) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "displayName": displayName,
            "email": user.email ?? "",
            "phone": phone,
            "dateCreated": Date()
        ]
        
        db.collection("users").document(user.uid).setData(userData) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(title: "Error", message: "Account created but failed to save profile: \(error.localizedDescription)")
                } else {
                    self?.showAlert(title: "Success", message: "Account created successfully!") { 
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            return false
        }
        
        // Check if it's Gmail
        if !email.lowercased().hasSuffix("@gmail.com") {
            return false
        }
        
        return true
    }
    
    private func isValidPhoneNumber(_ phone: String) -> Bool {
        let cleanPhone = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return cleanPhone.count == 10
    }
    
    private func formatPhoneNumber() {
        guard let text = phoneTextField.text else { return }
        let cleanText = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if cleanText.count <= 3 {
            phoneTextField.text = cleanText
        } else if cleanText.count <= 6 {
            phoneTextField.text = "(\(cleanText.prefix(3))) \(cleanText.dropFirst(3))"
        } else {
            phoneTextField.text = "(\(cleanText.prefix(3))) \(cleanText.dropFirst(3).prefix(3))-\(cleanText.dropFirst(6))"
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
