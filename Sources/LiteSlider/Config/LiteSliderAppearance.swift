import SwiftUI

// MARK: - LiteSliderExpansionDirection

/// The direction in which the slider can expand when using the
/// `.expandable` length behavior.
///
/// Used by `LiteSliderLengthBehavior.expandable(direction:maxLength:)`.
public enum LiteSliderExpansionDirection: Sendable {
    /// The slider expands from the bottom toward the top.
    case upward

    /// The slider expands from the top toward the bottom.
    case downward

    /// The slider expands equally in both directions from the center.
    case center
}

// MARK: - LiteSliderLengthBehavior

/// Defines how the slider determines its total track length.
///
/// Set via `sliderLengthBehavior(_:)`
public enum LiteSliderLengthBehavior: Sendable {

    /// The slider adapts its length based on layout constraints.
    case dynamic

    /// The slider has a fixed track length, regardless of layout.
    ///
    /// - Parameter length: The fixed length of the track, in points.
    case fixed(length: CGFloat)

    /// The slider expands up to a maximum length in a given direction.
    ///
    /// - Parameters:
    ///   - direction: The direction in which the slider expands.
    ///   - maxLength: The maximum allowable track length, in points.
    case expandable(
        direction: LiteSliderExpansionDirection,
        maxLength: CGFloat
    )
}

// MARK: - LiteSliderStrokeStyle

/// A stroke style used to draw outlines or borders in the slider UI.
///
/// Set via `.sliderStroke(_:, lineWidth:)`
public struct LiteSliderStrokeStyle: Sendable, Equatable {

    /// The stroke color.
    public let color: Color

    /// The width of the stroke line, in points.
    public let lineWidth: CGFloat

    /// Creates a new stroke style.
    ///
    /// - Parameters:
    ///   - color: The color of the stroke.
    ///   - lineWidth: The width of the stroke line.
    public init(color: Color, lineWidth: CGFloat) {
        self.color = color
        self.lineWidth = lineWidth
    }
}

// MARK: - ElasticDragProperties

/// Configurable properties that control the elastic drag effect of a
/// LiteSlider.
///
/// Set via `.sliderElasticDrag(_:)`.
public struct ElasticDragProperties: Sendable, Equatable {
    /// The distance (in points) that the view shifts in the direction of drag
    /// when pulled beyond its bounds.
    public let offsetSize: CGFloat

    /// The factor by which the view compresses along the axis perpendicular
    /// to the drag direction.
    ///
    /// A value of `0` means no compression (0% of the thickness),
    /// and `1` means a compression equal to 100% of the thickness.
    public let compressionFactor: CGFloat

    /// The factor by which the view expands along the axis of the drag.
    ///
    /// This expansion is proportional to the slider's thickness (i.e. the size
    /// along the axis opposite to the drag direction).
    ///
    /// A value of `0` means no expansion (0% of the thickness),
    /// and `1` means an expansion equal to 100% of the thickness.
    public let expansionFactor: CGFloat

    /// Creates a new set of elastic drag properties.
    /// - Parameters:
    ///   - offsetSize: The maximum offset to apply during excess drag.
    ///   - compressionFactor: The scaling factor for compression (relative to
    ///   thickness).
    ///   - expansionFactor: The scaling factor for expansion (relative to
    ///   thickness).
    public init(
        offsetSize: CGFloat,
        compressionFactor: CGFloat,
        expansionFactor: CGFloat
    ) {
        self.offsetSize = offsetSize
        self.compressionFactor = compressionFactor
        self.expansionFactor = expansionFactor
    }

    /// The default elastic drag properties used by LiteSlider.
    public static let `default` = ElasticDragProperties(
        offsetSize: 25,
        compressionFactor: 0.1,
        expansionFactor: 0.2
    )

    /// A configuration that disables the elastic drag effect.
    public static let disable = ElasticDragProperties(
        offsetSize: 0,
        compressionFactor: 0,
        expansionFactor: 0
    )
}

// MARK: - View Modifiers

extension View {

    /// Sets the thickness of the slider track.
    ///
    /// Default: `300`
    public func sliderThickness(_ thickness: CGFloat) -> some View {
        environment(\.liteSliderThickness, thickness)
    }

    /// Sets the corner radius of the slider track.
    ///
    /// Default: `30`
    public func sliderRadius(_ radius: CGFloat) -> some View {
        environment(\.liteSliderRadius, radius)
    }

    /// Sets the behavior used to determine the slider's track length.
    ///
    /// Default: `.dynamic`
    public func sliderLengthBehavior(
        _ behavior: LiteSliderLengthBehavior
    ) -> some View {
        environment(\.liteSliderLengthBehavior, behavior)
    }

    /// Sets the background color of the slider's track.
    ///
    /// Default: `.secondary`
    public func sliderTrackColor(_ color: Color) -> some View {
        environment(\.liteSliderTrackColor, color)
    }

    /// Sets the color of the slider's filled portion (progress).
    ///
    /// Default: `.accentColor`
    public func sliderProgressColor(_ color: Color) -> some View {
        environment(\.liteSliderProgressColor, color)
    }

    /// Sets the stroke color and width of the slider track outline.
    ///
    /// Default: `.clear`, `lineWidth: 0`
    public func sliderStroke(_ color: Color, lineWidth: CGFloat) -> some View {
        environment(
            \.liteSliderStrokeStyle,
            .init(color: color, lineWidth: lineWidth)
        )
    }

    /// Sets the elastic drag behavior for views that support slider-like
    /// interaction and respond to excess drag gestures.
    ///
    /// Default:
    /// ```
    /// ElasticDragProperties(
    ///     offsetSize: 25,
    ///     compressionFactor: 0.1,
    ///     expansionFactor: 0.2
    /// )
    /// ```
    public func sliderElasticDrag(
        _ properties: ElasticDragProperties
    ) -> some View {
        environment(\.liteSliderElasticDragProperties, properties)
    }

    /// Sets the elastic drag behavior for views that support slider-like
    /// interaction and respond to excess drag gestures.
    ///
    /// - Parameters:
    ///   - offsetSize: The maximum offset to apply during excess drag.
    ///   - compressionFactor: The factor by which the view compresses along
    ///   the axis perpendicular to the drag direction. A value of `0` means no
    ///   compression (0% of the thickness), and `1` means a compression equal
    ///   to 100% of the thickness.
    ///   - expansionFactor: The factor by which the view expands along the
    ///   axis of the drag. This expansion is proportional to the slider's
    ///   thickness (i.e. the size along the axis opposite to the drag
    ///   direction). A value of `0` means no expansion (0% of the thickness),
    ///   and `1` means an expansion equal to 100% of the thickness.
    ///
    /// Default:
    /// `offsetSize: 25`, `compressionFactor: 0.1`, `expansionFactor: 0.2`
    public func sliderElasticDrag(
        offsetSize: CGFloat,
        compressionFactor: CGFloat,
        expansionFactor: CGFloat
    ) -> some View {
        environment(
            \.liteSliderElasticDragProperties,
            ElasticDragProperties(
                offsetSize: offsetSize,
                compressionFactor: compressionFactor,
                expansionFactor: expansionFactor
            )
        )
    }
}

// MARK: - Environment Keys

private struct LiteSliderThicknessKey: EnvironmentKey {
    static let defaultValue: CGFloat = 100
}

private struct LiteSliderRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat = 30
}

private struct LiteSliderLengthBehaviorKey: EnvironmentKey {
    static let defaultValue: LiteSliderLengthBehavior = .dynamic
}

private struct LiteSliderTrackColorKey: EnvironmentKey {
    static let defaultValue: Color = .secondary
}

private struct LiteSliderProgressColorKey: EnvironmentKey {
    static let defaultValue: Color = .accentColor
}

private struct LiteSliderStrokeStyleKey: EnvironmentKey {
    static let defaultValue = LiteSliderStrokeStyle(color: .clear, lineWidth: 0)
}

private struct LiteSliderElasticDragKey: EnvironmentKey {
    static let defaultValue = ElasticDragProperties.default
}

// MARK: - EnvironmentValues

extension EnvironmentValues {

    var liteSliderThickness: CGFloat {
        get { self[LiteSliderThicknessKey.self] }
        set { self[LiteSliderThicknessKey.self] = newValue }
    }

    var liteSliderRadius: CGFloat {
        get { self[LiteSliderRadiusKey.self] }
        set { self[LiteSliderRadiusKey.self] = newValue }
    }

    var liteSliderLengthBehavior: LiteSliderLengthBehavior {
        get { self[LiteSliderLengthBehaviorKey.self] }
        set { self[LiteSliderLengthBehaviorKey.self] = newValue }
    }

    var liteSliderTrackColor: Color {
        get { self[LiteSliderTrackColorKey.self] }
        set { self[LiteSliderTrackColorKey.self] = newValue }
    }

    var liteSliderProgressColor: Color {
        get { self[LiteSliderProgressColorKey.self] }
        set { self[LiteSliderProgressColorKey.self] = newValue }
    }

    var liteSliderStrokeStyle: LiteSliderStrokeStyle {
        get { self[LiteSliderStrokeStyleKey.self] }
        set { self[LiteSliderStrokeStyleKey.self] = newValue }
    }

    var liteSliderElasticDragProperties: ElasticDragProperties {
        get { self[LiteSliderElasticDragKey.self] }
        set { self[LiteSliderElasticDragKey.self] = newValue }
    }
}
