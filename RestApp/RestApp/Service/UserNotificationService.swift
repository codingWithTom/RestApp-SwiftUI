//
//  UserNotificationService.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-24.
//

import Foundation
import UserNotifications
import Combine

protocol UserNotificationService {
  var restaurantNotificationPublisher: AnyPublisher<String, Never> { get }
  func scheduleNotification(for: Restaurant, completion: @escaping (Bool) -> Void)
}

final class UserNotificationServiceAdapter: NSObject, UserNotificationService {
  static let shared = UserNotificationServiceAdapter()
  
  private var passthroughSubject = PassthroughSubject<String, Never>()
  var restaurantNotificationPublisher: AnyPublisher<String, Never> {
    return passthroughSubject.eraseToAnyPublisher()
  }
  
  private override init() {
    super.init()
    UNUserNotificationCenter.current().delegate = self
  }
  
  func scheduleNotification(for restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
    // Check notificaiton permission
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { [weak self] settings in
      if settings.authorizationStatus == .denied {
        completion(false)
      } else if settings.authorizationStatus == .notDetermined {
        // Ask for permission
        self?.requestNotificationAuthorization(for: restaurant, completion: completion)
      } else {
        // Schedule notification
        self?.scheduleLocalNotificationFor(for: restaurant, completion: completion)
      }
      
    }
  }
}

extension UserNotificationServiceAdapter: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.sound, .banner])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    passthroughSubject.send(response.notification.request.identifier)
    completionHandler()
  }
}

private extension UserNotificationServiceAdapter {
  func requestNotificationAuthorization(for restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { [weak self] isPermissionGranted, error in
      guard error == nil else { return }
      if isPermissionGranted {
        self?.scheduleNotification(for: restaurant, completion: completion)
      }
      completion(isPermissionGranted)
    }
  }
  
  func scheduleLocalNotificationFor(for restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = "\(restaurant.name) is open"
    content.body = "Make sure to book a table or visit their website!"
    content.sound = UNNotificationSound(named: UNNotificationSoundName("NotificaitonSound.aiff"))
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: restaurant.restaurantID, content: content, trigger: trigger)
    center.add(request, withCompletionHandler: nil)
    completion(true)
  }
}
