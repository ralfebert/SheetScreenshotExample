import SnapshotTesting
import SwiftUI
import Testing

private var screenshotInProgress = false

/// This class allows rendering multiple screens sequentially, instead of rebuilding a complete View-Tree each time, in order to also test tricky SwiftUI invalidation problems.
/// This also captures the full UIWindow and applies an ugly workaround to be able to render sheets.
@MainActor
class AppWindowScreen<T: View> {
    let controller: UIHostingController<T>
    var dispose: (() -> Void)?
    let view: () -> T
    let window = UIApplication.shared.keyWindow!

    init(@ViewBuilder view: @escaping () -> T, height: Int? = nil) {
        // this is necessary to disable animations for sheets
        UIView.setAnimationsEnabled(false)
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

    private func update() {
        self.controller.rootView = view()
        self.window.setNeedsLayout()
        self.window.layoutIfNeeded()
        self.window.setNeedsDisplay()
        CATransaction.flush()
    }

    private func renderImage(size: CGSize? = nil) -> UIImage {
        self.window.asImage(size: size, drawHierarchy: true)
    }

    func updateAndRenderImage() async -> UIImage {
        // handle re-entrancy, we must not get interrupted while taking a screenshot by another screenshot taking method
        // as this method is @MainActor, a simple flag as lock-replacement should do the trick
        while screenshotInProgress {
            await Task.yield()
        }
        screenshotInProgress = true
        defer { screenshotInProgress = false }

        self.update()
        // this flushes the main queue, because after a yield, it must get to the back of the main queue to run renderImage
        await Task.yield()
        return self.renderImage()
    }

    func tearDown() {
        self.dispose?()
        self.dispose = nil
    }

    @MainActor deinit {
        self.tearDown()
    }
}
