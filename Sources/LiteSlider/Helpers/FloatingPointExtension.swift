extension FloatingPoint {

    func ratio(in range: ClosedRange<Self>) -> Self {
        (self - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
}

