import UIKit

class BackgroundLogoView: UIView {
    
    // MARK: - UI Elements
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.alpha = 0.35 // Darker and more visible
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        loadBackgroundImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        loadBackgroundImage()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Image Loading
    private func loadBackgroundImage() {
        if let image = UIImage(named: "BackgroundLogo") {
            backgroundImageView.image = image
        } else {
            // Fallback to a placeholder or default image
            backgroundImageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        }
    }
    
    // MARK: - Public Methods
    func setAlpha(_ alpha: CGFloat) {
        backgroundImageView.alpha = alpha
    }
    
    func setContentMode(_ contentMode: UIView.ContentMode) {
        backgroundImageView.contentMode = contentMode
    }
}

