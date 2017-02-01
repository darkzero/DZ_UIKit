
// https://github.com/pixel-ink/PIImageCache

import UIKit

public extension URL {
  public func getImageWithCache() -> UIImage? {
    return PIImageCache.shared.get(self)
  }
  
  public func getImageWithCache(_ cache: PIImageCache) -> UIImage? {
    return cache.get(self)
  }
}

public extension UIImageView {
  public func imageOfURL(_ url: URL) {
    PIImageCache.shared.get(url) {
      [weak self] img in
      self?.image = img
    }
  }
  
  public func imageOfURL(_ url: URL, cache: PIImageCache) {
    cache.get(url) {
      [weak self] img in
      self?.image = img
    }
  }
  
  public func imageOfURL(_ url: URL, then:@escaping (Bool)->Void) {
    PIImageCache.shared.get(url) {
      [weak self] img in
      let isOK = img != nil
      self?.image = img
      then(isOK)
    }
  }
  
  public func imageOfURL(_ url: URL, cache: PIImageCache, then:@escaping (Bool)->Void) {
    cache.get(url) {
      [weak self] img in
      let isOK = img != nil
      self?.image = img
      then(isOK)
    }
  }
}
