//
//  ActivityController.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-04.
//

import UIKit
import SwiftUI

struct ActivityController: UIViewControllerRepresentable {
  var activityItems: [Any]
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityController>) -> UIActivityViewController {
    return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityController>) {}
}
