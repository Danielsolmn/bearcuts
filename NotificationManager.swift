import UIKit
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    // MARK: - Appointment Reminders
    func scheduleAppointmentReminder(for date: Date, appointmentType: String) {
        let content = UNMutableNotificationContent()
        content.title = "🐻 Bear Cuts Reminder"
        content.body = "Your \(appointmentType) appointment is tomorrow at \(formatTime(date))"
        content.sound = .default
        content.badge = 1
        
        // Schedule for 24 hours before
        let reminderDate = date.addingTimeInterval(-24 * 60 * 60)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "appointment-reminder-\(date.timeIntervalSince1970)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        // Also schedule 2-hour reminder
        scheduleTwoHourReminder(for: date, appointmentType: appointmentType)
    }
    
    private func scheduleTwoHourReminder(for date: Date, appointmentType: String) {
        let content = UNMutableNotificationContent()
        content.title = "🐻 Bear Cuts - 2 Hours Left!"
        content.body = "Your \(appointmentType) appointment is in 2 hours. Don't forget!"
        content.sound = .default
        content.badge = 1
        
        let reminderDate = date.addingTimeInterval(-2 * 60 * 60)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "appointment-2hour-\(date.timeIntervalSince1970)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Special Offers
    func scheduleSpecialOfferNotification(title: String, message: String, delay: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "🎉 \(title)"
        content.body = message
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: "special-offer-\(Date().timeIntervalSince1970)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleBirthdayOffer(for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "🎂 Happy Birthday from Bear Cuts!"
        content.body = "Get 20% off your next haircut this month! 🎉"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.month, .day], from: date), repeats: true)
        let request = UNNotificationRequest(identifier: "birthday-offer", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Service Updates
    func scheduleServiceUpdateNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "📢 \(title)"
        content.body = message
        content.sound = .default
        content.badge = 1
        
        // Schedule for immediate delivery
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "service-update-\(Date().timeIntervalSince1970)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleHolidayHoursNotification(holiday: String, hours: String) {
        let content = UNMutableNotificationContent()
        content.title = "🏖️ \(holiday) Hours Update"
        content.body = "Bear Cuts will be open: \(hours)"
        content.sound = .default
        content.badge = 1
        
        // Schedule for 1 day before holiday
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day], from: tomorrow), repeats: false)
        
        let request = UNNotificationRequest(identifier: "holiday-hours-\(holiday)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Helper Methods
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
