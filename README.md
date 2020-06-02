# StripeCardController

StripeCardController allows you to use custom UI for Credit Card details Input. you can easily add and customize the UI as per your project need in very simple way. You can preview your inputs in virtual card.

![Card UI](https://i.imgur.com/euiL0RK.png)  ![enter image description here](https://i.imgur.com/41eRyeY.png)

## Getting Started

### Prerequisites

1. Minimum deployment target: iOS 10
2. Orientation: Portrait Only

### Dependency
* try ```pod 'Stripe'``` 

## Installation

You just need to drag and drop ```StripeCardController``` folder to your project.

Open your  `AppDelegate.swift`  file, and add these codes

```swift

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    Stripe.setDefaultPublishableKey("your_stripe_key")
    STPAPIClient.shared().publishableKey = "your_stripe_key"
    return  true
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
    return  false
}

// This method handles opening universal link URLs (e.g., "https://example.com/stripe_ios_callback")
private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    if userActivity.activityType  ==  NSUserActivityTypeBrowsingWeb {
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
    return  false
}
```

## Usage

### Implementing Custom Stripe UI

Add following code to your ViewController or on Action

```swift
StripeCardController.show(with: StripeUIConfig(), from: self) { (token, message, success, controller) in
    if success {
        controller.dismiss(animated: true, completion: nil)
        print("Stripe Token\n\(token ?? "N/A")")
    } else {
        print(message)
    }
}
```

#### • UI Configuration / Customization

```swift
var title: String = "Credit Card Payment"
var screenBGColor: UIColor = .white
var paymentBtnTitle: String = "Make Payment"
var paymentBtnBGColor: UIColor = .black
var paymentBtnFGColor: UIColor = .white
var paymentBtnFont: UIFont = UIFont.systemFont(ofSize: 17)
var cardLayoutBGColor: UIColor = .black
var cardLayoutLabelColor: UIColor = .lightGray
var cardLayoutFGColor: UIColor = .white
var cardLayoutFont: UIFont = UIFont.systemFont(ofSize: 12)
var inputFieldLabelColor: UIColor = .lightGray
var inputFieldTextColor: UIColor = .black
var inputFieldSeparatorColor: UIColor = .lightGray
var inputFieldFont: UIFont = UIFont.systemFont(ofSize: 12)
```

### Implementing Default UI

Add following code to your action

```swift
func showDefaultUI() {
    let config = STPPaymentConfiguration()
    let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.default())
    viewController.apiClient = StripeAPIClient()
    viewController.delegate = self
    let navigationController = UINavigationController(rootViewController: viewController)
    present(navigationController, animated: true, completion: nil)
}

extension  ViewController: STPAddCardViewControllerDelegate {

    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        addCardViewController.dismiss(animated: true, completion: nil)
        print("STPPaymentMethod StripeId : \(paymentMethod.stripeId)")
    }

    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        addCardViewController?.dismiss(animated: true, completion: nil)
    }

    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        addCardViewController.dismiss(animated: true, completion: nil)
        print("Stripe Token : \(token.tokenId)")
    }
}
```
# License

```
Copyright 2020

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and

limitations under the License.
```
