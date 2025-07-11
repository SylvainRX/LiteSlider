import Foundation

/// Encapsulates layout geometry for a slider track, based on the current
/// ratio, slider size, and thumb size. Computes available space, progress
/// offset, and lengths for drawing the background and progress bar.
struct LiteSliderTrackGeometry {
    let ratio: CGFloat
    let trackLength: CGFloat
    let thumbLength: CGFloat
    let radius: CGFloat

    var backgroundLength: CGFloat {
        availableLength - progressOffset + radius
    }

    var progressLength: CGFloat {
        progressOffset + thumbLength
    }

    var availableLength: CGFloat {
        max(0, trackLength - thumbLength)
    }

    private var progressOffset: CGFloat {
        let offset = ratio * availableLength
        return offset.clamped(to: 0...availableLength)
    }
}
