import SwiftUI

// MARK: - View Modifiers

extension View {

    /// Sets a `NumberFormatter` used to format the slider’s accessibility
    /// value.
    ///
    /// By default, the formatter rounds values to the nearest integer.
    /// - Parameter numberFormatter: The formatter to convert slider values to
    /// strings.
    /// - Returns: A view with the provided accessibility formatter applied.
    public func sliderAccessibilityValueFormatter(
        _ numberFormatter: NumberFormatter
    ) -> some View {
        environment(\.liteSliderAccessibilityValueFormatter, numberFormatter)
    }

    /// Sets the accessibility step value for the slider, indicating the amount
    /// by which the slider's value should increment or decrement for
    /// accessibility actions.
    ///
    /// Defaults to the step size if provided, or 1/10th of the slider range
    /// otherwise.
    ///
    /// - Parameter accessibilityValueStep: The step size for accessibility
    /// adjustments.
    /// - Returns: A view with the provided accessibility step applied.
    public func sliderAccessibilityValueStep(
        _ accessibilityValueStep: Double
    ) -> some View {
        environment(\.liteSliderAccessibilityValueStep, accessibilityValueStep)
    }
}

// MARK: - Environment Keys

private struct LiteSliderAccessibilityValueFormatterKey: EnvironmentKey {
    static let defaultValue: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}

private struct LiteSliderAccessibilityValueStepKey: EnvironmentKey {
    static let defaultValue: Double? = nil
}

// MARK: - EnvironmentValues

extension EnvironmentValues {

    var liteSliderAccessibilityValueFormatter: NumberFormatter {
        get { self[LiteSliderAccessibilityValueFormatterKey.self] }
        set { self[LiteSliderAccessibilityValueFormatterKey.self] = newValue }
    }

    var liteSliderAccessibilityValueStep: Double? {
        get { self[LiteSliderAccessibilityValueStepKey.self] }
        set { self[LiteSliderAccessibilityValueStepKey.self] = newValue }
    }
}
