import SwiftUI
import Testing
import SnapshotTesting
@testable import SheetScreenshot

@Suite(.snapshots(diffTool: .ksdiff))
struct SheetScreenshotTests {

    @Test func exampleScreenshot() async throws {
        let screen = await Task { @MainActor in
            // this is necessary to disable animations for sheets
            UIView.setAnimationsEnabled(false)

            let screen = AppWindowScreen(view: { ContentView() })
            screen.update()
            #warning("Is there a more lightway approach than to render a prep image?")
            let _ = screen.renderImage(size: .init(width: 10, height: 10))
            return screen
        }.value
                
        // Use a second @MainActor task to "flush the main queue" - this makes the sheet reliably visible after a prep image was rendered
        #warning("if multiple tests like this run in parallel we must make sure that we're not interrupted here")
        let image = await Task { @MainActor in
            let image = screen.renderImage()
            screen.tearDown()
            return image
        }.value
        
        assertSnapshot(of: image, as: .image)
    }

}
