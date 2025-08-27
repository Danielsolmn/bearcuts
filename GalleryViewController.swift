//
//  GalleryViewController.swift
//  willbarber
//
//  Created by Daniel Woldetsadik on 8/16/25.
//

import UIKit

struct GalleryPhoto {
    let id: String
    let imageName: String
    let category: String
    let styleName: String
    let emoji: String
}

class GalleryViewController: UIViewController {
    
    // MARK: - UI Elements
    private let categorySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let noPhotosLabel = UILabel()
    
    // Background Logo View
    private let backgroundLogoView = BackgroundLogoView()
    
    // MARK: - Properties
    private var photos: [GalleryPhoto] = []
    private var filteredPhotos: [GalleryPhoto] = []
    private var selectedCategory: String = "Men Styles"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupCollectionView()
        setupActions()
        setupLocalPhotos()
    }
    
    // MARK: - Navigation Setup
    private func setupNavigationBar() {
        title = "Gallery"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        
        // Add back button
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = UIColor(red: 128/255, green: 0/255, blue: 128/255, alpha: 1.0)
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Gallery"
        
        // Background Logo - Large and prominent like in the images
        view.addSubview(backgroundLogoView)
        view.sendSubviewToBack(backgroundLogoView)
        
        // Category Segmented Control
        categorySegmentedControl.insertSegment(withTitle: "Men Styles", at: 0, animated: false)
        categorySegmentedControl.insertSegment(withTitle: "Women Styles", at: 1, animated: false)
        categorySegmentedControl.selectedSegmentIndex = 0
        categorySegmentedControl.backgroundColor = .white
        categorySegmentedControl.selectedSegmentTintColor = UIColor(hex: "#803FFF") ?? UIColor.purple
        categorySegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(hex: "#803FFF") ?? UIColor.purple], for: .normal)
        categorySegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        view.addSubview(categorySegmentedControl)
        
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(noPhotosLabel)
    }
    
    private func setupConstraints() {
        backgroundLogoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Background Logo View - Large and prominent like in the images
            backgroundLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundLogoView.widthAnchor.constraint(equalToConstant: 600),
            backgroundLogoView.heightAnchor.constraint(equalToConstant: 600),
            
            // Category Segmented Control
            categorySegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            categorySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categorySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categorySegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: categorySegmentedControl.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // No Photos Label
            noPhotosLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPhotosLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GalleryPhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        // Add pull-to-refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshGallery), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupActions() {
        categorySegmentedControl.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
    }
    


    

    
    private func filterPhotos() {
        filteredPhotos = photos.filter { $0.category == selectedCategory }
    }
    
    // MARK: - Local Photos Setup
    private func setupLocalPhotos() {
        // Men Styles - 10 real styles
        let menStyles = [
            GalleryPhoto(id: "1", imageName: "Burst Fade", category: "Men Styles", styleName: "Burst Fade", emoji: "🔥"),
            GalleryPhoto(id: "2", imageName: "Buzz Cut", category: "Men Styles", styleName: "Buzz Cut", emoji: "✂️"),
            GalleryPhoto(id: "3", imageName: "Caesar Cut", category: "Men Styles", styleName: "Caesar Cut", emoji: "👑"),
            GalleryPhoto(id: "4", imageName: "Comb Over & Taper Fade", category: "Men Styles", styleName: "Comb Over & Taper Fade", emoji: "💼"),
            GalleryPhoto(id: "5", imageName: "Crew Cut", category: "Men Styles", styleName: "Crew Cut", emoji: "🎯"),
            GalleryPhoto(id: "6", imageName: "Drop Fade", category: "Men Styles", styleName: "Drop Fade", emoji: "⬇️"),
            GalleryPhoto(id: "7", imageName: "Faux Hawk", category: "Men Styles", styleName: "Faux Hawk", emoji: "🦅"),
            GalleryPhoto(id: "8", imageName: "French Crop", category: "Men Styles", styleName: "French Crop", emoji: "🇫🇷"),
            GalleryPhoto(id: "9", imageName: "High & Tight", category: "Men Styles", styleName: "High & Tight", emoji: "⚡"),
            GalleryPhoto(id: "10", imageName: "High Fade", category: "Men Styles", styleName: "High Fade", emoji: "📈")
        ]
        
        // Women Styles - 10 real styles
        let womenStyles = [
            GalleryPhoto(id: "11", imageName: "27 Timeless Long Hair with Bangs Hairstyles Everyone's Talking About", category: "Women Styles", styleName: "Long Hair with Bangs", emoji: "💇‍♀️"),
            GalleryPhoto(id: "12", imageName: "Balayage", category: "Women Styles", styleName: "Balayage", emoji: "✨"),
            GalleryPhoto(id: "13", imageName: "Beach Waves", category: "Women Styles", styleName: "Beach Waves", emoji: "🌊"),
            GalleryPhoto(id: "14", imageName: "Box Braids & Knotless Braids", category: "Women Styles", styleName: "Box Braids & Knotless Braids", emoji: "👩‍🦱"),
            GalleryPhoto(id: "15", imageName: "Half-Up, Half-Down Styles", category: "Women Styles", styleName: "Half-Up, Half-Down Styles", emoji: "🎀"),
            GalleryPhoto(id: "16", imageName: "Layered Cut (Medium_Long Layers)", category: "Women Styles", styleName: "Layered Cut", emoji: "📚"),
            GalleryPhoto(id: "17", imageName: "Lob (Long Bob)", category: "Women Styles", styleName: "Lob (Long Bob)", emoji: "💁‍♀️"),
            GalleryPhoto(id: "18", imageName: "Messy Bun", category: "Women Styles", styleName: "Messy Bun", emoji: "🍞"),
            GalleryPhoto(id: "19", imageName: "Natural Curls & Twist-Outs", category: "Women Styles", styleName: "Natural Curls & Twist-Outs", emoji: "🌀"),
            GalleryPhoto(id: "20", imageName: "Straight & Sleek (Middle Part)", category: "Women Styles", styleName: "Straight & Sleek", emoji: "📏")
        ]
         
        photos = menStyles + womenStyles
        filterPhotos()
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func categoryChanged() {
        let categories = ["Men Styles", "Women Styles"]
        selectedCategory = categories[categorySegmentedControl.selectedSegmentIndex]
        filterPhotos()
        collectionView.reloadData()
        
        if filteredPhotos.isEmpty {
            noPhotosLabel.isHidden = false
        } else {
            noPhotosLabel.isHidden = true
        }
    }
    
    @objc private func refreshGallery() {
        setupLocalPhotos()
        collectionView.refreshControl?.endRefreshing()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! GalleryPhotoCell
        let photo = filteredPhotos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = filteredPhotos[indexPath.item]
        showPhotoDetail(photo)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 60) / 2
        return CGSize(width: width, height: width * 1.6)
    }
}

// MARK: - Helper Methods
extension GalleryViewController {
    private func showPhotoDetail(_ photo: GalleryPhoto) {
        // Go directly to full screen view
        let fullScreenVC = FullScreenPhotoViewController(photo: photo)
        fullScreenVC.modalPresentationStyle = .fullScreen
        present(fullScreenVC, animated: true)
    }
}

// MARK: - Gallery Photo Cell
class GalleryPhotoCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0) // Charcoal Grey
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(categoryLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
            
            categoryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 1),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }
    
    func configure(with photo: GalleryPhoto) {
        // Set emoji and style name
        categoryLabel.text = "\(photo.emoji) \(photo.styleName)"
        
        // Load local image
        if let image = UIImage(named: photo.imageName) {
            imageView.image = image
        } else {
            // Fallback to emoji if image not found
            imageView.image = nil
            imageView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        categoryLabel.text = nil
    }
}

// MARK: - Full Screen Photo View Controller
class FullScreenPhotoViewController: UIViewController {
    
    private let photo: GalleryPhoto
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(photo: GalleryPhoto) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        loadImage()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(closeButton)
        
        scrollView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func loadImage() {
        // Load local image
        if let image = UIImage(named: photo.imageName) {
            imageView.image = image
        } else {
            // Fallback to emoji if image not found
            imageView.image = nil
            imageView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        }
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func handleTap() {
        // Toggle close button visibility
        UIView.animate(withDuration: 0.3) {
            self.closeButton.alpha = self.closeButton.alpha == 0 ? 1 : 0
        }
    }
}

// MARK: - UIScrollViewDelegate
extension FullScreenPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
