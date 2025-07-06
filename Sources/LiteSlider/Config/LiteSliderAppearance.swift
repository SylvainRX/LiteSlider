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


// MARK: - View Modifiers

extension View {

    /// Sets the thickness of the slider track.
    ///
    /// Default: `20`
    public func sliderThickness(_ thickness: CGFloat) -> some View {
        environment(\.liteSliderThickness, thickness)
    }

    /// Sets the corner radius of the slider track.
    ///
    /// Default: `10`
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
    /// Default: `.gray.opacity(0.4)`
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
    /// Default: `Color.clear`, `lineWidth: 0`
    public func sliderStroke(_ color: Color, lineWidth: CGFloat) -> some View {
        environment(
            \.liteSliderStrokeStyle,
            .init(color: color, lineWidth: lineWidth)
        )
    }
}

// MARK: - Environment Keys

private struct LiteSliderThicknessKey: EnvironmentKey {
    static let defaultValue: CGFloat = 20
}

private struct LiteSliderRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat = 10
}

private struct LiteSliderLengthBehaviorKey: EnvironmentKey {
    static let defaultValue: LiteSliderLengthBehavior = .dynamic
}

private struct LiteSliderTrackColorKey: EnvironmentKey {
    static let defaultValue: Color = .gray.opacity(0.4)
}

private struct LiteSliderProgressColorKey: EnvironmentKey {
    static let defaultValue: Color = .accentColor
}

private struct LiteSliderStrokeStyleKey: EnvironmentKey {
    static let defaultValue = LiteSliderStrokeStyle(color: .clear, lineWidth: 0)
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
}
