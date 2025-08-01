import Testing
import SnapshotTesting
import SwiftUI

/// This class allows rendering multiple screens sequentially, instead of rebuilding a complete View-Tree each time, in order to also test tricky SwiftUI invalidation problems.
/// This also captures the full UIWindow and applies an ugly workaround to be able to render sheets.
class AppWindowScreen<T: View> {
    let controller: UIHostingController<T>
    var dispose: (() -> Void)?
    let view: () -> T
    let window = UIApplication.shared.keyWindow!

    init(@ViewBuilder view: @escaping () -> T, height: Int? = nil) {        
        self.view = view
        self.controller = UIHostingController(rootView: view())

        var size = UIScreen.main.bounds.size
        if let height {
            size.height = CGFloat(height)
        }

        // The use of TestingSupport.add(viewController:) is a workaround that is necessary because otherwise SwiftUI, after grabbing the test image, sometimes starts doing some AG::Graph-update-related stuff again during the next test.
        self.dispose = TestingSupport.add(viewController: controller, to: window)
        controller.view.bounds = CGRect(origin: .zero, size: size)
    }

    func update() {
        self.controller.rootView = view()
        //self.window.setNeedsDisplay()
        //#warning("Is there a better way to do the main-thread-hop to get the sheet on-screen?")
        //RunLoop.main.run(until: Date.now.addingTimeInterval(0.1))
    }

    @discardableResult func renderImage(size: CGSize? = nil) -> UIImage {
        //self.update()
        return self.window.asImage(size: size, drawHierarchy: true)
    }

    func tearDown() {
        dispose?()
        dispose = nil
    }

    deinit {
        self.tearDown()
    }

}
