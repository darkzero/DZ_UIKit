
// https://github.com/pixel-ink/PIImageCache

import UIKit

open class PIImageCache {
  
  //initialize
  
  fileprivate func myInit() {
    folderCreate()
    prefetchQueueInit()
  }
  
  public init() {
    myInit()
  }
  
  public init(config: Config) {
    let _ = memorySemaphore.wait(timeout: DispatchTime.distantFuture)
    self.config = config
    memorySemaphore.signal()
    myInit()
  }
  
  open class var shared: PIImageCache {
    struct Static {
      static let instance: PIImageCache = PIImageCache()
    }
    Static.instance.myInit()
    return Static.instance
  }
  
  //public config method
  
  open class Config {
    open var maxMemorySum           : Int    = 10 // 10 images
    open var limitByteSize          : Int    = 3 * 1024 * 1024 //3MB
    open var usingDiskCache         : Bool   = true
    open var diskCacheExpireMinutes : Int    = 24 * 60 // 1 day
    open var prefetchOprationCount  : Int    = 5
    open var cacheRootDirectory     : String = NSTemporaryDirectory()
    open var cacheFolderName        : String = "PIImageCache"
  }
  
  open func setConfig(_ config :Config) {
    let _ = memorySemaphore.wait(timeout: DispatchTime.distantFuture)
    self.config = config
    myInit()
    memorySemaphore.signal()
  }
  
  //public download method
  
  open func get(_ url: URL) -> UIImage? {
    return perform(url).0
  }
  
  open func get(_ url: URL, then: @escaping (_ image:UIImage?) -> Void) {
    DispatchQueue.global().async {
      [weak self] in
      let image = self?.get(url)
      DispatchQueue.main.async {
        then(image)
      }
    }
  }

  open func getWithId(_ url: URL, id: Int, then: @escaping (_ id: Int, _ image: UIImage?) -> Void) {
    DispatchQueue.global().async {
      [weak self] in
      let image = self?.get(url)
      DispatchQueue.main.async {
        then(id, image)
      }
    }
  }
  
  open func prefetch(_ urls: [URL]) {
    for url in urls {
      prefetch(url)
    }
  }
  
  open func prefetch(_ url: URL) {
    let op = Operation();
    op.completionBlock = {
      [weak self] in
      self?.downloadToDisk(url)
    }
    prefetchQueue.addOperation(op)
  }
  
  //public delete method
  
  open func allMemoryCacheDelete() {
    let _ = memorySemaphore.wait(timeout: DispatchTime.distantFuture)
    memoryCache.removeAll(keepingCapacity: false)
    memorySemaphore.signal()
  }
  
    open func allDiskCacheDelete() {
        let path = PIImageCache.folderPath(config)
        let _ = diskSemaphore.wait(timeout: DispatchTime.distantFuture);
        do {
            let allFileName: [String]? = try fileManager.contentsOfDirectory(atPath: path);
            if allFileName != nil {
                for fileName in allFileName! {
                    try fileManager.removeItem(atPath: path + fileName);
                }
            }
        }
        catch {
            
        }
        folderCreate()
        diskSemaphore.signal()
    }
  
    open func oldDiskCacheDelete() {
        let path = PIImageCache.folderPath(config)
        let _ = diskSemaphore.wait(timeout: DispatchTime.distantFuture);
        do {
            let allFileName: [String]? = try fileManager.contentsOfDirectory(atPath: path);
            if allFileName != nil {
                for fileName in allFileName! {
                    if let attr: [FileAttributeKey: Any]? = try fileManager.attributesOfItem(atPath: path + fileName) {
                        if ( attr != nil ) {
                            let diff = Date().timeIntervalSince( (attr![FileAttributeKey.modificationDate] as? Date) ?? Date() )
                            if Double(diff) > Double(config.diskCacheExpireMinutes * 60) {
                                try fileManager.removeItem(atPath: path + fileName);
                            }
                        }
                    }
                }
            }
        }
        catch {
            
        }
        folderCreate()
        diskSemaphore.signal()
    }
  
  //member
  
  fileprivate var config: Config = Config()
  fileprivate var memoryCache : [memoryCacheImage] = []
  fileprivate var memorySemaphore = DispatchSemaphore(value: 1)
  fileprivate var diskSemaphore = DispatchSemaphore(value: 1)
  fileprivate let fileManager = FileManager.default
  fileprivate let prefetchQueue = OperationQueue()
  
  fileprivate struct memoryCacheImage {
    let image     :UIImage
    var timeStamp :Double
    let url       :URL
  }
  
  // memory cache
  
  fileprivate func memoryCacheRead(_ url: URL) -> UIImage? {
    for i in 0 ..< memoryCache.count {
      if url == memoryCache[i].url {
        memoryCache[i].timeStamp = now
        return memoryCache[i].image
      }
    }
    return nil
  }
  
  fileprivate func memoryCacheWrite(_ url:URL,image:UIImage) {
    switch memoryCache.count {
    case 0 ... config.maxMemorySum:
      memoryCache.append(memoryCacheImage(image: image, timeStamp: now, url: url))
    case config.maxMemorySum + 1:
      var old = (0,now)
      for i in 0 ..< memoryCache.count {
        if old.1 < memoryCache[i].timeStamp {
          old = (i,memoryCache[i].timeStamp)
        }
      }
      memoryCache.remove(at: old.0)
      memoryCache.append(memoryCacheImage(image: image, timeStamp:now, url: url))
    default://case: over the limit. because, limit can chenge in runtime.
      for _ in 0 ... 1 {//release cache slowly.
        var old = (0,now)
        for i in 0 ..< memoryCache.count {
          if old.1 < memoryCache[i].timeStamp {
            old = (i,memoryCache[i].timeStamp)
          }
        }
        memoryCache.remove(at: old.0)
      }
      memoryCache.append(memoryCacheImage(image: image, timeStamp:now, url: url))
    }
  }
  
  //disk cache
  
  
  fileprivate func diskCacheRead(_ url: URL) -> UIImage? {
    if let path = PIImageCache.filePath(url, config: config) {
      return UIImage(contentsOfFile: path)
    }
    return nil
  }
  
  fileprivate func diskCacheWrite(_ url:URL,image:UIImage) {
    if let path = PIImageCache.filePath(url, config: config) {
      try? (NSData(data: UIImagePNGRepresentation(image)!) as Data).write(to: URL(fileURLWithPath: path), options: [.atomic])
    }
  }
  
  //private download
  
  internal enum Result {
    case mishit, memoryHit, diskHit
  }
  
  internal func download(_ url: URL) -> (UIImage, byteSize: Int)? {
    var maybeImageData: Data?;
    do {
        maybeImageData = try Data(contentsOf: url, options: .uncachedRead);
    }
    catch {
        DebugLog("get image data error!!" as AnyObject);
    }
    if let imageData = maybeImageData {
      if let image = UIImage(data: imageData) {
        let bytes = imageData.count
        return (image, bytes)
      }
    }
    return nil
  }
  
  internal func perform(_ url: URL) -> (UIImage?, Result) {
    
    //memory read
    let _ = memorySemaphore.wait(timeout: DispatchTime.distantFuture)
    let maybeMemoryCache = memoryCacheRead(url)
    memorySemaphore.signal()
    if let cache = maybeMemoryCache {
      return (cache, .memoryHit)
    }
    
    //disk read
    if config.usingDiskCache {
      let _ = diskSemaphore.wait(timeout: DispatchTime.distantFuture)
      let maybeDiskCache = diskCacheRead(url)
      diskSemaphore.signal()
      if let cache = maybeDiskCache {
        let _ = memorySemaphore.wait(timeout: DispatchTime.distantFuture)
        memoryCacheWrite(url, image: cache)
        memorySemaphore.signal()
        return (cache, .diskHit)
      }
    }
    
    //download
    let maybeImage = download(url)
    if let (image, byteSize) = maybeImage {
      if byteSize < config.limitByteSize {
        //write memory
        let _ = memorySemaphore.wait(timeout: DispatchTime.distantFuture)
        memoryCacheWrite(url, image: image)
        memorySemaphore.signal()
        //write disk
        if config.usingDiskCache {
            DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            [weak self] in
            if let scope = self {
              let _ = scope.diskSemaphore.wait(timeout: DispatchTime.distantFuture)
              scope.diskCacheWrite(url, image: image)
              scope.diskSemaphore.signal()
            }
          }
        }
      }
    }
    return (maybeImage?.0, .mishit)
  }
  
  fileprivate func downloadToDisk(_ url: URL) {
    let path = PIImageCache.filePath(url, config: config)
    if path == nil { return }
    if fileManager.fileExists(atPath: path!) { return }
    let maybeImage = download(url)
    if let (image, byteSize) = maybeImage {
      if byteSize < config.limitByteSize {
        let _ = diskSemaphore.wait(timeout: DispatchTime.distantFuture)
        diskCacheWrite(url, image: image)
        diskSemaphore.signal()
      }
    }
  }
  
    //MARK: - util
  
    fileprivate var now: Double {
        get {
            return Date().timeIntervalSince1970
        }
    }
  
  fileprivate func folderCreate() {
    let path = "\(config.cacheRootDirectory)\(config.cacheFolderName)/"
    do {
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil);
    }
    catch {
        DebugLog("[PIImageCache] folderCreate error!!" as AnyObject);
    }
  }
  

    fileprivate class func filePath(_ url: URL, config:Config) -> String? {
        let urlstr = url.absoluteString;
        var code = ""
        for char in urlstr.utf8 {
            code = code + "u\(char)"
        }
        return "\(config.cacheRootDirectory)\(config.cacheFolderName)/\(code)";
    }
  
  fileprivate class func folderPath(_ config: Config) -> String {
    return "\(config.cacheRootDirectory)\(config.cacheFolderName)/"
  }
  
  fileprivate func prefetchQueueInit(){
    prefetchQueue.maxConcurrentOperationCount = config.prefetchOprationCount
    prefetchQueue.qualityOfService = QualityOfService.background
  }
  
}
