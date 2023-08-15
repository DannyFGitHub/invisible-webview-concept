import Cocoa
import WebKit

class MainApplication: NSApplication {

}


class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Set the background color to clear (transparent)
        window?.backgroundColor = NSColor.clear

        // Set the window to non-opaque
        window?.isOpaque = false
        
        // Remove the title
        window?.titleVisibility = .hidden

        // Remove the title bar
        window?.titlebarAppearsTransparent = true

        // Remove the border
        window?.styleMask.remove(NSWindow.StyleMask.titled)

        // Prevent restoring to last known position before restart
        window?.isRestorable = false

        // Make the window the frontmost window
        window?.makeKeyAndOrderFront(nil)
        
        // Wrap the existing content view with the custom view that allows dragging
        if let existingContentView = window?.contentView {
            window?.contentView = DraggableTransparentView(existingView: existingContentView)
        }
    }
}

class DraggableTransparentView: NSView {
    
    init(existingView: NSView) {
        super.init(frame: existingView.bounds)
        self.addSubview(existingView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    override func mouseDown(with event: NSEvent) {
        let location = self.convert(event.locationInWindow, from: nil)
        let dragAreaSize: CGFloat = 100.0

        // Check if the click is within the bottom right 100px x 100px area
        if location.x > (self.bounds.width - dragAreaSize) && location.y < dragAreaSize {
            window?.performDrag(with: event)
        }
    }
}



class ViewController: NSViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if let url = URL(string: "http://127.0.0.1:3000/") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        
        // Set the background color of the view to transparent
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.clear.cgColor

        // Set the background color of the web view to transparent
        webView.setValue(false, forKey: "drawsBackground")

        // Set the window background to transparent
        self.view.window?.backgroundColor = NSColor.clear
        self.view.window?.isOpaque = false
    }
    
    // Function to inject JavaScript
    func injectJavaScript() {
        let javascript = "alert('Injected JavaScript!');"
        
        webView.evaluateJavaScript(javascript) { (result, error) in
            if let error = error {
                print("Error injecting JavaScript: \(error)")
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      webView.evaluateJavaScript("getContentSize()") { (result, error) in
        if let size = result as? [String: CGFloat],
           let width = size["width"],
           let height = size["height"] {
          let newSize = CGSize(width: width, height: height)
          self.view.window?.setContentSize(newSize)
            
            
            // Get the primary screen size and visible frame
            guard let screen = NSScreen.main?.visibleFrame else { return }

            // Set the window's size and position
            let windowSize = self.view.window?.frame.size ?? CGSize(width: 0, height: 0) // Provide a default size if needed
            let xPosition = screen.origin.x + screen.width - windowSize.width
            let yPosition = screen.origin.y // + screen.height - windowSize.height
            self.view.window?.setFrame(NSRect(x: xPosition, y: yPosition, width: windowSize.width, height: windowSize.height), display: true)
        }
      }

      // Inject JavaScript after the page has finished loading
      injectJavaScript()
    }
}
