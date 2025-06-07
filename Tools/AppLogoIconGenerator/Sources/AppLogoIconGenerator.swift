import SwiftUI
import Foundation
#if canImport(AppKit)
import AppKit
#endif

@available(macOS 11.0, *)
@main
struct AppLogoIconGenerator {
    static func main() {
        // List of required iOS icon sizes and filenames
        let iconSpecs: [(size: CGFloat, filename: String)] = [
            (20, "Icon-20.png"),
            (40, "Icon-20@2x.png"),
            (60, "Icon-20@3x.png"),
            (29, "Icon-29.png"),
            (58, "Icon-29@2x.png"),
            (87, "Icon-29@3x.png"),
            (40, "Icon-40.png"),
            (80, "Icon-40@2x.png"),
            (120, "Icon-40@3x.png"),
            (120, "Icon-60@2x.png"),
            (180, "Icon-60@3x.png"),
            (76, "Icon-76.png"),
            (152, "Icon-76@2x.png"),
            (167, "Icon-83.5@2x.png"),
            (1024, "Icon-1024.png")
        ]
        let defaultOutputDir = "Resources/BertCam/Assets.xcassets/AppIcon.appiconset"
        #if canImport(AppKit)
        let outputDir: String
        if CommandLine.arguments.count > 1 {
            outputDir = CommandLine.arguments[1]
        } else {
            outputDir = defaultOutputDir
        }
        let fileManager = FileManager.default
        try? fileManager.createDirectory(atPath: outputDir, withIntermediateDirectories: true, attributes: nil)

        func renderView<V: View>(view: V, size: CGFloat) -> NSImage {
            let hostingView = NSHostingView(rootView: view.frame(width: size, height: size))
            hostingView.frame = NSRect(x: 0, y: 0, width: size, height: size)
            let rep = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds)!
            hostingView.cacheDisplay(in: hostingView.bounds, to: rep)
            let image = NSImage(size: NSSize(width: size, height: size))
            image.addRepresentation(rep)
            return image
        }

        func savePNG(image: NSImage, to url: URL) {
            guard let tiffData = image.tiffRepresentation,
                  let bitmap = NSBitmapImageRep(data: tiffData),
                  let pngData = bitmap.representation(using: .png, properties: [:]) else {
                print("Failed to create PNG data for \(url.lastPathComponent)")
                return
            }
            do {
                try pngData.write(to: url)
                print("Saved \(url.lastPathComponent)")
            } catch {
                print("Failed to save \(url.lastPathComponent): \(error)")
            }
        }

        for spec in iconSpecs {
            let image = renderView(view: AppLogo(), size: spec.size)
            let url = URL(fileURLWithPath: outputDir).appendingPathComponent(spec.filename)
            savePNG(image: image, to: url)
        }
        print("All icons generated in \(outputDir)")
        #else
        print("This tool currently only supports macOS (AppKit) 11.0 or newer")
        #endif
    }
} 