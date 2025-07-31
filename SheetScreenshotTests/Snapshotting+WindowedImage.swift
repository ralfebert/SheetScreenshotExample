import SwiftUI
import Testing
import SnapshotTesting

extension Snapshotting where Value: UIViewController, Format == UIImage {
    public static func windowedImage(interfaceStyle: UIUserInterfaceStyle = .unspecified,
                                     precision: Float = 0.98,
                                     perceptualPrecision: Float = 1) -> Snapshotting {
        return Snapshotting<UIImage, UIImage>.image(
            precision: precision,
            perceptualPrecision: perceptualPrecision,
            scale: nil
        ).asyncPullback { viewController in
            Async<UIImage> { callback in
                DispatchQueue.main.async {
                    UIView.setAnimationsEnabled(false)
                    let window = UIApplication.shared.windows.first!
                    window.rootViewController = viewController
                    window.windowScene?.traitOverrides.userInterfaceStyle = interfaceStyle
                    DispatchQueue.main.async {
                        let image = UIGraphicsImageRenderer(bounds: window.bounds).image { _ in
                            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
                        }
                        callback(image)
                        UIView.setAnimationsEnabled(true)
                        window.rootViewController = nil
                    }
                }
            }
        }
    }
}
