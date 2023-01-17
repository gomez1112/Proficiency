//
//  DataController+Extension.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/16/23.
//

import CoreData
import UserNotifications

extension DataController {
    /// Returns a boolean value indicating if the user has earned the given award.
    /// - Parameters:
    ///   - award: The `Award` object to be checked.
    /// - Returns: A boolean value indicating if the user has earned the given award.
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "indicators":
            let fetchRequest: NSFetchRequest<Indicator> = NSFetchRequest(entityName: "Indicator")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "complete":
            let fetchRequest: NSFetchRequest<Indicator> = NSFetchRequest(entityName: "Indicator")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        default:
            return false
        }
    }
    /// Adds reminders for a given outcome by using UNUserNotificationCenter.
    /// - Parameters:
    ///    - outcome: The outcome for which reminders are to be added.
    ///    - completion: A closure that is called when the reminders are added.
    ///    The closure takes a single Bool argument indicating whether the reminders were added successfully or not.
    func addReminders(for outcome: Outcome, completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotifications { success in
                    if success {
                        self.placeReminders(for: outcome, completion: completion)
                    } else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
            case .authorized:
                self.placeReminders(for: outcome, completion: completion)
            default:
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    /// Remove reminders for a given outcome by using UNUserNotificationCenter.
    /// - Parameters:
    ///     - outcome: The outcome for which reminders are to be removed.
    func removeReminders(for outcome: Outcome) {
        let center = UNUserNotificationCenter.current()
        let id = outcome.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    /// Request permission to send notifications to the user
    /// - Parameters:
    ///     - completion: A closure that is called when
    ///     the permission request completes. The closure takes a single Bool argument
    ///     indicating whether the permission was granted or not.
    private func requestNotifications(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }
    /// Place reminders for a given outcome by using UNUserNotificationCenter.
    /// - Parameters:
    ///     - outcome: The outcome for which reminders are to be placed.
    ///     - completion: A closure that is called when the reminders are placed.
    ///     The closure takes a single Bool argument indicating whether the reminders were placed successfully or not.
    private func placeReminders(for outcome: Outcome, completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = outcome.outcomeTitle
        if let outcomeDetail = outcome.detail {
            content.subtitle = outcomeDetail
        }
        let components = Calendar.current.dateComponents([.hour, .minute], from: outcome.reminderTime ?? Date.now)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let id = outcome.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
