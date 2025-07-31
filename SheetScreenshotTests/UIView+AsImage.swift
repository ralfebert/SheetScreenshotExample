import SwiftUI

public extension UIView {
    func asImage(drawHierarchy: Bool = false) -> UIImage {
        UIGraphicsImageRenderer(bounds: bounds).image { rendererContext in
            if drawHierarchy {
                self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            } else {
                self.layer.render(in: rendererContext.cgContext)
            }
        }
    }
}
