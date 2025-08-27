//
//  HomeViewController.swift
//  willbarber
//
//  Created by Daniel Woldetsadik on 8/16/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let bookAppointmentCard = UIView()
    private let bookAppointmentLabel = UILabel()
    private let bookAppointmentIcon = UIImageView()
    
    private let galleryCard = UIView()
    private let galleryLabel = UILabel()
    private let galleryIcon = UIImageView()
    
    private let locationCard = UIView()
    private let locationLabel = UILabel()
    private let locationIcon = UIImageView()
    
    private let notificationCard = UIView()
    private let notificationLabel = UILabel()
    private let notificationIcon = UIImageView()
    
    private let aboutUsCard = UIView()
    private let aboutUsLabel = UILabel()
    private let aboutUsIcon = UIImageView()
    
    // Background Logo View
    private let backgroundLogoView = BackgroundLogoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        setupNotificationHandling()
    }
    

    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Bear Cuts"
        
        // Navigation bar setup
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        
                        // Add About Us button to navigation bar
        let aboutUsButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(aboutUsTapped)
        )
        aboutUsButton.tintColor = UIColor(hex: "#803FFF") ?? UIColor.purple
        
        // Make the button bigger
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        aboutUsButton.image = UIImage(systemName: "line.3.horizontal", withConfiguration: config)
        
        navigationItem.rightBarButtonItem = aboutUsButton
        
        // Background Logo - Large and prominent like in the images
        view.addSubview(backgroundLogoView)
        view.sendSubviewToBack(backgroundLogoView)
        
        // Scroll View
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Content View
        contentView.backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 20
        
        // Title Label
        titleLabel.text = "Welcome to Bear Cuts"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        // Subtitle Label
        subtitleLabel.text = "Professional Haircuts & Styling at WashU"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18)
        subtitleLabel.textColor = UIColor.darkGray
        subtitleLabel.textAlignment = .center
        contentView.addSubview(subtitleLabel)
        
        // Book Appointment Card
        setupCard(bookAppointmentCard, label: bookAppointmentLabel, icon: bookAppointmentIcon, 
                 title: "Book Appointment", iconName: "calendar.badge.plus", color: UIColor(hex: "#803FFF") ?? UIColor.purple)
        contentView.addSubview(bookAppointmentCard)
        
        // Gallery Card
        setupCard(galleryCard, label: galleryLabel, icon: galleryIcon, 
                 title: "View Styles", iconName: "photo.on.rectangle", color: UIColor(hex: "#803FFF") ?? UIColor.purple)
        contentView.addSubview(galleryCard)
        
        // Location Card
        setupCard(locationCard, label: locationLabel, icon: locationIcon, 
                 title: "Location & Hours", iconName: "location.fill", color: UIColor(hex: "#803FFF") ?? UIColor.purple)
        contentView.addSubview(locationCard)
        
        // Notification Card
        setupCard(notificationCard, label: notificationLabel, icon: notificationIcon, 
                 title: "Notification Settings", iconName: "bell.fill", color: UIColor(hex: "#803FFF") ?? UIColor.purple)
        contentView.addSubview(notificationCard)
        

    }
    
    private func setupCard(_ card: UIView, label: UILabel, icon: UIImageView, title: String, iconName: String, color: UIColor) {
        // Glassmorphism Style - Frosted glass effect
        card.backgroundColor = UIColor.white.withAlphaComponent(0.15) // Subtle white transparency
        card.layer.cornerRadius = 20 // Larger radius for modern look
        
        // Frosted glass effect with backdrop filter simulation
        card.layer.masksToBounds = false
        
        // Soft shadows that make buttons appear to float
        card.layer.shadowColor = color.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 8)
        card.layer.shadowRadius = 16
        card.layer.shadowOpacity = 0.25
        
        // Subtle borders with gradient edges effect
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor // Subtle white border
        
        // Inner highlight for depth
        let innerShadow = CALayer()
        innerShadow.frame = card.bounds
        innerShadow.cornerRadius = 20
        innerShadow.backgroundColor = UIColor.clear.cgColor
        innerShadow.shadowColor = UIColor.white.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: -2)
        innerShadow.shadowRadius = 4
        innerShadow.shadowOpacity = 0.3
        card.layer.addSublayer(innerShadow)
        
        // Icon styling with enhanced appearance
        icon.image = UIImage(systemName: iconName)
        icon.tintColor = color
        icon.contentMode = .scaleAspectFit
        
        // Icon background circle for better visual balance
        let iconBackground = UIView()
        iconBackground.backgroundColor = color.withAlphaComponent(0.1)
        iconBackground.layer.cornerRadius = 20
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(iconBackground)
        card.addSubview(icon)
        
        // Label styling with enhanced typography
        label.text = title
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = color
        label.textAlignment = .center
        
        // Text shadow for depth
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.1
        
        card.addSubview(label)
        
        // Setup icon background constraints
        iconBackground.centerXAnchor.constraint(equalTo: card.centerXAnchor).isActive = true
        iconBackground.topAnchor.constraint(equalTo: card.topAnchor, constant: 20).isActive = true
        iconBackground.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconBackground.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Setup icon constraints relative to background
        icon.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bookAppointmentCard.translatesAutoresizingMaskIntoConstraints = false
        bookAppointmentLabel.translatesAutoresizingMaskIntoConstraints = false
        bookAppointmentIcon.translatesAutoresizingMaskIntoConstraints = false
        galleryCard.translatesAutoresizingMaskIntoConstraints = false
        galleryLabel.translatesAutoresizingMaskIntoConstraints = false
        galleryIcon.translatesAutoresizingMaskIntoConstraints = false
        locationCard.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        
        notificationCard.translatesAutoresizingMaskIntoConstraints = false
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationIcon.translatesAutoresizingMaskIntoConstraints = false
        aboutUsCard.translatesAutoresizingMaskIntoConstraints = false
        aboutUsLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutUsIcon.translatesAutoresizingMaskIntoConstraints = false
        backgroundLogoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Background Logo View - Large and prominent like in the images
            backgroundLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundLogoView.widthAnchor.constraint(equalToConstant: 500),
            backgroundLogoView.heightAnchor.constraint(equalToConstant: 500),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // Remove fixed height to allow dynamic sizing
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Book Appointment Card
            bookAppointmentCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            bookAppointmentCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bookAppointmentCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bookAppointmentCard.heightAnchor.constraint(equalToConstant: 200),
            
            // Book Appointment Icon - centered at top for glassmorphism
            bookAppointmentIcon.centerXAnchor.constraint(equalTo: bookAppointmentCard.centerXAnchor),
            bookAppointmentIcon.topAnchor.constraint(equalTo: bookAppointmentCard.topAnchor, constant: 20),
            bookAppointmentIcon.widthAnchor.constraint(equalToConstant: 24),
            bookAppointmentIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // Book Appointment Label - below icon
            bookAppointmentLabel.centerXAnchor.constraint(equalTo: bookAppointmentCard.centerXAnchor),
            bookAppointmentLabel.topAnchor.constraint(equalTo: bookAppointmentIcon.bottomAnchor, constant: 16),
            bookAppointmentLabel.leadingAnchor.constraint(equalTo: bookAppointmentCard.leadingAnchor, constant: 16),
            bookAppointmentLabel.trailingAnchor.constraint(equalTo: bookAppointmentCard.trailingAnchor, constant: -16),
            
            // Notification Card (now second)
            notificationCard.topAnchor.constraint(equalTo: bookAppointmentCard.bottomAnchor, constant: 20),
            notificationCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            notificationCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            notificationCard.heightAnchor.constraint(equalToConstant: 200),
            
            // Notification Icon - centered at top for glassmorphism
            notificationIcon.centerXAnchor.constraint(equalTo: notificationCard.centerXAnchor),
            notificationIcon.topAnchor.constraint(equalTo: notificationCard.topAnchor, constant: 20),
            notificationIcon.widthAnchor.constraint(equalToConstant: 24),
            notificationIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // Notification Label - below icon
            notificationLabel.centerXAnchor.constraint(equalTo: notificationCard.centerXAnchor),
            notificationLabel.topAnchor.constraint(equalTo: notificationIcon.bottomAnchor, constant: 16),
            notificationLabel.leadingAnchor.constraint(equalTo: notificationCard.leadingAnchor, constant: 16),
            notificationLabel.trailingAnchor.constraint(equalTo: notificationCard.trailingAnchor, constant: -16),
            
            // Gallery Card (now third)
            galleryCard.topAnchor.constraint(equalTo: notificationCard.bottomAnchor, constant: 20),
            galleryCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            galleryCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            galleryCard.heightAnchor.constraint(equalToConstant: 200),
            
            // Gallery Icon - centered at top for glassmorphism
            galleryIcon.centerXAnchor.constraint(equalTo: galleryCard.centerXAnchor),
            galleryIcon.topAnchor.constraint(equalTo: galleryCard.topAnchor, constant: 20),
            galleryIcon.widthAnchor.constraint(equalToConstant: 24),
            galleryIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // Gallery Label - below icon
            galleryLabel.centerXAnchor.constraint(equalTo: galleryCard.centerXAnchor),
            galleryLabel.topAnchor.constraint(equalTo: galleryIcon.bottomAnchor, constant: 16),
            galleryLabel.leadingAnchor.constraint(equalTo: galleryCard.leadingAnchor, constant: 16),
            galleryLabel.trailingAnchor.constraint(equalTo: galleryCard.trailingAnchor, constant: -16),
            
            // Location Card (now fourth)
            locationCard.topAnchor.constraint(equalTo: galleryCard.bottomAnchor, constant: 20),
            locationCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            locationCard.heightAnchor.constraint(equalToConstant: 200),
            
            // Location Icon - centered at top for glassmorphism
            locationIcon.centerXAnchor.constraint(equalTo: locationCard.centerXAnchor),
            locationIcon.topAnchor.constraint(equalTo: locationCard.topAnchor, constant: 20),
            locationIcon.widthAnchor.constraint(equalToConstant: 24),
            locationIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // Location Label - below icon
            locationLabel.centerXAnchor.constraint(equalTo: locationCard.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: locationIcon.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: locationCard.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: locationCard.trailingAnchor, constant: -16),
            
            // Bottom constraint for content view
            locationCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)

        ])
    }
    
    // MARK: - Actions
    private func setupActions() {
        // Add tap gestures to cards
        let bookAppointmentTap = UITapGestureRecognizer(target: self, action: #selector(bookAppointmentTapped))
        bookAppointmentCard.addGestureRecognizer(bookAppointmentTap)
        bookAppointmentCard.isUserInteractionEnabled = true
        
        let galleryTap = UITapGestureRecognizer(target: self, action: #selector(galleryTapped))
        galleryCard.addGestureRecognizer(galleryTap)
        galleryCard.isUserInteractionEnabled = true
        
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(locationTapped))
        locationCard.addGestureRecognizer(locationTap)
        locationCard.isUserInteractionEnabled = true
        
        let notificationTap = UITapGestureRecognizer(target: self, action: #selector(notificationTapped))
        notificationCard.addGestureRecognizer(notificationTap)
        notificationCard.isUserInteractionEnabled = true
        

    }
    
    // MARK: - Card Actions
    @objc private func bookAppointmentTapped() {
        // Open booking website directly
        if let url = URL(string: "https://bearcuts.glossgenius.com/") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func galleryTapped() {
        // Gallery is accessible to everyone
        let galleryVC = GalleryViewController()
        navigationController?.pushViewController(galleryVC, animated: true)
    }
    
    @objc private func locationTapped() {
        // Location is accessible to everyone
        let locationVC = LocationViewController()
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @objc private func aboutUsTapped() {
        // About Us is accessible to everyone
        let aboutUsVC = AboutUsViewController()
        navigationController?.pushViewController(aboutUsVC, animated: true)
    }
    
    @objc private func notificationTapped() {
        // Open notification settings with calendar
        let notificationVC = NotificationSettingsViewController()
        navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    private func setupNotificationHandling() {
        // Listen for notification taps
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotificationTap),
            name: NSNotification.Name("OpenReminderDetails"),
            object: nil
        )
    }
    
    @objc private func handleNotificationTap(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reminderId = userInfo["reminderId"] as? String,
              let appointmentDate = userInfo["appointmentDate"] as? TimeInterval,
              let appointmentType = userInfo["appointmentType"] as? String else {
            return
        }
        
        let date = Date(timeIntervalSince1970: appointmentDate)
        
        // Show reminder details alert
        let alert = UIAlertController(
            title: "🐻 Bear Cuts Reminder",
            message: "You have a \(appointmentType) appointment coming up at \(formatTime(date))!",
            preferredStyle: .alert
        )
        
                                         alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
           
           // Mark this specific reminder as seen when coming from notification
           // Add longer delay to prevent rate limiting
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               // Post notification to mark this specific reminder as seen
               NotificationCenter.default.post(
                   name: NSNotification.Name("MarkReminderAsSeen"),
                   object: nil,
                   userInfo: ["reminderId": reminderId]
               )
           }
           
           present(alert, animated: true)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

