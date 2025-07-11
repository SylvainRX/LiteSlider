import SwiftUI

// MARK: - TrackShape

/// A shape used to render part of a track based on the progress ratio with
/// animated and elastic drag effects.
///
/// Used in conjunction with `TrackShapeAnimatableData` to enable smooth animations.
protocol TrackShape: Shape {
    var radius: CGFloat { get set }
    var ratio: CGFloat { get set }
    var thumbLength: CGFloat { get set }
    var offset: CGFloat { get set }
    var scale: CGSize { get set }
}

extension TrackShape {
    var animatableData: TrackShapeAnimatableData {
        get {
            TrackShapeAnimatableData(
                ratio: ratio,
                thumbLength: thumbLength,
                offset: offset,
                scale: scale
            )
        }
        set {
            ratio = newValue.ratio
            thumbLength = newValue.thumbLength
            offset = newValue.offset
            scale = newValue.scale
        }
    }

    func applyingElasticDragEffect(on path: Path, in rect: CGRect) -> Path {
        path.applying(
            offset: offset,
            scale: scale,
            in: rect,
            for: ratio
        )
    }
}

// MARK: - TrackShapeParameters

struct TrackShapeParameters {
    let radius: CGFloat
    let ratio: CGFloat
    let thumbLength: CGFloat
    let offset: CGFloat
    let scale: CGSize
}

// MARK: - TrackShapeAnimatableData

/// A data structure conforming to `VectorArithmetic` that encapsulates
/// multiple animatable values used to animate track shapes.
struct TrackShapeAnimatableData: VectorArithmetic {
    var ratio: CGFloat
    var thumbLength: CGFloat
    var offset: CGFloat
    var scale: CGSize

    // MARK: VectorArithmetic
    mutating func scale(by rhs: Double) {
        let scaleFactor = CGFloat(rhs)
        ratio *= scaleFactor
        thumbLength *= scaleFactor
        offset *= scaleFactor
        scale.width *= scaleFactor
        scale.height *= scaleFactor
    }

    var magnitudeSquared: Double {
        Double(
            ratio * ratio
                + thumbLength * thumbLength
                + offset * offset
                + scale.width * scale.width
                + scale.height * scale.height
        )
    }

    // MARK: Equatable

    static func == (
        lhs: TrackShapeAnimatableData,
        rhs: TrackShapeAnimatableData
    ) -> Bool {
        lhs.ratio == rhs.ratio
            && lhs.thumbLength == rhs.thumbLength
            && lhs.offset == rhs.offset
            && lhs.scale == rhs.scale
    }

    // MARK: AdditiveArithmetic

    static var zero: TrackShapeAnimatableData {
        TrackShapeAnimatableData(
            ratio: 0,
            thumbLength: 0,
            offset: 0,
            scale: .zero
        )
    }

    static func + (
        lhs: TrackShapeAnimatableData,
        rhs: TrackShapeAnimatableData
    ) -> TrackShapeAnimatableData {
        TrackShapeAnimatableData(
            ratio: lhs.ratio + rhs.ratio,
            thumbLength: lhs.thumbLength + rhs.thumbLength,
            offset: lhs.offset + rhs.offset,
            scale: lhs.scale + rhs.scale
        )
    }

    static func - (
        lhs: TrackShapeAnimatableData,
        rhs: TrackShapeAnimatableData
    ) -> TrackShapeAnimatableData {
        TrackShapeAnimatableData(
            ratio: lhs.ratio - rhs.ratio,
            thumbLength: lhs.thumbLength - rhs.thumbLength,
            offset: lhs.offset - rhs.offset,
            scale: lhs.scale - rhs.scale
        )
    }
}

extension CGSize {

    fileprivate static func + (lhs: Self, rhs: Self) -> Self {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    fileprivate static func - (lhs: Self, rhs: Self) -> Self {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}

extension Path {

    /// Applies a vertical offset and scaling transformation to the path
    /// relative to the given rectangle and a vertical anchor determined by
    /// `ratio`.
    func applying(
        offset: CGFloat,
        scale: CGSize,
        in rect: CGRect,
        for ratio: CGFloat
    ) -> Path {
        let anchor: UnitPoint = ratio < 0.5 ? .top : .bottom
        let translation = CGSize(
            width: rect.width * (1 - scale.width) / 2,
            height: offset
                + (anchor == .bottom
                    ? (rect.height * (1 - scale.height))
                    : 0)
        )

        return
            self
            .applying(
                CGAffineTransform(scaleX: scale.width, y: scale.height)
            )
            .applying(
                CGAffineTransform(
                    translationX: translation.width,
                    y: translation.height
                )
            )
    }
}
