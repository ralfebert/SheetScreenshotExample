import SwiftUI

public extension UIView {
    func asImage(size: CGSize? = nil, drawHierarchy: Bool = false) -> UIImage {
        let size = size ?? self.bounds.size
        print("UIView#asImage", size)
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            if drawHierarchy {
                self.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
            } else {
                self.layer.render(in: rendererContext.cgContext)
            }
        }
    }
}
