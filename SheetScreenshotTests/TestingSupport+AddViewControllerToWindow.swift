import UIKit

enum TestingSupport {
    /**
     Extracted from swift-snapshot-testing; when setting the SwiftUI controller to be tested
     directly as rootViewController, it seems to trigger memory management problems; therefore
     an additional UIViewController is put in between.
     */
    static func add(
        viewController: UIViewController, to window: UIWindow
    ) -> () -> Void {
        let rootViewController: UIViewController
        if viewController != window.rootViewController {
            rootViewController = UIViewController()
            rootViewController.view.backgroundColor = .clear
            rootViewController.view.frame = window.frame
            rootViewController.view.translatesAutoresizingMaskIntoConstraints =
                viewController.view.translatesAutoresizingMaskIntoConstraints
            rootViewController.preferredContentSize = rootViewController.view.frame.size
            viewController.view.frame = rootViewController.view.frame
            rootViewController.view.addSubview(viewController.view)
            if viewController.view.translatesAutoresizingMaskIntoConstraints {
                viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            } else {
                NSLayoutConstraint.activate([
                    viewController.view.topAnchor.constraint(equalTo: rootViewController.view.topAnchor),
                    viewController.view.bottomAnchor.constraint(
                        equalTo: rootViewController.view.bottomAnchor),
                    viewController.view.leadingAnchor.constraint(
                        equalTo: rootViewController.view.leadingAnchor),
                    viewController.view.trailingAnchor.constraint(
                        equalTo: rootViewController.view.trailingAnchor),
                ])
            }
            rootViewController.addChild(viewController)
        } else {
            rootViewController = viewController
        }
        // rootViewController.setOverrideTraitCollection(traits, forChild: viewController)
        viewController.didMove(toParent: rootViewController)

        window.rootViewController = rootViewController

        rootViewController.beginAppearanceTransition(true, animated: false)
        rootViewController.endAppearanceTransition()

        rootViewController.view.setNeedsLayout()
        rootViewController.view.layoutIfNeeded()

        viewController.view.setNeedsLayout()
        viewController.view.layoutIfNeeded()

        return {
            rootViewController.beginAppearanceTransition(false, animated: false)
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
            viewController.didMove(toParent: nil)
            rootViewController.endAppearanceTransition()
            window.rootViewController = nil
        }
    }
}
