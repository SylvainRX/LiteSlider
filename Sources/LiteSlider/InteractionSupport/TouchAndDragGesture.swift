import SwiftUI

/// A gesture that begins on touch and tracks dragging movement,
/// calling separate callbacks for start, change, and end phases.
///
/// Unlike a regular `DragGesture`, `TouchAndDragGesture` begins immediately
/// on touch down (no minimum movement), making it useful for sliders or touch-sensitive UIs.
struct TouchAndDragGesture: Gesture {

    // MARK:  Bindings

    @Binding private var isDragging: Bool

    // MARK: Callbacks

    private var onStarted: ((_ location: CGPoint) -> Void)? = nil
    private var onChanged: ((_ location: CGPoint) -> Void)? = nil
    private var onEnded: (() -> Void)? = nil

    // MARK: Initialization

    /// Creates a `TouchAndDragGesture`.
    /// - Parameter isDragging: A binding that will be set to `true` after dragging starts, and `false` when it ends.
    init(isDragging: Binding<Bool>) {
        _isDragging = isDragging
    }

    // MARK: Gesture Body

    var body: some Gesture {
        touchGesture.simultaneously(with: dragGesture)
    }

    private var touchGesture: some Gesture {
        isDragging
            ? nil
            : DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isDragging = true
                    onStarted?(value.location)
                }
                .onEnded { _ in
                    isDragging = false
                    onEnded?()
                }
    }

    private var dragGesture: some Gesture {
        isDragging
            ? DragGesture(minimumDistance: 0)
                .onChanged { value in
                    onChanged?(value.location)
                }
                .onEnded { _ in
                    isDragging = false
                    onEnded?()
                }
            : nil
    }
}

// MARK: - Modifiers

extension TouchAndDragGesture {

    /// Sets the callback to invoke when the gesture starts.
    func onStarted(
        _ onStarted: @escaping (_ location: CGPoint) -> Void
    ) -> Self {
        var copy = self
        copy.onStarted = onStarted
        return copy
    }

    /// Sets the callback to invoke as the gesture changes.
    func onChanged(
        _ onChanged: @escaping (_ location: CGPoint) -> Void
    ) -> Self {
        var copy = self
        copy.onChanged = onChanged
        return copy
    }

    /// Sets the callback to invoke when the gesture ends.
    func onEnded(
        _ onEnded: @escaping () -> Void
    ) -> Self {
        var copy = self
        copy.onEnded = onEnded
        return copy
    }
}
