import SwiftUI

// MARK: LiteSlider+DynamicLengthTrack

extension LiteSlider {

    /// A track view that dynamically fills the available vertical space and renders a thumb view
    /// based on the current drag state and ratio.
    ///
    /// This view reads the height from its container and passes it down to the `Track` view,
    /// allowing the slider to scale flexibly. The thickness of the track is controlled
    /// via the `liteSliderThickness` environment value.
    struct DynamicLengthTrack: View {

        /// The view used to render the slider thumb, if any.
        var thumbView: ThumbViewProvider?

        /// The ratio of the current drag position (0.0 to 1.0).
        @Binding var dragRatio: CGFloat

        /// Whether the slider is currently being dragged.
        @Binding var isDragging: Bool

        /// The track thickness, injected via environment.
        @Environment(\.liteSliderThickness) private var thickness

        var body: some View {
            GeometryReader { geometry in
                Track(
                    length: geometry.size.height,
                    thumbViewProvider: thumbView,
                    dragRatio: $dragRatio,
                    isDragging: $isDragging,
                    onStartDragging: nil
                )
            }
            .frame(width: thickness)
        }
    }
}
