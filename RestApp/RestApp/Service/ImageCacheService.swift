//
//  ImageCacheService.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-17.
//

import UIKit

protocol ImageCacheService {
  func getImage(from: String, completion: @escaping (UIImage?) -> Void)
}

final class ImageCacheServiceAdapter: ImageCacheService {
  static let shared = ImageCacheServiceAdapter()
  
  private lazy var imageDownloadQueue = DispatchQueue(label: "com.CodingWithTom.RestApp.ImageDownloadQueue", qos: .userInitiated)
  private var imageDirURL: URL {
    let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "images", relativeTo: cacheURL)
  }
  private let domainImagePath = "http://localhost:3000/images"
  
  private init() {
    createDirectory()
  }
  
  func getImage(from url: String, completion: @escaping (UIImage?) -> Void) {
    if let image = fetchLocalImage(for: url) {
      completion(image)
    } else {
      imageDownloadQueue.async { [weak self] in
        guard
          let self = self,
          let imageURL = URL(string: "\(self.domainImagePath)/\(url)"),
          let imageData = try? Data(contentsOf: imageURL)
        else {
          completion(nil)
          return
        }
        do {
          try imageData.write(to: URL(fileURLWithPath: url, relativeTo: self.imageDirURL))
        } catch {
          print("Error saving image \(error)")
        }
        DispatchQueue(label: "RandomQueue").asyncAfter(deadline: .now() + 3.0) {
          completion(UIImage(data: imageData))
        }
      }
    }
  }
}

private extension ImageCacheServiceAdapter {
  func createDirectory() {
    do {
      try FileManager.default.createDirectory(at: imageDirURL, withIntermediateDirectories: true, attributes: nil)
    } catch { }
  }
  
  func fetchLocalImage(for url: String) -> UIImage? {
    let localImageURL = URL(fileURLWithPath: url, relativeTo: imageDirURL)
    guard let imageData = try? Data(contentsOf: localImageURL) else { return nil }
    return UIImage(data: imageData)
  }
}
