import UIKit
import SafariServices

class AboutUsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let developerCreditLabel = UILabel()
    private let instagramButton = UIButton(type: .system)
    
    // Background Logo View
    private let backgroundLogoView = BackgroundLogoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Background Logo - Large and prominent like in the images
        view.addSubview(backgroundLogoView)
        view.sendSubviewToBack(backgroundLogoView)
        
        // Title Label
        titleLabel.text = "About Us"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Description Label
        descriptionLabel.text = "Bear Cuts is WashU's on campus salon and barbershop, created to bring professional, affordable haircuts right where you live, study, and work. No need to waste time or money traveling off-campus, we're just steps away. Our skilled stylists offer high quality cuts in a modern, comfortable space designed for students' busy schedules. Whether you're between classes or after practice or club meetings, Bear Cuts makes looking your best more convenient than ever."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        // Developer Credit Label
        developerCreditLabel.text = "App Designed & Developed by\nDaniel Woldetsadik\nClass of '28 | d.s.woldetsadik@wustl.edu"
        developerCreditLabel.font = UIFont.systemFont(ofSize: 14)
        developerCreditLabel.textColor = UIColor.darkGray
        developerCreditLabel.textAlignment = .center
        developerCreditLabel.numberOfLines = 0
        developerCreditLabel.lineBreakMode = .byWordWrapping
        developerCreditLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(developerCreditLabel)
        
        // Instagram Button
        instagramButton.setTitle("Follow us on Instagram", for: .normal)
        instagramButton.backgroundColor = UIColor(hex: "#803FFF") ?? UIColor.purple
        instagramButton.setTitleColor(.white, for: .normal)
        instagramButton.layer.cornerRadius = 8
        instagramButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        instagramButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        instagramButton.tintColor = .white
        instagramButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instagramButton)
        

    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        backgroundLogoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Background Logo View - Large and prominent like in the images
            backgroundLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundLogoView.widthAnchor.constraint(equalToConstant: 550),
            backgroundLogoView.heightAnchor.constraint(equalToConstant: 550),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Developer Credit Label
            developerCreditLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            developerCreditLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            developerCreditLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Instagram Button
            instagramButton.topAnchor.constraint(equalTo: developerCreditLabel.bottomAnchor, constant: 30),
            instagramButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instagramButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            instagramButton.heightAnchor.constraint(equalToConstant: 50),
            

        ])
    }
    
    // MARK: - Actions
    private func setupActions() {
        instagramButton.addTarget(self, action: #selector(instagramButtonTapped), for: .touchUpInside)
    }
    
    @objc private func instagramButtonTapped() {
        if let url = URL(string: "https://www.instagram.com/bearcuts_washu?igsh=cjZ3MXRranV3ZWpl") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
    }
    

}
