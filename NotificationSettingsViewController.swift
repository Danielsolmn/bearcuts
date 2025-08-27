import UIKit
import UserNotifications
import ObjectiveC

// MARK: - App Reminder Structure
struct AppReminder: Codable {
    let id: String
    let title: String
    let date: Date
    let type: String
    let createdAt: Date // When the reminder was created
    var isSeen: Bool // Track if user has seen this reminder
}

class NotificationSettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let calendarView = UIDatePicker()
    private let reminderTypeSegmentedControl = UISegmentedControl(items: ["Hair Styles"])
    private let reminderTimeLabel = UILabel()
    private let reminderTimeSegmentedControl = UISegmentedControl(items: ["5 min", "15 min", "30 min", "1 hour", "2 hours"])
    private let addReminderButton = UIButton(type: .system)
    private let reminderListLabel = UILabel()
    private let reminderTableView = UITableView()
    
    // Background Logo View
    private let backgroundLogoView = BackgroundLogoView()
    
    // Data - Store reminders internally in the app
    private var reminders: [AppReminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        loadReminders()
        requestNotificationPermission()
        setupNotificationListeners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Don't automatically mark all reminders as seen
        // Only specific reminders get marked when coming from notifications
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Notification Settings"
        
        // Background Logo
        view.addSubview(backgroundLogoView)
        view.sendSubviewToBack(backgroundLogoView)
        
        // Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Content View
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Title Label
        titleLabel.text = "Set Reminders & Notifications"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Calendar View
        calendarView.datePickerMode = .dateAndTime
        calendarView.preferredDatePickerStyle = .wheels
        calendarView.minimumDate = Date()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(calendarView)
        
        // Reminder Type Segmented Control
        reminderTypeSegmentedControl.selectedSegmentIndex = 0
        reminderTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reminderTypeSegmentedControl)
        
        // Reminder Time Label
        reminderTimeLabel.text = "Remind me:"
        reminderTimeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        reminderTimeLabel.textColor = UIColor.black
        reminderTimeLabel.textAlignment = .center
        reminderTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reminderTimeLabel)
        
        // Reminder Time Segmented Control
        reminderTimeSegmentedControl.selectedSegmentIndex = 1 // Default to 15 min
        reminderTimeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reminderTimeSegmentedControl)
        
        // Add Reminder Button
        addReminderButton.setTitle("➕ Add Reminder", for: .normal)
        addReminderButton.backgroundColor = UIColor.purple.withAlphaComponent(0.2) // Very light purple
        addReminderButton.setTitleColor(UIColor.purple, for: .normal) // Purple text for contrast
        addReminderButton.layer.cornerRadius = 12
        addReminderButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        addReminderButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addReminderButton)
        

        
        // Reminder List Label
        reminderListLabel.text = "Your Hair Style Appointments:"
        reminderListLabel.font = UIFont.boldSystemFont(ofSize: 18)
        reminderListLabel.textColor = UIColor.black
        reminderListLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reminderListLabel)
        
        // Reminder Table View
        reminderTableView.delegate = self
        reminderTableView.dataSource = self
        reminderTableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: "ReminderCell")
        reminderTableView.backgroundColor = UIColor.clear
        reminderTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reminderTableView)
        

    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        backgroundLogoView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Background Logo
            backgroundLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundLogoView.widthAnchor.constraint(equalToConstant: 400),
            backgroundLogoView.heightAnchor.constraint(equalToConstant: 400),
            
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
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Calendar View
            calendarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            calendarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            calendarView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            
            // Reminder Type Segmented Control
            reminderTypeSegmentedControl.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20),
            reminderTypeSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reminderTypeSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Reminder Time Label
            reminderTimeLabel.topAnchor.constraint(equalTo: reminderTypeSegmentedControl.bottomAnchor, constant: 20),
            reminderTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reminderTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Reminder Time Segmented Control
            reminderTimeSegmentedControl.topAnchor.constraint(equalTo: reminderTimeLabel.bottomAnchor, constant: 10),
            reminderTimeSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reminderTimeSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Add Reminder Button
            addReminderButton.topAnchor.constraint(equalTo: reminderTimeSegmentedControl.bottomAnchor, constant: 20),
            addReminderButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addReminderButton.widthAnchor.constraint(equalToConstant: 200),
            addReminderButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Reminder List Label
            reminderListLabel.topAnchor.constraint(equalTo: addReminderButton.bottomAnchor, constant: 30),
            reminderListLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Reminder Table View
            reminderTableView.topAnchor.constraint(equalTo: reminderListLabel.bottomAnchor, constant: 10),
            reminderTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reminderTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            reminderTableView.heightAnchor.constraint(equalToConstant: 200),
            
            // Bottom constraint for content view
            reminderTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Content View Height (for scrolling)
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
    }
    
    // MARK: - Actions
    private func setupActions() {
        addReminderButton.addTarget(self, action: #selector(addReminderTapped), for: .touchUpInside)
    }
    
    // MARK: - App-Only Reminder System
    private func loadReminders() {
        // Load reminders from UserDefaults (app-only storage)
        if let data = UserDefaults.standard.data(forKey: "BearCutsReminders"),
           let savedReminders = try? JSONDecoder().decode([AppReminder].self, from: data) {
            self.reminders = savedReminders
            sortReminders()
        } else {
            // If no reminders exist, start with empty array
            self.reminders = []
        }
        
        reminderTableView.reloadData()
    }
    
    private func saveReminders() {
        // Save reminders to UserDefaults (app-only storage)
        if let data = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(data, forKey: "BearCutsReminders")
        }
    }
    
    // MARK: - Mark Reminder as Seen
    func markReminderAsSeen(reminderId: String) {
        if let index = reminders.firstIndex(where: { $0.id == reminderId }) {
            reminders[index].isSeen = true
            saveReminders()
            
            // Resort reminders so seen ones move to bottom
            sortReminders()
            reminderTableView.reloadData()
        }
    }
    
    // MARK: - Helper Functions
    private func sortReminders() {
        reminders.sort { reminder1, reminder2 in
            if reminder1.isSeen == reminder2.isSeen {
                // If both have same seen status, sort by date (newest first)
                return reminder1.date > reminder2.date
            } else {
                // Unseen reminders come first
                return !reminder1.isSeen
            }
        }
    }
    
    // MARK: - Notification Listeners
    private func setupNotificationListeners() {
        // Listen for when reminders should be marked as seen
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMarkReminderAsSeen),
            name: NSNotification.Name("MarkReminderAsSeen"),
            object: nil
        )
    }
    
    @objc private func handleMarkReminderAsSeen(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let reminderId = userInfo["reminderId"] as? String {
            // Add delay to prevent rapid processing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.markReminderAsSeen(reminderId: reminderId)
            }
        }
    }
    
    // Function removed - no longer marking all reminders as seen automatically
    
    // MARK: - Button Actions
    @objc private func addReminderTapped() {
        // Prevent rapid tapping
        addReminderButton.isEnabled = false
        
        let selectedDate = calendarView.date
        
        // Create app-only reminder
        let newReminder = AppReminder(
            id: UUID().uuidString,
            title: "Bear Cuts - Hair Styles",
            date: selectedDate,
            type: "Hair Styles",
            createdAt: Date(), // Current timestamp when reminder is created
            isSeen: false // New reminders start as unseen
        )
        
        reminders.append(newReminder)
        saveReminders()
        reminderTableView.reloadData()
        
        // Schedule local notification with delay to prevent rate limiting
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scheduleLocalNotification(for: selectedDate, type: "Hair Styles", reminderId: newReminder.id)
        }
        
        // Show success message and re-enable button
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showSuccessAlert(message: "Reminder added for \(self.formatDate(selectedDate))")
            self.addReminderButton.isEnabled = true
        }
    }
    

    

    

    

    

    
    // MARK: - Helper Methods
    
    private func scheduleLocalNotification(for date: Date, type: String, reminderId: String) {
        let content = UNMutableNotificationContent()
        content.title = "🐻 Bear Cuts Reminder"
        content.body = "Your \(type) appointment is coming up at \(formatTime(date))!"
        content.sound = .default
        content.badge = 1
        
        // Add user info for when notification is tapped
        content.userInfo = [
            "reminderId": reminderId,
            "appointmentDate": date.timeIntervalSince1970,
            "appointmentType": type
        ]
        
        // Get the selected reminder time
        let selectedTimeIndex = reminderTimeSegmentedControl.selectedSegmentIndex
        let reminderMinutes: Int
        
        switch selectedTimeIndex {
        case 0: // 5 min
            reminderMinutes = 5
        case 1: // 15 min
            reminderMinutes = 15
        case 2: // 30 min
            reminderMinutes = 30
        case 3: // 1 hour
            reminderMinutes = 60
        case 4: // 2 hours
            reminderMinutes = 120
        default:
            reminderMinutes = 15
        }
        
        // Schedule for the selected time before appointment
        let triggerDate = date.addingTimeInterval(-TimeInterval(reminderMinutes * 60))
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: reminderId, content: content, trigger: trigger)
        
        // Add the notification and handle any errors
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Notification Error", message: "Could not schedule reminder notification: \(error.localizedDescription)")
                }
            } else {
                print("Notification scheduled successfully for \(date) (will notify at \(triggerDate))")
                // No more success alert
            }
        }
    }
    
    private func requestNotificationPermission(completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    completion?(true)
                } else {
                    self.showNotificationPermissionAlert()
                    completion?(false)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatDateAndTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d at h:mm a" // e.g., "Aug 24 at 7:19 PM"
        return formatter.string(from: date)
    }
    

    
    // MARK: - Alerts
    
    private func showNotificationPermissionAlert() {
        let alert = UIAlertController(title: "Notification Permission Required", message: "Please allow Bear Cuts to send notifications in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Custom Reminder Cell
class ReminderTableViewCell: UITableViewCell {
    let statusCircle = UIView()
    let reminderLabel = UILabel()
    let createdLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        // Status Circle
        statusCircle.layer.cornerRadius = 8
        statusCircle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusCircle)
        
        // Reminder Label
        reminderLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        reminderLabel.textColor = UIColor.black
        reminderLabel.numberOfLines = 0
        reminderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reminderLabel)
        
        // Created Label
        createdLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        createdLabel.textColor = UIColor.darkGray
        createdLabel.numberOfLines = 0
        createdLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(createdLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            statusCircle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusCircle.widthAnchor.constraint(equalToConstant: 16),
            statusCircle.heightAnchor.constraint(equalToConstant: 16),
            
            reminderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            reminderLabel.leadingAnchor.constraint(equalTo: statusCircle.trailingAnchor, constant: 12),
            reminderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            createdLabel.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor, constant: 4),
            createdLabel.leadingAnchor.constraint(equalTo: reminderLabel.leadingAnchor),
            createdLabel.trailingAnchor.constraint(equalTo: reminderLabel.trailingAnchor),
            createdLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with reminder: AppReminder) {
        // Set reminder text (no status icon needed since we have the circle)
        reminderLabel.text = "Bear Cuts Appointment on \(formatDateAndTime(reminder.date))"
        createdLabel.text = "Created: \(formatDate(reminder.createdAt))"
        
        // Configure status circle
        if reminder.isSeen {
            // Light purple filled circle when seen
            statusCircle.backgroundColor = UIColor.purple.withAlphaComponent(0.3) // Very light purple
            statusCircle.layer.borderWidth = 0
            
            // Make the whole line less opacity when seen
            reminderLabel.alpha = 0.6
            createdLabel.alpha = 0.6
            statusCircle.alpha = 0.6
        } else {
            // Unfilled circle (transparent with light purple border) when unseen
            statusCircle.backgroundColor = UIColor.clear
            statusCircle.layer.borderWidth = 2
            statusCircle.layer.borderColor = UIColor.purple.withAlphaComponent(0.4).cgColor // Light purple border
            
            // Full opacity when unseen
            reminderLabel.alpha = 1.0
            createdLabel.alpha = 1.0
            statusCircle.alpha = 1.0
        }
    }
    
    private func formatDateAndTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d at h:mm a"
        return formatter.string(from: date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension NotificationSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderTableViewCell
        let reminder = reminders[indexPath.row]
        
        cell.configure(with: reminder)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Cancel the notification for this reminder
            let reminder = reminders[indexPath.row]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id])
            
            // Remove from app storage
            reminders.remove(at: indexPath.row)
            saveReminders()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
