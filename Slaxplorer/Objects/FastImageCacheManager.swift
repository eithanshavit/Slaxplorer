//
//  FastImageCacheManager.swift
//  Slaxplorer
//
//  Created by  Eithan Shavit on 5/22/15.
//  Copyright (c) 2015 Eithan Shavit. All rights reserved.
//
//  Description:
//  FastImageCacheManager class encapsulates FastImageCache functionality and initialization.

import UIKit

class FastImageCacheManager: NSObject {
  
  static let FICFormatNameProfilePhotoFull = "com.eithanshavit.Slaxplorer.FICFormatNameProfilePhotoFull"
  static let FICFormatNameProfilePhotoThumb = "com.eithanshavit.Slaxplorer.FICFormatNameProfilePhotoThumb"
  static let FICFormatFamilyProfilePhotos = "com.eithanshavit.Slaxplorer.FICFormatFamilyPhotos"
  
  static var sharedInstance = FastImageCacheManager()
  
  func setup() {
    
    let photoFullFormat = FICImageFormat(
      name: FastImageCacheManager.FICFormatNameProfilePhotoFull,
      family: FastImageCacheManager.FICFormatNameProfilePhotoThumb,
      imageSize: CGSize(width: 192, height: 192),
      style: .Style32BitBGRA,
      maximumCount: 250,
      devices: .Phone,
      protectionMode: .None
    )
    
    let photoThumbFormat = FICImageFormat(
      name: FastImageCacheManager.FICFormatNameProfilePhotoThumb,
      family: FastImageCacheManager.FICFormatFamilyProfilePhotos,
      imageSize: CGSize(width: 48, height: 48),
      style: .Style32BitBGRA,
      maximumCount: 250,
      devices: .Phone,
      protectionMode: .None
    )
    
    let imageFormats = [photoFullFormat, photoThumbFormat]
    
    let cache = FICImageCache.sharedImageCache()
    cache.setFormats(imageFormats)
    cache.delegate = self
  }
  
}

// MARK: - FastImageCacheDelegate
extension FastImageCacheManager: FICImageCacheDelegate {
  
  func imageCache(imageCache: FICImageCache!, wantsSourceImageForEntity entity: FICEntity!, withFormatName formatName: String!, completionBlock: FICImageRequestCompletionBlock!) {
    let url = entity.sourceImageURLWithFormatName(formatName)
    CloudManager.mainManager.downloadImageWithURL(url) {
      image in
      if let image = image {
        completionBlock(image)
      }
    }
  }
  
  func imageCache(imageCache: FICImageCache!, shouldProcessAllFormatsInFamily formatFamily: String!, forEntity entity: FICEntity!) -> Bool {
    return false
  }
  
}