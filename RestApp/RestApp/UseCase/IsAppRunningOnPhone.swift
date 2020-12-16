//
//  IsAppRunningOnPhone.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-15.
//

import UIKit

protocol IsAppRunningOnPhone {
  func execute() -> Bool
}

final class IsAppRunningOnPhoneAdapter: IsAppRunningOnPhone {
  func execute() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
  }
}
