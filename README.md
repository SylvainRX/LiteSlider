# LiteSlider

**LiteSlider** is a customizable, vertical slider component for SwiftUI. It supports dynamic, fixed, or expandable track lengths, and provides full flexibility over thumb appearance, and styling, and accessibility.

<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/SylvainRX/sylvainrx.github.io/main/LiteSlider/demo/dark.gif">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/SylvainRX/sylvainrx.github.io/main/LiteSlider/demo/light.gif">
    <img alt="LiteSlider vertical drag demo in dark mode" src="https://raw.githubusercontent.com/SylvainRX/sylvainrx.github.io/main/LiteSlider/demo/dark.gif">
  </picture>
</div>

[![Swift](https://img.shields.io/badge/Swift%206.1-FA7343?logo=swift&logoColor=white)](https://swift.org) [![GitHub stars](https://img.shields.io/github/stars/SylvainRX/LiteSlider?style=flat&color=yellow&label=Stars)](https://github.com/SylvainRX/LiteSlider/stargazers) [![License](https://img.shields.io/badge/License-Apache%202.0-blue)](https://github.com/SylvainRX/LiteSlider/blob/main/LICENSE) ![iOS](https://img.shields.io/badge/iOS-17.0+-lightgray?logo=apple&logoColor=white) ![iPadOS](https://img.shields.io/badge/iPadOS-17.0+-lightgray?logo=apple&logoColor=white)

## Features

- Vertical slider for SwiftUI
- Dynamic, fixed, or expandable track length behaviors
- Customizable thumb views with drag-state awareness
- Smooth drag gestures with elastic drag effect customization
- Extensive track styling options (thickness, radius, colors, stroke)
- Fine-grained control over drag elasticity (offset, compression, expansion)
- Full accessibility support with custom value formatting and step size
- Support for binding to continuous or stepped values

## Usage

### Getting Started

By default, this creates a vertically oriented slider with a dynamic height that automatically fills its parent view. It adapts to the available space and requires minimal configuration to get up and running.
```swift
LiteSlider(value: $value, in: 0...100)
```

### Full customization over thumb view, value formatting, and track behavior
-   A range from 0 to 100, stepping by 5.
-   A  **custom thumb**  displaying the current value as a number, growing in size when dragged.
-   An  **expandable track**  that grows up to 500 points from the center as the container allows.
-   A red track with a transparent background and a solid red progress fill.
```swift
@State var value: Double = 50

LiteSlider(
    value: $value,
    in: 0...100,
    step: 5,
    thumbView: thumbView
)
.sliderLengthBehavior(.expandable(direction: .center, maxLength: 500))
.sliderTrackColor(.red.opacity(0.5))
.sliderProgressColor(.red)

let thumbView: (Bool) -> some View = { isDragging in
    Text("\(Int(value))")
        .font(.system(size: isDragging ? 40 : 32))
        .padding([.top], 30)
}
```
More customization options, including layout behavior, thumb rendering, color customization, and gesture interaction, are described in the [documentation](https://sylvainrx.github.io/LiteSlider/documentation/liteslider/swiftuicore/view).

## Installation

### Swift Package Manager (SPM)

In **Xcode**:

1. Open your project
2. Go to `File` > `Add Packages Dependencies...`
3. Enter the URL:

```
https://github.com/SylvainRX/LiteSlider.git
```

4. Select the version and add the package

## Requirements

- iOS 17 and iPadOS 17



## Documentation

https://sylvainrx.github.io/LiteSlider/

## License

**LiteSlider** is released under the Apache 2.0 license.
