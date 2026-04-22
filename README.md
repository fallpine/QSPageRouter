# QSPageRouter

`QSPageRouter` is a lightweight UIKit router for iOS apps.

It provides:

- `currentViewController()` to resolve the top-most visible page
- `push(_ route:)` for navigation stack pushes
- `present(_ route:)` for modal presentation
- `presentSheet(_ route:)` for configurable sheets
- `Routable` protocol support so each module can own its own route definitions

## Requirements

- iOS 16.0+
- Swift 5

## Installation

### CocoaPods

Add this line to your `Podfile`:

```ruby
pod 'QSPageRouter'
```

Then run:

```bash
pod install
```

## Usage

### 1. Define a route

```swift
import UIKit
import QSPageRouter

enum UserRoute: Routable {
    case detail(userID: String)
    case settings

    func buildViewController() -> UIViewController {
        switch self {
        case let .detail(userID):
            return UserDetailViewController(userID: userID)
        case .settings:
            return SettingsViewController()
        }
    }
}
```

### 2. Push a page

```swift
PageRouter.push(UserRoute.detail(userID: "1001"))
```

### 3. Present a page

```swift
PageRouter.present(UserRoute.settings, fullScreen: true)
```

### 4. Present a sheet

```swift
let config = PageRouter.SheetConfiguration(height: 320, showsGrabber: true)
PageRouter.presentSheet(UserRoute.settings, config: config)
```

### 5. Get the current visible controller

```swift
let current = PageRouter.currentViewController()
```

## API

### `Routable`

```swift
public protocol Routable {
    func buildViewController() -> UIViewController
}
```

### `PageRouter`

```swift
PageRouter.currentViewController()
PageRouter.push(_:animated:)
PageRouter.present(_:fullScreen:animated:completion:)
PageRouter.presentSheet(_:config:animated:completion:)
```

## Notes

- `push` returns `false` when the current page is not inside a `UINavigationController`.
- `presentSheet` uses `UISheetPresentationController` and supports custom height and grabber visibility.
- The router itself only depends on `UIKit`.

## License

`QSPageRouter` is available under the MIT license. See the [LICENSE](LICENSE) file for details.
