import SwiftUI

// MARK: - ElasticDragMetrics

/// A utility that computes the offset and scale transformations for an elastic drag effect,
/// simulating resistance when a user drags a view beyond its bounds.
struct ElasticDragMetrics {

    /// The original size of the view.
    var size: CGSize

    /// The axis along which the drag gesture occurs.
    var orientation: Axis

    /// A Boolean value indicating whether the user is currently dragging.
    var isDragging: Bool

    /// The total length available for dragging along the current orientation.
    var availableLength: CGFloat

    /// The current location of the drag gesture in the coordinate space of the parent view.
    var dragLocation: CGPoint

    /// Configuration parameters that define the behavior of the elastic effect.
    var properties: ElasticDragProperties

    // MARK: Constants

    /// The damping factor used to reduce the intensity of the elastic effect.
    private let damping: CGFloat = 100

    // MARK: Computed Properties

    private var offsetSize: CGFloat { properties.offsetSize }
    private var compressionFactor: CGFloat { properties.compressionFactor }
    private var expansionFactor: CGFloat { properties.expansionFactor }

    /// The positional offset to apply to the view, simulating elastic pull.
    var offset: CGSize {
        guard offsetSize > 0, excessDragOffset != 0 else { return .zero }

        let isPositive = excessDragOffset > 0
        let direction: CGFloat = isPositive ? 1 : -1
        let target = offsetSize + 1
        let scaledOffset = direction * (1 - elasticScale(from: 1, to: target))

        switch orientation {
        case .horizontal: return CGSize(width: scaledOffset, height: 0)
        case .vertical: return CGSize(width: 0, height: scaledOffset)
        }
    }

    /// The scale to apply to the view along each axis, simulating stretch and compression.
    var scale: CGSize {
        CGSize(
            width: scale(for: .horizontal),
            height: scale(for: .vertical)
        )
    }

    /// The thumb offset caused by the elastic effect
    var thumbOffset: CGFloat {
        let offset = offset.height
        let scale = scale.height
        let availableLength = availableLength
        return excessDragOffset < 0
            ? offset - (availableLength - availableLength * scale)
            : offset + (size.height - size.height * scale)
    }

    private var excessDragOffset: CGFloat {
        guard !(0...availableLength).contains(dragLength), isDragging
        else { return 0 }

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
        return elasticScale(from: referenceSize, to: targetSize(for: axis))
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
        from size: CGFloat,
        to targetSize: CGFloat
    ) -> CGFloat {
        let maxScale = targetSize / size
        return maxScale - (maxScale - 1) / (abs(excessDragOffset) / damping + 1)
    }
}

// MARK: - ElasticDragMetrics + Equatable
extension ElasticDragMetrics: Equatable {

    static func == (lhs: ElasticDragMetrics, rhs: ElasticDragMetrics) -> Bool {
        lhs.isDragging == rhs.isDragging
        && lhs.availableLength == rhs.availableLength
        && lhs.dragLocation == rhs.dragLocation
        && lhs.properties == rhs.properties
    }
}
