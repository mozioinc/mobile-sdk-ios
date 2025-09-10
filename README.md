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

## 🚗 Reservation Details & Live Tracking

The SDK includes a comprehensive reservation details and live tracking feature that allows users to monitor their ride status and driver location in real-time.

### Features

- **Real-time driver location updates** on an interactive map
- **Live status updates** (driver en route, arrived, heading to destination, etc.)
- **Driver contact information** with direct calling capability
- **Vehicle details** including make, model, color, and license plate
- **ETA updates** with remaining time to pickup/destination
- **Pickup instructions** with detailed guidance

### Integration Example

The tracking feature is accessed through the **Find Reservation** functionality. Call `MozioSDK.shared.findReservation()` to start the flow:

```swift
// Start the find reservation flow
//
// This presents a bottom sheet where users:
// 1. Enter reservation code and last name
// 2. View reservation details screen
// 3. Tap "Track ride" button to start live tracking

// The SDK automatically handles:
// - Find reservation bottom sheet presentation
// - Reservation details screen with tracking button
// - Full-screen tracking view with real-time updates
// - Error handling for invalid reservation codes
MozioSDK.shared.findReservation()
```

### How SDK Tracking Works with Mozio Driver App

The SDK tracking system provides a seamless real-time experience that synchronizes with the **[Mozio Driver app](https://apps.apple.com/us/app/mozio-driver/id1436530159)**. Here's the detailed step-by-step workflow:

#### Step 1: Driver Assignment - Tracking Not Available Yet
- **Mozio Driver App:** 
    - Driver receives a new reservation assignment
- **SDK Behavior:**
    - Reservation status shows as `Not Started`
    - Users see reservation details (pickup time, assigned driver and vehicled details, pickup and destination location etc)
    - Tracking button checks reservation status when tapped
        - If it's still `Not Started`, it shows an alert to the user
        - If it reaches a trackable state, it presents the full-screen tracking view with real-time updates

<div align="center">
    <img width="30%" alt="Screenshot 2025-09-01 at 11 18 04 AM" src="https://github.com/user-attachments/assets/440391a5-359a-4368-a694-6c3dec58a13a" />
    <img width="30%" alt="Screenshot 2025-09-01 at 11 18 18 AM" src="https://github.com/user-attachments/assets/d9dbdeb8-0f4b-43ab-a92c-6bed5884a03b" />
</div>

#### Step 2: Driver Departs for Pickup - Tracking Begins
- **Mozio Driver App:** 
    - Driver swipes to indicate they are departing for pickup location
- **SDK Behavior:**
    - Reservation status updates to `Driver En Route`
    - **Tracking becomes available** 
    - When user taps "Track Ride", the full-screen tracking view opens
    - Tracking title shows `Driver on their way`
    - **Real-time driver location updates begin** on the map
        - ETA to pickup location is displayed and continuously updated
        - Driver information panel shows contact details and vehicle info
        - Status banner shows "Your driver is on the way to pick you up"

<div align="center">
    <img width="30%" alt="Screenshot 2025-09-01 at 11 19 47 AM" src="https://github.com/user-attachments/assets/3354c8b8-91c8-48ca-a44b-265144d22a55" />
</div>

#### Step 3: Driver Arrives at Pickup Point
- **Mozio Driver App:** 
    - Driver arrives at pickup location and updates status
- **SDK Behavior:**
    - Reservation status updates to `Driver Arrived`
    - Tracking title shows `Your driver has arrived`
    - **Driver location pin shows at pickup point** on the map
    - Status banner changes to "Your driver has arrived at the pickup location"
    - **Pickup instructions are prominently displayed** to guide passenger
    - Driver contact information remains accessible for coordination
    - **No-show handling:** If passenger doesn't appear, driver can mark as no-show, updating SDK status to `No Show`

<div align="center">
    <img width="30%" alt="Screenshot 2025-09-01 at 11 20 59 AM" src="https://github.com/user-attachments/assets/bce9f267-25a6-40b5-999d-6dcc6e95e1cc" />
</div>

#### Step 4: En Route to Destination
- **Mozio Driver App:** 
    - Driver confirms passenger pickup and begins journey to destination
- **SDK Behavior:**
    - Reservation status updates to `In Progress`
    - Tracking title changes to `Heading to [destination]`
    - **ETA switches from pickup to destination** timing
    - Real-time route visualization shows on map with driver's current position
    - Status banner shows "You're on your way to [destination]"
    - **Continuous location and ETA updates** as driver progresses along route
    - Driver remains contactable throughout the journey

<div align="center">
    <img width="30%" alt="Screenshot 2025-09-01 at 11 22 46 AM" src="https://github.com/user-attachments/assets/ff80ef5b-4702-48fb-a7ae-277328a1f338" />
</div>

#### Step 5: Ride Completed
- **Mozio Driver App:** 
    - Driver arrives at destination, drops off passenger and swipes to complete the ride
- **SDK Behavior:**
    - Reservation status updates to `Completed`
    - Tracking title shows ride completion status
    - **Animated celebration view appears** confirming successful ride completion
    - Final trip summary is displayed with completion time
    - Tracking automatically stops and view can be dismissed

<div align="center">
    <img width="30%" alt="Screenshot 2025-09-01 at 11 16 24 AM" src="https://github.com/user-attachments/assets/84937d09-252b-4695-92f9-53ee4a82e5c6" />
    <img width="30%" alt="Screenshot 2025-09-01 at 11 15 48 AM" src="https://github.com/user-attachments/assets/9edde139-976e-4ad3-a263-7c8a916ac17b" />
</div>
    
---

### 🛰️ How to simulate the ride live tracking
You can run a full end-to-end simulation to see how live tracking looks in the sdk and in your app.  

#### 1. Book a Test Ride  

Use the following settings when booking:  

- **Pickup time:** within the next 3 hours.  
- **Routes (choose one):**  
  - *Short ride:* **44 Tehama Street, San Francisco, CA, USA** → **301 Van Ness Avenue, San Francisco, CA, USA**  
  - *Long ride:* **SFO: San Francisco, CA - San Francisco** → **44 Tehama Street, San Francisco, CA, USA**  
- **Provider:** select *Tracking Testing Provider*.  

#### 2. Run the Simulation Script

From your terminal, run:  

```bash
./run_driver_live_tracking_simulation.sh CONFIRMATION_NUMBER LAST_NAME [SPEEDUP]
```

`CONFIRMATION_NUMBER` → the `MOZxxxxx` ID from your booking.  
`LAST_NAME` → passenger’s last name.  
`SPEEDUP` (optional) → multiplier for how fast the trip is simulated.  
Default: `1` (real-time). For longer rides, increase to `5`, `10`, etc.

When the script starts, it will also print a `simulation_id`. Keep this ID handy, it uniquely identifies your simulation in the logs if you need to contact us for any troubleshooting.

#### 3. View the results
If everything runs correctly, the ride will begin broadcasting live tracking.

- Open the **Find Reservation** screen in the app using the *Confirmation Number* and *Passenger's Last Name*
- You should see a simulated car moving along the route 🚗💨 and ride status updates!

#### 🛠️ Troubleshooting

If you don’t see the car moving on the map:
- ✅ Double-check your booking: ensure pickup time is within 3 hours and you chose *Tracking Testing Provider*. For the records, you could book also at another time, but live-tracking can be starte only when the current time is next to the pickup time.
- ✅ Confirm your inputs: `CONFIRMATION_NUMBER` must be the `MOZxxxxx` ID, and the passenger’s last name must match exactly.
- ✅ Adjust the speedup: for longer rides, use a higher `SPEEDUP` value so the car moves at a visible pace.
- ✅ Wait a moment: tracking updates are sent periodically; it may take a few seconds for the car to appear.

Still stuck? Reach out to the team with your `CONFIRMATION_NUMBER`, `LAST_NAME`, and `simulation_id` so we can help investigate.

---

## 🐞 Reporting Issues

If you encounter any issues or have questions, please open an issue in the Mozio iOS SDK repository.
