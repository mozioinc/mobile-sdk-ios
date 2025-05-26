//
//  SampleAppApp.swift
//  SampleApp
//
//  Created by Yiannis Josephides on 27/01/2025.
//

import Mozio
import SwiftUI

@main
struct MozioDemoApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: ApplicationDelegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .tint(.black)
        }
    }
}

extension UINavigationController {
    // Hides back button text
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}

class ApplicationDelegate: NSObject, UIApplicationDelegate {
    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        let configuration = MozioSDK.Configuration(
            environment: .staging,
            apiKey: "<YOUR_MOZIO_API_KEY>",
            googleMapsAPIKey: "<YOUR_GOOGLE_MAPS_API_KEY",
            appearance: .default
        )
        MozioSDK.shared.setup(configuration: configuration)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        MozioSDK.shared.application.scene(scene, continue: userActivity)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        MozioSDK.shared.application.scene(scene, openURLContexts: URLContexts)
    }
}
