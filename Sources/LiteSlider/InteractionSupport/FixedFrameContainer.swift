import SwiftUI

/// A container view that overlays its content on a transparent rectangle,
/// allowing for alignment control and optional fixed size.
struct FixedFrameContainer<Content: View>: View {
    private let size: CGSize?
    private let alignment: Alignment
    private let content: () -> Content

    /// Creates a fixed frame container with optional size and alignment.
    /// - Parameters:
    ///   - size: Fixed size (width and height) for the container.
    ///   - alignment: Alignment for the overlaid content. Defaults to
    ///   `.center`.
    ///   - content: The content view builder.
    init(
        size: CGSize,
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = size
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .overlay(alignment: alignment) { content() }
            .frame(width: size?.width, height: size?.height)
    }
}
