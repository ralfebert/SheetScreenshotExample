@testable import SheetScreenshot
import SnapshotTesting
import SwiftUI
import Testing

@Suite(.snapshots(diffTool: .ksdiff))
struct SheetScreenshotTests {
    @Test func exampleScreenshot() async throws {
        let image = await AppWindowScreen(view: { ContentView() }).updateAndRenderImage()

        assertSnapshot(of: image, as: .image(precision: 0.99))
    }
}
