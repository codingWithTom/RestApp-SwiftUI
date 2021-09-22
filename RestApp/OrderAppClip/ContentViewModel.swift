//
//  ContentViewModel.swift
//  OrderAppClip
//
//  Created by Tomas Trujillo on 2021-09-20.
//

import Foundation

final class ContentViewModel: ObservableObject {
    @Published var imageName: String = ""
    
    func handle(activity: NSUserActivity) {
        if let webpage = activity.webpageURL {
            imageName = webpage.lastPathComponent
        }
    }
}
