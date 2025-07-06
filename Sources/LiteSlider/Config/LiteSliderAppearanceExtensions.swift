import SwiftUI

// MARK: - LiteSliderExpansionDirection Helpers

extension LiteSliderExpansionDirection {
    /// Determines the alignment of the parent view based on the slider's expansion direction.
    var parentViewAlignment: Alignment {
        switch self {
        case .upward: return .bottom
        case .downward: return .top
        case .center: return .center
        }
    }
}

// MARK: - LiteSliderLengthBehavior Helpers

extension LiteSliderLengthBehavior {

    /// Extracts the fixed length if available, or returns nil for dynamic.
    var length: CGFloat? {
        switch self {
        case .dynamic: return nil
        case let .fixed(length): return length
        case let .expandable(_, length): return length
        }
    }

    /// Returns the expansion direction if the track is expandable.
    var expansionDirection: LiteSliderExpansionDirection? {
        guard case let .expandable(direction, _) = self else { return nil }
        return direction
    }
}
