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
        let thumbViewProvider: ThumbViewProvider?

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
        @Environment(\.liteSliderElasticDragProperties)
        private var elasticDragProperties

        // MARK: Constants

        private let touchLocationLength: CGFloat = 70
        private let valueChangeAnimation: Animation = .spring(duration: 0.30)
        private let dragAnimation: Animation = .spring(duration: 0.15)

        // MARK: View

        var body: some View {
            ZStack(alignment: .top) {
                track
                thumbView
            }
            .gesture(gesture)
            .animation(dragAnimation, value: isDragging)
            .animation(valueChangeAnimation, value: dragRatio)
            .animation(valueChangeAnimation, value: elasticDragMetrics)

        }

        // MARK: Subviews

        private var track: some View {
            let trackShapeParameters = trackShapeParameters
            return ZStack {
                background(trackShapeParameters)
                progress(trackShapeParameters)
            }
        }

        private func background(
            _ trackShapeParameters: TrackShapeParameters
        ) -> some View {
            ZStack {
                BackgroundStrokeShape(trackShapeParameters)
                    .stroke(lineWidth: strokeStyle.lineWidth)
                BackgroundShape(trackShapeParameters)
                    .fill(trackColor)
            }
        }

        private func progress(
            _ trackShapeParameters: TrackShapeParameters
        ) -> some View {
            ZStack {
                ProgressStrokeShape(trackShapeParameters)
                    .stroke(lineWidth: strokeStyle.lineWidth)
                ProgressShape(trackShapeParameters)
                    .fill(progressColor)
            }
        }

        private var trackShapeParameters: TrackShapeParameters {
            let elasticDragMetrics = elasticDragMetrics
            return TrackShapeParameters(
                radius: radius,
                ratio: dragRatio,
                thumbLength: thumbLength,
                offset: elasticDragMetrics.offset.height,
                scale: elasticDragMetrics.scale
            )
        }

        private var thumbView: some View {
            let elasticDragMetrics = elasticDragMetrics
            return thumbViewProvider?(isDragging)
                .offset(y: thumbValueOffset + elasticDragMetrics.thumbOffset)
                .frame(width: thickness, height: thickness)
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
        }

        private func updateDragLocation(for location: CGPoint) {
            dragLocation.y = length - location.y - touchLocationLength / 2
        }

        private func updateDragRatio() {
            let availableLength = trackGeometry.availableLength
            let clamped = dragLocation.y.clamped(to: 0...availableLength)
            dragRatio = clamped / max(1, availableLength)
        }

        // MARK: Layout Helpers

        private var trackGeometry: LiteSliderTrackGeometry {
            .init(
                ratio: dragRatio,
                trackLength: length,
                thumbLength: thumbLength,
                radius: radius
            )
        }

        private var thumbLength: CGFloat {
            thumbViewProvider != nil && isDragging
                ? thickness + touchLocationLength
                : thickness
        }

        private var thumbValueOffset: CGFloat {
            let availableLength = trackGeometry.availableLength
            return ((1 - dragRatio) * availableLength)
                .clamped(to: 0...availableLength)
        }

        private var elasticDragMetrics: ElasticDragMetrics {
            ElasticDragMetrics(
                size: CGSize(width: thickness, height: length),
                orientation: .vertical,
                isDragging: isDragging,
                availableLength: trackGeometry.availableLength,
                dragLocation: dragLocation,
                properties: elasticDragProperties
            )
        }
    }
}
