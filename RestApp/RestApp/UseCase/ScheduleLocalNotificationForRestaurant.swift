//
//  ScheduleLocalNotificationForRestaurant.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-25.
//

import Foundation

protocol ScheduleLocalNotificationForRestaurant {
  func execute(restaurant: Restaurant, completion: @escaping (Bool) -> Void)
}

final class ScheduleLocalNotificationForRestaurantAdapter: ScheduleLocalNotificationForRestaurant {
  struct Dependencies {
    var notificationService: UserNotificationService = UserNotificationServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute(restaurant: Restaurant, completion: @escaping (Bool) -> Void) {
    dependencies.notificationService.scheduleNotification(for: restaurant, completion: completion)
  }
}
