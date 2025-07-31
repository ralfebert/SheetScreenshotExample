//

import SwiftUI

@main
struct SheetScreenshotApp: App {
    var body: some Scene {
        WindowGroup {
            if Env.isUnitTest {
                Text("Unit Test")
            } else {
                ContentView()
            }
        }
    }
}
