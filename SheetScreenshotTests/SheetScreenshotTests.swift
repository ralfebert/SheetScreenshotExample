import SwiftUI
import Testing
import SnapshotTesting
@testable import SheetScreenshot

@MainActor
@Suite(.snapshots(diffTool: .ksdiff), .serialized)
struct SheetScreenshotTests {

    @Test func exampleScreenshot() async throws {
        assertSnapshot(of: AppWindowScreen(view: { ContentView() }).renderImage(), as: .image)
    }

}
