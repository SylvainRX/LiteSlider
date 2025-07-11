import SwiftUI

// MARK: - LiteSlider + ExpandableTrack

extension LiteSlider {

    /// A track that expands when dragged and contracts when released.
    /// Its expansion direction and target length are defined by
    /// `LiteSliderLengthBehavior`.
    struct ExpandableTrack: View {

        // MARK: Properties

        var direction: LiteSliderExpansionDirection
        var thumbView: ThumbViewProvider?

        @Binding var dragRatio: CGFloat
        @Binding var isDragging: Bool

        @Environment(\.liteSliderThickness) private var thickness
        @Environment(\.liteSliderLengthBehavior) private var lengthBehavior

        private var trackLength: CGFloat {
            isDragging
                ? lengthBehavior.length ?? thickness
                : thickness
        }

        // MARK: Body

        var body: some View {
            FixedFrameContainer(
                size: CGSize(width: thickness, height: thickness),
                alignment: direction.parentViewAlignment
            ) {
                Track(
                    length: trackLength,
                    thumbViewProvider: thumbView,
                    dragRatio: $dragRatio,
                    isDragging: $isDragging,
                    onStartDragging: resetDragRatio
                )
                .frame(width: thickness, height: trackLength)
            }
        }

        // MARK: Private Methods

        private func resetDragRatio() {
            dragRatio = defaultDragRatio(for: lengthBehavior.expansionDirection)
        }

        private func defaultDragRatio(
            for direction: LiteSliderExpansionDirection?
        ) -> CGFloat {
            switch direction {
            case .upward: return 0
            case .downward: return 1
            case .center: return 0.5
            case .none: return dragRatio
            }
        }
    }
}
