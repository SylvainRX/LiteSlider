import SwiftUI

// MARK: - LiteSlider

/// A customizable vertical slider component supporting three length behaviors:
/// dynamic, fixed, and expandable. It allows optional display of a custom
/// thumb view that can visually respond to drag state. The slider supports
/// value binding with configurable ranges and optional stepping, and includes
/// accessibility support.
///
/// Use this component when you need a highly configurable slider with smooth
/// drag interaction and adaptable track length.
public struct LiteSlider<ThumbView: View>: View {

    /// A closure that returns a thumb view based on drag state.
    public typealias ThumbViewProvider = (
        _ isDragging: Bool
    ) -> ThumbView

    // MARK: Configuration

    private var range: ClosedRange<Double>
    private var step: Double

    // MARK: Environment

    @Environment(\.liteSliderLengthBehavior) private var lengthBehavior
    @Environment(\.liteSliderAccessibilityValueFormatter)
    private var accessibilityValueFormatter
    @Environment(\.liteSliderAccessibilityValueStep)
    private var accessibilityValueStep

    // MARK: State

    @Binding private var externalValue: Double
    @State private var dragRatio: CGFloat
    @State private var isDragging: Bool = false

    // MARK: Thumb

    private let thumbView: ThumbViewProvider?

    // MARK: Initializers

    /// Creates a LiteSlider.
    ///
    /// - Parameters:
    ///   - value: A binding to the slider's current value.
    ///   - range: The valid range of values for the slider. Defaults to 0...1.
    ///   - step: The step increment for value changes. Defaults to 0 (continuous).
    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double = 0,
    ) where ThumbView == EmptyView {
        self._externalValue = value
        self.range = range
        self.step = step
        self.thumbView = nil
        dragRatio = value.wrappedValue.ratio(in: range)
    }

    /// Creates a LiteSlider with a custom thumb view.
    ///
    /// - Parameters:
    ///   - value: A binding to the slider's current value.
    ///   - range: The valid range of values for the slider. Defaults to 0...1.
    ///   - step: The step increment for value changes. Defaults to 0 (continuous).
    ///   - thumbView: A closure that provides the thumb view, given dragging state.
    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double = 0,
        @ViewBuilder thumbView: @escaping ThumbViewProvider
    ) {
        self._externalValue = value
        self.range = range
        self.step = step
        self.thumbView = thumbView
        dragRatio = value.wrappedValue.ratio(in: range)
    }

    // MARK: View Body

    public var body: some View {
        track
            .onChange(of: dragRatio) { _, newValue in
                updateExternalValue(with: newValue)
            }
            .onChange(of: externalValue) { _, newValue in
                updateDragValue(with: newValue)
            }
            .accessibilityElement()
            .accessibilityValue(Text(accessibilityFormattedValue))
            .accessibilityAdjustableAction(handleAccessibilityAdjustment(_:))
    }

    // MARK: Track View

    @ViewBuilder
    private var track: some View {
        switch lengthBehavior {
        case .dynamic:
            DynamicLengthTrack(
                thumbView: thumbView,
                dragRatio: $dragRatio,
                isDragging: $isDragging
            )
        case let .fixed(length):
            FixedLengthTrack(
                length: length,
                thumbView: thumbView,
                dragRatio: $dragRatio,
                isDragging: $isDragging
            )
        case let .expandable(direction, _):
            ExpandableTrack(
                direction: direction,
                thumbView: thumbView,
                dragRatio: $dragRatio,
                isDragging: $isDragging
            )
        }
    }

    // MARK: Value Updates

    private func updateDragValue(with newValue: Double) {
        guard !isDragging else { return }
        dragRatio = newValue.ratio(in: range)
    }

    private func updateExternalValue(with ratio: Double) {
        guard isDragging else { return }
        let rawValue =
            range.lowerBound + Double(ratio)
            * (range.upperBound - range.lowerBound)
        externalValue = step != 0 ? rawValue.rounded(to: step) : rawValue
    }

    // MARK: Accessibility Value Updates

    private func handleAccessibilityAdjustment(
        _ direction: AccessibilityAdjustmentDirection
    ) {
        switch direction {
        case .increment:
            externalValue = min(
                externalValue + defaultAccessibilityStep,
                range.upperBound
            ).rounded(to: step)
        case .decrement:
            externalValue = max(
                externalValue - defaultAccessibilityStep,
                range.lowerBound
            ).rounded(to: step)
        @unknown default:
            break
        }
    }

    private var defaultAccessibilityStep: Double {
        if let accessibilityStep = accessibilityValueStep {
            return accessibilityStep
        } else if step != 0 {
            return step
        } else {
            return (range.upperBound - range.lowerBound) / 10
        }
    }

    private var accessibilityFormattedValue: String {
        accessibilityValueFormatter
            .string(from: NSNumber(value: externalValue)) ?? ""
    }
}

#Preview {
    @Previewable @State var value: Double = 50
    let smallRange: ClosedRange<Double> = 0...100
    let largeRange: ClosedRange<Double> = -20...120
    let oneDecimalDigitFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        return formatter
    }()

    let thumbView: (Bool) -> some View = { isDragging in
        VStack {
            Text("\(Int(value))")
                .font(
                    .system(
                        size: 32,
                        weight: .semibold,
                        design: .monospaced
                    )
                )
                .padding([.top], 20)
            Text(isDragging ? "drag" : "stop")
                .font(.body)
                .padding(.top, -20)
        }
        .foregroundStyle(.white)
    }

    HStack(spacing: 18.5) {
        LiteSlider(
            value: $value,
            in: smallRange,
            thumbView: thumbView
        )
        .sliderLengthBehavior(
            .expandable(direction: .center, maxLength: 500)
        )
        .sliderTrackColor(Color(hex: 0xFFD6C2, alpha: 0.5))
        .sliderProgressColor(Color(hex: 0xFF5733, alpha: 0.75))

        LiteSlider(
            value: $value,
            in: smallRange,
            step: 25,
            thumbView: thumbView
        )
        .sliderLengthBehavior(.fixed(length: 300))
        .sliderTrackColor(Color(hex: 0xD2F0EC, alpha: 0.5))
        .sliderProgressColor(Color(hex: 0x3BA99C, alpha: 0.8))

        LiteSlider(
            value: $value,
            in: largeRange,
            thumbView: thumbView
        )
        .sliderLengthBehavior(.dynamic)
        .sliderTrackColor(Color(hex: 0xEBD5F5, alpha: 0.5))
        .sliderProgressColor(Color(hex: 0x9B59B6, alpha: 0.75))
        .sliderAccessibilityValueStep(10)
        .sliderAccessibilityValueFormatter(oneDecimalDigitFormatter)
    }
    .sliderThickness(100)
    .sliderRadius(30)
    .sliderStroke(Color(hex: 0x000000, alpha: 0.3), lineWidth: 0.3)
    .padding(50)
}
