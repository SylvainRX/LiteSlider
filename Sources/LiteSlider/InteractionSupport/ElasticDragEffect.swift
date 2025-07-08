import SwiftUI

// MARK: - Elastic Drag Effect Extension

/// Applies an elastic drag effect to the view, making it visually scale and
/// offset in the direction of drag when pulled beyond its bounds, mimicking
/// an elastic response.
///
/// - Parameters:
///   - size: The original size of the view.
///   - orientation: The axis of drag. If `nil`, it will be inferred based on
///     `size`.
///   - isDragging: A Boolean value indicating whether the user is currently
///     dragging.
///   - availableLength: The total length available for dragging in the current
///     orientation.
///   - dragLocation: The current location of the drag gesture in the parent
///     coordinate space.
///
/// - Returns: A view that responds to excess drag with an elastic scaling and
///   offset effect.
///
extension View {
    func elasticDragEffect(
        size: CGSize,
        orientation: Axis? = nil,
        isDragging: Bool,
        availableLength: CGFloat,
        dragLocation: CGPoint
    ) -> some View {
        modifier(
            ElasticDragEffect(
                size: size,
                orientation: orientation
                    ?? (size.width > size.height ? .horizontal : .vertical),
                isDragging: isDragging,
                availableLength: availableLength,
                dragLocation: dragLocation
            )
        )
    }
}

// MARK: - ElasticDragEffect

private struct ElasticDragEffect: ViewModifier {

    // MARK: Internal Properties

    var size: CGSize
    var orientation: Axis
    var isDragging: Bool
    var availableLength: CGFloat
    var dragLocation: CGPoint

    // MARK: Environment

    @Environment(\.liteSliderElasticDragProperties) private var properties

    // MARK: Constants

    private let animation: Animation = .easeOut(duration: 0.15)

    // MARK: Computed Properties

    private var offsetSize: CGFloat { properties.offsetSize }
    private var compressionFactor: CGFloat { properties.compressionFactor }
    private var expansionFactor: CGFloat { properties.expansionFactor }

    // MARK: Body

    func body(content: Content) -> some View {
        content.animation(animation) { content in
            content
                .scaleEffect(scale, anchor: anchor)
                .offset(offset)
        }
    }

    // MARK: Computed Properties

    private var anchor: UnitPoint {
        switch orientation {
        case .horizontal:
            excessDragOffset > 0 ? .leading : .trailing
        case .vertical:
            excessDragOffset > 0 ? .bottom : .top
        }
    }

    private var offset: CGSize {
        guard excessDragOffset != 0 else { return .zero }
        let targetOffset = excessDragOffset > 0 ? -offsetSize : offsetSize
        let offset = elasticScale(for: 1, to: targetOffset)
        return CGSize(
            width: orientation == .horizontal ? offset : 0,
            height: orientation == .vertical ? offset : 0
        )
    }

    private var scale: CGSize {
        CGSize(
            width: scale(for: .horizontal),
            height: scale(for: .vertical)
        )
    }

    private var excessDragOffset: CGFloat {
        guard !(0...availableLength).contains(dragLength), isDragging else {
            return 0
        }

        let positiveDragOffset = dragLength - availableLength
        let negativeDragOffset = dragLength
        return max(positiveDragOffset, min(negativeDragOffset, 0))
    }

    private var dragLength: CGFloat {
        orientation == .horizontal ? dragLocation.x : dragLocation.y
    }

    // MARK: Helpers

    private func scale(for axis: Axis) -> CGFloat {
        guard excessDragOffset != 0 else { return 1 }
        let referenceSize = axis == .horizontal ? size.width : size.height
        return elasticScale(for: referenceSize, to: targetSize(for: axis))
    }

    private func targetSize(for axis: Axis) -> CGFloat {
        switch (orientation, axis) {
        case (.horizontal, .horizontal):
            return size.width + size.height * expansionFactor
        case (.horizontal, .vertical):
            return size.height * (1 - compressionFactor)
        case (.vertical, .horizontal):
            return size.width * (1 - compressionFactor)
        case (.vertical, .vertical):
            return size.height + size.width * expansionFactor
        }
    }

    private func elasticScale(
        for size: CGFloat,
        to targetSize: CGFloat
    ) -> CGFloat {
        let maxScale = targetSize / size
        let damping: CGFloat = 100
        return maxScale - (maxScale - 1) / (abs(excessDragOffset) / damping + 1)
    }
}
