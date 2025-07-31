import SwiftUI
import Testing
import SnapshotTesting
@testable import SheetScreenshot

@Suite(.snapshots(diffTool: .ksdiff), .serialized)
struct SheetScreenshotTests {

    @Test func exampleScreenshot() async throws {
        assertSnapshot(of: UIHostingController(rootView: ContentView()), as: .windowedImage())
    }

}
