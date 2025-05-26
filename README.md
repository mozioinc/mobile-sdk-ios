# Mozio iOS SDK Integration Guide

Welcome to the Mozio iOS SDK! This repository includes a sample app to help you quickly integrate and test the SDK in your iOS projects. Follow this guide to set up the SDK, customize it to your needs, and begin utilizing its powerful features.

You can find a complete sample project in the `Sample/SampleApp` directory that demonstrates the SDK integration and usage.

## 📦 Setup the SDK

### 1. Add Package Dependency

Add the Mozio SDK to your project using Swift Package Manager:

1. In Xcode, go to File > Add Packages...
2. Enter the Mozio SDK repository URL: `https://github.com/mozioinc/mobile-sdk-ios`
3. Select the version you want to use (we recommend using the latest stable version)
4. Choose your target where you want to use the SDK

### 2. Import the SDK

In your Swift files where you'll use the SDK, import the module:

```swift
import Mozio
```

## 🛠 Initialize the SDK

Initialize the SDK in your `SceneDelegate` or `AppDelegate`:

```swift
import Mozio
import UIKit

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        let configuration = MozioSDK.Configuration(
            environment: .production, // Use .staging for development
            apiKey: "<YOUR_MOZIO_API_KEY>", // Get this from Mozio
            googleMapsAPIKey: "<YOUR_GOOGLE_MAPS_API_KEY>", // Required for map functionality
            appearance: .default // Use .default or skip for default appearance
        )
        MozioSDK.shared.setup(configuration: configuration)
    }

    // Required for handling payments and 3DS verification
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        MozioSDK.shared.application.scene(scene, continue: userActivity)
    }

    // Required for handling payments and 3DS verification
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        MozioSDK.shared.application.scene(scene, openURLContexts: URLContexts)
    }
}
```

Use `.production` or `.staging` based on your build configuration. Replace `YOUR_MOZIO_API_KEY` with the appropriate API key provided by Mozio and `YOUR_GOOGLE_MAPS_API_KEY` with your Google Maps API key.

## 🚀 Using the SDK

### SearchRideView Parameters

The `searchRideView` function accepts several optional parameters with sensible defaults:

```swift
MozioSDK.views.searchRideView(
    displayResultsWhileLoading: Bool = false,  // Wait for all results before displaying
    searchResultsSanitizer: ([Ride]) -> [Ride] = { $0 },  // Transform or filter rides, default returns all
    onBookingEvent: (BookingEvent) -> Void = { _ in }  // Handle booking events
)
```

- `displayResultsWhileLoading`: When `true` shows search results as they arrive. When `false` (default) waits for all results before displaying.
- `searchResultsSanitizer`: Optional closure to transform, filter, or sort search results. By default, no transformation is applied.
- `onBookingEvent`: Optional closure to handle booking events. If not provided, events are logged internally but not exposed to the app.

### SwiftUI Integration

```swift
import Mozio
import SwiftUI

struct ContentView: View {
    @State private var isSearchRidesPresented = false
    
    var body: some View {
        Button("Search Rides") {
            isSearchRidesPresented = true
        }
        .fullScreenCover(isPresented: $isSearchRidesPresented) {
            // Basic usage with defaults
            MozioSDK.views.searchRideView()
            
            // Or with custom configuration
            MozioSDK.views.searchRideView(
                displayResultsWhileLoading: true,  // Show results immediately
                searchResultsSanitizer: { rides in
                    // Example: Filter and sort rides
                    rides
                        .filter { $0.price.amount < 100 }  // Only show rides under $100
                        .sorted { $0.price.amount < $1.price.amount }  // Sort by price
                },
                onBookingEvent: { bookingEvent in
                    switch bookingEvent {
                        case .success(let confirmationNumbers):
                            // Handle successful bookings
                            for number in confirmationNumbers {
                                print("Booking confirmed: \(number)")
                            }
                            
                        case .failure(let error):
                            // Handle booking failure
                            print("Booking failed: \(error.localizedDescription)")
                    }
                }
            )
        }
    }
}
```

### UIKit Integration

```swift
import Mozio
import SwiftUI

struct ContentView: View {
    var body: some View {
        MozioSDK.views.searchRideView()
            .mozioLocalizationContext() // Configure localization context for this view
    }
}

class ViewController: UIViewController {
    func showSearchRides() {
        // Basic usage with defaults
        let searchRidesView = MozioSDK.views.searchRideView()
            .mozioLocalizationContext() // Configure localization context for this view
        let searchRidesVC = UIHostingController(rootView: searchRidesView)
        present(searchRidesVC, animated: true)
    }
}
```

## 🎨 Customization

### Theme Colors

Customize the SDK's appearance through `MozioSDK.shared.configuration.appearance`:

```swift
// Configure colors
MozioSDK.shared.configuration.appearance.colors.primaryColor = .blue
MozioSDK.shared.configuration.appearance.colors.secondaryColor = .red
```

Available color properties:

- `primaryColor`: Main brand color for CTAs and notifications
- `secondaryColor`: Secondary brand color for selections and tooltips
- `foreground`: Text color (default: black in light mode, white in dark mode)
- `background`: Background color (default: white in light mode, black in dark mode)
- `routeColor`: Color for routes and waypoints on maps (default: blue)
- `information`: Color for informative elements (default: blue)
- `error`: Color for error states (default: red)
- `success`: Color for success states (default: green)
- `neutral1`: Light gray UI elements
- `neutral2`: Medium gray UI elements
- `neutral3`: Dark gray UI elements

> **Note**: Colors should be provided as SwiftUI `Color` values. Use `Color.init(uiColor:)` to convert from UIKit colors.

### Booking Events

The `searchRideView` accepts a closure that provides real-time updates about the booking process through the `BookingEvent` enum:

```swift
public enum BookingEvent {
    case success([String])  // Booking confirmation numbers
    case failure(Error)    // Error details
}
```

1. `.success([String])`
   - Triggered when a booking is successfully completed
   - Each string in the array represents a unique booking confirmation number

2. `.failure(Error)`
   - Triggered if the booking process fails
   - The `Error` object contains details about what went wrong

## 🐞 Reporting Issues

If you encounter any issues or have questions, please open an issue in the Mozio iOS SDK repository.
