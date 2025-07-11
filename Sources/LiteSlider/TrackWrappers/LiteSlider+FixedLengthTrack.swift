import SwiftUI

// MARK: - LiteSlider+FixedLengthTrack

extension LiteSlider {

    /// A track view with a fixed height, used when the thumb is not expanding.
    ///
    /// This view displays the track at a constant length, and positions the
    /// thumb according to the current drag ratio.
    struct FixedLengthTrack: View {

        /// The vertical length of the track.
        var length: CGFloat

        /// An optional view provider for the thumb content.
        var thumbView: ThumbViewProvider?

        /// A binding to the current drag ratio, from 0.0 to 1.0.
        @Binding var dragRatio: CGFloat

        /// A binding that reflects whether the user is actively dragging.
        @Binding var isDragging: Bool

        @Environment(\.liteSliderThickness) private var thickness

        var body: some View {
            Track(
                length: length,
                thumbViewProvider: thumbView,
                dragRatio: $dragRatio,
                isDragging: $isDragging,
                onStartDragging: nil
            )
            .frame(width: thickness, height: length)
        }
    }
}
