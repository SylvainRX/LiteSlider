import SwiftUI

// MARK: - LiteSlider OnEnded

extension View {

    /// Sets a closure to be called when the user finishes dragging the slider.
    ///
    /// - Parameter onEnded: The closure to run when dragging ends.
    ///
    /// Default: No action.
    public func onSliderDragEnded(
        _ onEnded: @escaping () -> Void
    ) -> some View {
        environment(\.liteSliderOnEnded, onEnded)
    }
}

private struct LiteSliderOnEndedKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {

    var liteSliderOnEnded: () -> Void {
        get { self[LiteSliderOnEndedKey.self] }
        set { self[LiteSliderOnEndedKey.self] = newValue }
    }
}
