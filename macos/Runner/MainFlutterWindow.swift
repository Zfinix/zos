import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    var windowFrame = self.frame
    
    self.minSize = NSSize(width: 1250, height: 770)
    windowFrame.size = NSSize(width: 1250, height: 770)
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
     

    RegisterGeneratedPlugins(registry: flutterViewController)
    
    DropTarget.attach(to: flutterViewController)
    
    super.awakeFromNib()
  }
    
  var dropTarget: DropTarget!
}

class DropTarget: NSView {
    static func attach(to flutterViewController: FlutterViewController) {
        let n = "zos"
        let r = flutterViewController.registrar(forPlugin: n)
        let channel = FlutterMethodChannel(name: n, binaryMessenger: r.messenger)
        
        let d = DropTarget(frame: flutterViewController.view.bounds, channel: channel)
        d.autoresizingMask = [.width, .height]
        d.registerForDraggedTypes([.fileURL])
        flutterViewController.view.addSubview(d)
    }
    
    private let channel: FlutterMethodChannel
    
    init(frame: NSRect, channel: FlutterMethodChannel) {
        self.channel = channel
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        channel.invokeMethod("entered", arguments: nil)
        return .copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        channel.invokeMethod("exited", arguments: nil)
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        let location = sender.draggingLocation
        channel.invokeMethod("updated", arguments: [location.x, bounds.height - location.y])
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        var urls = [String]()
        if let items = sender.draggingPasteboard.pasteboardItems {
            for item in items {
                if let alias = item.string(forType: .fileURL) {
                    urls.append(URL(fileURLWithPath: alias).standardized.absoluteString)
                }
                if let x = item.string(forType: .URL) {
                    print("***", x)
                }
            }
        }
        channel.invokeMethod("dropped", arguments: urls)
        print("->", urls)
        return true
    }
}
