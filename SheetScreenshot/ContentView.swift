import SwiftUI

struct ContentView: View {
    var body: some View {
        Color.yellow
            .ignoresSafeArea()
            .sheet(isPresented: .constant(true)) {
                NavigationStack {
                    VStack(spacing: 20) {
                        Button("Screenshot - UIScreen Main") {
                            captureScreenshot()
                        }

                        Button("Screenshot - Key Window") {
                            captureKeyWindow()
                        }

                    }
                    .padding()
                }
                .presentationDetents([.medium, .large])
            }
    }

    func captureScreenshot() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        let renderer = UIGraphicsImageRenderer(size: window.bounds.size)
        let image = renderer.image { _ in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }

        saveImage(image)
    }

    func captureKeyWindow() {
        guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }

        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }

        saveImage(image)
    }

    func saveImage(_ image: UIImage) {
        guard let data = image.pngData() else { return }
        let url = URL(fileURLWithPath: "/tmp/ui_screenshot.png")
        try? data.write(to: url)
        print("Wrote \(url)")
    }
}

#Preview {
    ContentView()
}
