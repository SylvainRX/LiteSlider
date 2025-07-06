import Foundation

extension Double {

    func rounded(to step: Double) -> Double {
        step != 0 ? (self / step).rounded() * step : self
    }
}
