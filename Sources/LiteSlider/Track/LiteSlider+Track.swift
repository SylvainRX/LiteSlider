import SwiftUI

// MARK: - LiteSlider + Track

extension LiteSlider {

    /// A vertically draggable track that represents the slider's value visually.
    struct Track: View {

        // MARK: Input

        /// The total length of the slider track, in points.
        let length: CGFloat

        /// A closure that returns a custom view for the slider thumb, or `nil`
        /// to use the default appearance.
        let thumbView: ThumbViewProvider?

        /// A binding to the current drag ratio, representing the thumb's
        /// position along the track from 0 to 1.
        @Binding var dragRatio: CGFloat

        /// A binding indicating whether the user is actively dragging the
        /// slider.
        @Binding var isDragging: Bool

        /// An optional closure that is called when the user starts interacting
        ///  with the slider.
        let onStartDragging: (() -> Void)?

        // MARK: State

        @State private var dragLocation = CGPoint(x: 0, y: 0)

        // MARK: Environment

        @Environment(\.liteSliderThickness) private var thickness
        @Environment(\.liteSliderRadius) private var radius
        @Environment(\.liteSliderTrackColor) private var trackColor
        @Environment(\.liteSliderProgressColor) private var progressColor
        @Environment(\.liteSliderStrokeStyle) private var strokeStyle
        @Environment(\.liteSliderOnEnded) private var onEnded

        // MARK: Constants

        private let thumbSize: CGFloat = 70
        private let valueChangeAnimation: Animation = .easeOut(duration: 0.30)
        private let dragAnimation: Animation = .easeOut(duration: 0.15)

        // MARK: View

        var body: some View {
            ZStack(alignment: .bottom) {
                Rectangle().fill(.clear)
                    .overlay(alignment: .top) { background }
                    .overlay(alignment: .bottom) { progress }
            }
            .gesture(gesture)
            .elasticDragEffect(
                size: CGSize(width: thickness, height: length),
                isDragging: isDragging,
                availableLength: availableLength,
                dragLocation: dragLocation
            )
            .animation(dragAnimation, value: isDragging)
            .animation(valueChangeAnimation, value: dragRatio)
        }

        // MARK: Subviews

        private var background: some View {
            ZStack {
                BackgroundStrokeShape(cornerRadius: radius)
                    .stroke(lineWidth: strokeStyle.lineWidth)

                BackgroundShape(cornerRadius: radius)
                    .fill(trackColor)
            }
            .frame(height: backgroundLength)
        }

        private var progress: some View {
            ZStack {
                ProgressStrokeShape(cornerRadius: radius)
                    .stroke(lineWidth: strokeStyle.lineWidth)

                ProgressShape(cornerRadius: radius)
                    .fill(progressColor)
                    .overlay(alignment: .top) {
                        thumbView?(isDragging)
                    }
            }
            .frame(height: progressLength)
        }

        // MARK: Gesture

        private var gesture: some Gesture {
            TouchAndDragGesture(isDragging: $isDragging)
                .onStarted { location in
                    updateDragLocation(for: location)
                    if let onStartDragging {
                        onStartDragging()
                    } else {
                        updateDragRatio()
                    }
                }
                .onChanged { location in
                    updateDragLocation(for: location)
                    updateDragRatio()
                }
                .onEnded {
                    onEnded()
                }
        }

        private func updateDragLocation(for location: CGPoint) {
            dragLocation.y = length - location.y - thumbSize / 2
        }

        private func updateDragRatio() {
            let clamped = dragLocation.y.clamped(to: 0...availableLength)
            dragRatio = clamped / max(1, availableLength)
        }

        // MARK: Layout Helpers

        private var backgroundLength: CGFloat {
            availableLength - progressOffset + radius
        }

        private var progressLength: CGFloat {
            progressOffset + thumbLength
        }

        private var progressOffset: CGFloat {
            let offset = dragRatio * availableLength
            return offset.clamped(to: 0...availableLength)
        }

        private var thumbLength: CGFloat {
            thumbView != nil && isDragging
                ? thickness + thumbSize
                : thickness
        }

        private var availableLength: CGFloat {
            max(0, length - thumbLength)
        }
    }
}
