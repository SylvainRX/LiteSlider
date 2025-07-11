import SwiftUI

// MARK: - BackgroundShape

/// A shape used to render the background of the slider track.
struct BackgroundShape: TrackShape {

    var radius: CGFloat

    // MARK: Animatable Data

    var ratio: CGFloat
    var thumbLength: CGFloat
    var offset: CGFloat
    var scale: CGSize

    // MARK: Init

    init(_ parameters: TrackShapeParameters) {
        radius = parameters.radius
        ratio = parameters.ratio
        thumbLength = parameters.thumbLength
        offset = parameters.offset
        scale = parameters.scale
    }

    // MARK: Path

    func path(in rect: CGRect) -> Path {
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = topRelativeMaxY(in: rect)
        var path = Path()

        // Start at bottom-left point
        path.move(to: CGPoint(x: minX, y: maxY))

        // Left edge
        path.addLine(to: CGPoint(x: minX, y: minY + radius))

        // Top-left corner
        path.addArc(
            center: CGPoint(x: minX + radius, y: minY + radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(-90),
            clockwise: false
        )

        // Top edge
        path.addLine(to: CGPoint(x: maxX - radius, y: minY))

        // Top-right corner
        path.addArc(
            center: CGPoint(x: maxX - radius, y: minY + radius),
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )

        // Right edge
        path.addLine(to: CGPoint(x: maxX, y: maxY))

        // Bottom-right corner
        path.addArc(
            center: CGPoint(x: maxX - radius, y: maxY),
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(-90),
            clockwise: true
        )

        // Bottom edge
        path.addLine(to: CGPoint(x: minX + radius, y: maxY - radius))

        // Bottom-left corner
        path.addArc(
            center: CGPoint(x: minX + radius, y: maxY),
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(180),
            clockwise: true
        )

        path.closeSubpath()
        return applyingElasticDragEffect(on: path, in: rect)
    }

    private func topRelativeMaxY(in rect: CGRect) -> CGFloat {
        LiteSliderTrackGeometry(
            ratio: ratio,
            trackLength: rect.height,
            thumbLength: thumbLength,
            radius: radius
        ).backgroundLength
    }
}

// MARK: - BackgroundStrokeShape

/// A partial path used to render the stroke behind the background of the
/// slider track.
struct BackgroundStrokeShape: TrackShape {

    var radius: CGFloat

    // MARK: Animatable Data

    var ratio: CGFloat
    var thumbLength: CGFloat
    var offset: CGFloat
    var scale: CGSize

    // MARK: Init

    init(_ parameters: TrackShapeParameters) {
        radius = parameters.radius
        ratio = parameters.ratio
        thumbLength = parameters.thumbLength
        offset = parameters.offset
        scale = parameters.scale
    }

    // MARK: Path

    func path(in rect: CGRect) -> Path {
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = topRelativeMaxY(in: rect)
        var path = Path()

        // Start at bottom-left point
        path.move(to: CGPoint(x: minX, y: maxY))

        // Left edge
        path.addLine(to: CGPoint(x: minX, y: minY + radius))

        // Top-left corner
        path.addArc(
            center: CGPoint(x: minX + radius, y: minY + radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(-90),
            clockwise: false
        )

        // Top edge
        path.addLine(to: CGPoint(x: maxX - radius, y: minY))

        // Top-right corner
        path.addArc(
            center: CGPoint(x: maxX - radius, y: minY + radius),
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )

        // Bottom edge
        path.addLine(to: CGPoint(x: maxX, y: maxY))

        return applyingElasticDragEffect(on: path, in: rect)
    }

    private func topRelativeMaxY(in rect: CGRect) -> CGFloat {
        LiteSliderTrackGeometry(
            ratio: ratio,
            trackLength: rect.height,
            thumbLength: thumbLength,
            radius: radius
        ).backgroundLength
    }
}

// MARK: - ProgressShape

/// A shape used to render the progress of the slider track.
struct ProgressShape: TrackShape {

    var radius: CGFloat

    // MARK: Animatable Data

    var ratio: CGFloat
    var thumbLength: CGFloat
    var offset: CGFloat
    var scale: CGSize

    // MARK: Init

    init(_ parameters: TrackShapeParameters) {
        radius = parameters.radius
        ratio = parameters.ratio
        thumbLength = parameters.thumbLength
        offset = parameters.offset
        scale = parameters.scale
    }

    // MARK: Path

    func path(in rect: CGRect) -> Path {
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = topRelativeMinY(in: rect)
        let maxY = rect.maxY
        var path = Path()

        // Start at bottom-most-left point
        path.move(to: CGPoint(x: minX + radius, y: maxY))

        // Bottom edge
        path.addLine(to: CGPoint(x: maxX - radius, y: maxY))

        // Bottom-right corner
        path.addArc(
            center: CGPoint(x: maxX - radius, y: maxY - radius),
            radius: radius,
            startAngle: .degrees(90),
            endAngle: .degrees(0),
            clockwise: true
        )

        // Right edge
        path.addLine(to: CGPoint(x: maxX, y: minY + radius))

        // Top-right corner
        path.addArc(
            center: CGPoint(x: maxX - radius, y: minY + radius),
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(-90),
            clockwise: true
        )

        // Top edge
        path.addLine(to: CGPoint(x: minX + radius, y: minY))

        // Top-left corner
        path.addArc(
            center: CGPoint(x: minX + radius, y: minY + radius),
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(-180),
            clockwise: true
        )

        // Left edge
        path.addLine(to: CGPoint(x: minX, y: maxY - radius))

        // Bottom-right corner
        path.addArc(
            center: CGPoint(x: minX + radius, y: maxY - radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(90),
            clockwise: true
        )

        path.closeSubpath()

        return applyingElasticDragEffect(on: path, in: rect)
    }

    private func topRelativeMinY(in rect: CGRect) -> CGFloat {
        let progressLength = LiteSliderTrackGeometry(
            ratio: ratio,
            trackLength: rect.height,
            thumbLength: thumbLength,
            radius: radius
        ).progressLength
        return rect.height - progressLength
    }
}

// MARK: - ProgressStrokeShape

/// A partial path used to render the stroke behind the progress of the
/// slider track.
struct ProgressStrokeShape: TrackShape {

    var radius: CGFloat

    // MARK: Animatable Data
    var ratio: CGFloat
    var thumbLength: CGFloat
    var offset: CGFloat
    var scale: CGSize

    // MARK: Init

    init(_ parameters: TrackShapeParameters) {
        radius = parameters.radius
        ratio = parameters.ratio
        thumbLength = parameters.thumbLength
        offset = parameters.offset
        scale = parameters.scale
    }

    // MARK: Path

    func path(in rect: CGRect) -> Path {
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = topRelativeMinY(in: rect)
        let maxY = rect.maxY
        var path = Path()

        // Start at top-left point
        path.move(to: CGPoint(x: minX, y: minY + radius))

        // Left edge
        path.addLine(to: CGPoint(x: minX, y: maxY - radius))

        // Bottom-left corner
        path.addArc(
            center: CGPoint(x: minX + radius, y: maxY - radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(90),
            clockwise: true
        )

        // Bottom edge
        path.addLine(to: CGPoint(x: maxX - radius, y: maxY))

        // Bottom-right corner
        path.addArc(
            center: CGPoint(x: maxX - radius, y: maxY - radius),
            radius: radius,
            startAngle: .degrees(90),
            endAngle: .degrees(0),
            clockwise: true
        )

        // Right edge
        path.addLine(to: CGPoint(x: maxX, y: minY + radius))

        return applyingElasticDragEffect(on: path, in: rect)
    }

    private func topRelativeMinY(in rect: CGRect) -> CGFloat {
        let progressLength = LiteSliderTrackGeometry(
            ratio: ratio,
            trackLength: rect.height,
            thumbLength: thumbLength,
            radius: radius
        ).progressLength
        return rect.height - progressLength
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var ratio: CGFloat = 0.5
    @Previewable @State var offset: CGFloat = 0
    @Previewable @State var scale: CGSize = .init(width: 1, height: 1)
    let radius: CGFloat = 30
    let thumbSize: CGFloat = 70

    var trackShapeParameters: TrackShapeParameters {
        TrackShapeParameters(
            radius: radius,
            ratio: ratio,
            thumbLength: thumbSize,
            offset: offset,
            scale: scale
        )
    }

    Spacer()

    VStack(spacing: 0) {
        BackgroundStrokeShape(trackShapeParameters)
            .fill(.clear)
            .stroke(.gray, style: .init(lineWidth: 1))

        BackgroundShape(trackShapeParameters)
            .fill(.gray)

        ProgressShape(trackShapeParameters)
            .fill(.gray)

        ProgressStrokeShape(trackShapeParameters)
            .fill(.clear)
            .stroke(.gray, style: .init(lineWidth: 1))
    }
    .frame(width: 100, height: 600)
    .onChange(of: scale.height) { _, newValue in
        scale.width = 1 + 1 - scale.height
        offset = (scale.height - 1) * 200
    }

    Spacer()

    HStack {
        Text("Ratio")
        Slider(value: $ratio, in: 0...1)
        Text(String(format: "%.2f", ratio))
    }
    HStack {
        Text("Scale")
        Slider(value: $scale.height, in: 1...1.1)
        Text(String(format: "%.2f", scale.height))
    }

}
