@testable import SheetScreenshot
import SnapshotTesting
import SwiftUI
import Testing

@Suite(.snapshots(diffTool: .ksdiff))
struct SheetScreenshotTests {
    @Test func exampleScreenshot() async throws {
        let screen = await AppWindowScreen(view: { ContentView() })
        let image = await screen.updateAndRenderImage()

        assertSnapshot(of: image, as: .image(precision: 0.99))
        
        await screen.tearDown()
    }
}
