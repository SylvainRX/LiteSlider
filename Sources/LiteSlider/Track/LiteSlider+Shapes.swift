import SwiftUI

// MARK: - BackgroundShape

/// A filled shape with rounded top and bottom corners on both sides.
/// Used for rendering the background of the slider track.
struct BackgroundShape: Shape {

    /// The radius of the corner arcs.
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))

        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

        path.addArc(
            center: CGPoint(
                x: rect.minX + cornerRadius,
                y: rect.minY + cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(-90),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))

        path.addArc(
            center: CGPoint(
                x: rect.maxX - cornerRadius,
                y: rect.minY + cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(-90),
            clockwise: true
        )

        path.addLine(
            to: CGPoint(
                x: rect.minX + cornerRadius,
                y: rect.maxY - cornerRadius
            )
        )

        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY),
            radius: cornerRadius,
            startAngle: .degrees(-90),
            endAngle: .degrees(180),
            clockwise: true
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - BackgroundStrokeShape

/// A partial stroked shape outlining the top and side edges of the track.
/// Used for drawing a stroke behind the thumb.
struct BackgroundStrokeShape: Shape {

    /// The radius of the corner arcs.
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))

        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

        path.addArc(
            center: CGPoint(
                x: rect.minX + cornerRadius,
                y: rect.minY + cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(-90),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))

        path.addArc(
            center: CGPoint(
                x: rect.maxX - cornerRadius,
                y: rect.minY + cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        return path
    }
}

// MARK: - ProgressShape

/// A filled shape that represents the progress or active portion
/// of the slider. Features full rounded corners.
struct ProgressShape: Shape {

    /// The radius of the corner arcs.
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))

        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))

        path.addArc(
            center: CGPoint(
                x: rect.maxX - cornerRadius,
                y: rect.maxY - cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(0),
            clockwise: true
        )

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))

        path.addArc(
            center: CGPoint(
                x: rect.maxX - cornerRadius,
                y: rect.minY + cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(-90),
            clockwise: true
        )

        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))

        path.addArc(
            center: CGPoint(
                x: rect.minX + cornerRadius,
                y: rect.minY + cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(-90),
            endAngle: .degrees(-180),
            clockwise: true
        )

        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius))

        path.addArc(
            center: CGPoint(
                x: rect.minX + cornerRadius,
                y: rect.maxY - cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(90),
            clockwise: true
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - ProgressStrokeShape

/// A partial stroked shape outlining the filled progress area.
/// Excludes the top corners to blend with the background.
struct ProgressStrokeShape: Shape {

    /// The radius of the corner arcs.
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius))

        path.addArc(
            center: CGPoint(
                x: rect.minX + cornerRadius,
                y: rect.maxY - cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(90),
            clockwise: true
        )

        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))

        path.addArc(
            center: CGPoint(
                x: rect.maxX - cornerRadius,
                y: rect.maxY - cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(0),
            clockwise: true
        )

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))

        return path
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        BackgroundStrokeShape(cornerRadius: 30)
            .fill(.clear)
            .stroke(.gray, style: .init(lineWidth: 1))

        BackgroundShape(cornerRadius: 30)
            .fill(.gray)

        ProgressShape(cornerRadius: 30)
            .fill(.gray)

        ProgressStrokeShape(cornerRadius: 30)
            .fill(.clear)
            .stroke(.gray, style: .init(lineWidth: 1))
    }
    .frame(width: 100, height: 500)
}
