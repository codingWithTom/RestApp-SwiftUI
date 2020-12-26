//
//  NotificationSettingsAlertModifier.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-25.
//

import SwiftUI

struct NotificationSettingsAlertModifier: ViewModifier {
  @Binding var isPresented: Bool
  
  func body(content: Content) -> some View {
      content
        .alert(isPresented: $isPresented, content: {
          Alert(title: Text("Notifications are currently disabled"),
                message: Text("To get notified when this establishment opens, please go to your settings and enable notifications."),
                primaryButton: .default(Text("Go to Settings"), action: { self.openSettings() }),
                secondaryButton: .cancel())
        })
  }
  
  func openSettings() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
  }
}
