import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let addressLabel = UILabel()
    private let phoneLabel = UILabel()
    private let emailLabel = UILabel()
    private let hoursLabel = UILabel()
    private let mapView = MKMapView()
    private let directionsButton = UIButton(type: .system)
    private let callUsButton = UIButton(type: .system)
    
    // Background Logo View
    private let backgroundLogoView = BackgroundLogoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupMap()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Location & Hours"
        
        // Background Logo - Large and prominent like in the images
        view.addSubview(backgroundLogoView)
        view.sendSubviewToBack(backgroundLogoView)
        
        // Title Label
        titleLabel.text = "Location & Hours"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Map View
        mapView.layer.cornerRadius = 12
        mapView.clipsToBounds = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        // Address Label
        addressLabel.text = "📍 Address:\n6601 Shepley Dr, Unit 157\nSaint Louis, MO 63105"
        addressLabel.font = UIFont.systemFont(ofSize: 16)
        addressLabel.textColor = UIColor.black
        addressLabel.textAlignment = .center
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressLabel)
        
        // Phone Label
        phoneLabel.text = "📞 Phone: 314-399-9976"
        phoneLabel.font = UIFont.systemFont(ofSize: 16)
        phoneLabel.textColor = UIColor.black
        phoneLabel.textAlignment = .center
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneLabel)
        
        // Email Label
        emailLabel.text = "✉️ Email: Info@washubearcuts.com"
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        emailLabel.textColor = UIColor.black
        emailLabel.textAlignment = .center
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        
        // Hours Label
        hoursLabel.text = "🕒 Hours:\nMonday-Thursday: Closed\nFriday: 3-8pm\nSaturday: 10am-8pm\nSunday: 3-8pm"
        hoursLabel.font = UIFont.systemFont(ofSize: 16)
        hoursLabel.textColor = UIColor.black
        hoursLabel.textAlignment = .center
        hoursLabel.numberOfLines = 0
        hoursLabel.lineBreakMode = .byWordWrapping
        hoursLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hoursLabel)
        
        // Directions Button
        directionsButton.setTitle("🗺️ Open Google Maps", for: .normal)
        directionsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        directionsButton.backgroundColor = UIColor(hex: "#803FFF") ?? UIColor.purple
        directionsButton.setTitleColor(.white, for: .normal)
        directionsButton.layer.cornerRadius = 12
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        directionsButton.addTarget(self, action: #selector(getDirectionsTapped), for: .touchUpInside)
        view.addSubview(directionsButton)
        
        // Call Us Button
        callUsButton.setTitle("📞 Call Us", for: .normal)
        callUsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        callUsButton.backgroundColor = UIColor(hex: "#803FFF") ?? UIColor.purple
        callUsButton.setTitleColor(.white, for: .normal)
        callUsButton.layer.cornerRadius = 12
        callUsButton.translatesAutoresizingMaskIntoConstraints = false
        callUsButton.addTarget(self, action: #selector(callUsTapped), for: .touchUpInside)
        view.addSubview(callUsButton)
        

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
            
            // Map View
            mapView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            
            // Address Label
            addressLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Phone Label
            phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Email Label
            emailLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Hours Label
            hoursLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            hoursLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hoursLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Directions Button
            directionsButton.topAnchor.constraint(equalTo: hoursLabel.bottomAnchor, constant: 25),
            directionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            directionsButton.widthAnchor.constraint(equalToConstant: 200),
            directionsButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Call Us Button
            callUsButton.topAnchor.constraint(equalTo: directionsButton.bottomAnchor, constant: 15),
            callUsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            callUsButton.widthAnchor.constraint(equalToConstant: 200),
            callUsButton.heightAnchor.constraint(equalToConstant: 50),
            

        ])
    }
    
    private func setupNavigationBar() {
        title = "Location & Hours"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupMap() {
        // Set location for 6601 Shepley Dr, Unit 157, Saint Louis, MO 63105
        let location = CLLocationCoordinate2D(latitude: 38.6461575, longitude: -90.3124273)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        
        // Add a pin for your location
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Bear Cuts"
        annotation.subtitle = "Professional Barber Shop"
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - Actions
    
    @objc private func getDirectionsTapped() {
        // Open Google Maps with directions to your location
        let location = CLLocationCoordinate2D(latitude: 38.6461575, longitude: -90.3124273)
        let googleMapsURL = "comgooglemaps://?daddr=\(location.latitude),\(location.longitude)&directionsmode=driving"
        
        if let url = URL(string: googleMapsURL), UIApplication.shared.canOpenURL(url) {
            // Google Maps app is installed
            UIApplication.shared.open(url)
        } else {
            // Fallback to Google Maps website
            let webURL = "https://www.google.com/maps/dir/?api=1&destination=\(location.latitude),\(location.longitude)"
            if let fallbackURL = URL(string: webURL) {
                UIApplication.shared.open(fallbackURL)
            }
        }
    }
    
    @objc private func callUsTapped() {
        // Call the phone number
        if let phoneURL = URL(string: "tel:314-399-9976") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL)
            } else {
                // Fallback: copy phone number to clipboard
                UIPasteboard.general.string = "314-399-9976"
                // Show alert to user
                let alert = UIAlertController(title: "Phone Number Copied", message: "The phone number 314-399-9976 has been copied to your clipboard.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
    }
}
