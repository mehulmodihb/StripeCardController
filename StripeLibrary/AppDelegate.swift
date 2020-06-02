//
//  AppDelegate.swift
//  StripeLibrary
//
//  Created by hb on 27/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Stripe.setDefaultPublishableKey("pk_test_TYooMQauvdEDq54NiTphI7jx")
        STPAPIClient.shared().publishableKey = "pk_test_TYooMQauvdEDq54NiTphI7jx"
        return true
    }
    
    // This method handles opening native URLs (e.g., "your-app://")
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let stripeHandled = Stripe.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        } else {
            // This was not a stripe url – do whatever url handling your app
            // normally does, if any.
        }
        return false
    }

    // This method handles opening universal link URLs (e.g., "https://example.com/stripe_ios_callback")
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = Stripe.handleURLCallback(with: url)
                if (stripeHandled) {
                    return true
                } else {
                    // This was not a stripe url – do whatever url handling your app
                    // normally does, if any.
                }
            }
        }
        return false
    }

}

