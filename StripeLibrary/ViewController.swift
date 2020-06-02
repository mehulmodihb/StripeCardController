//
//  ViewController.swift
//  StripeLibrary
//
//  Created by hb on 28/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit
import Stripe

class ViewController: UIViewController {
    
    @IBOutlet private weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMessage.numberOfLines = 0
        lblMessage.textAlignment = .center
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showCustomUI() {
        StripeCardController.show(with: StripeUIConfig(), from: self) { (token, message, success, controller) in
            print(token ?? "")
            print(message ?? "")
            if success {
                controller.dismiss(animated: true, completion: nil)
                self.lblMessage.text = "Stripe Token\n\(token ?? "N/A")"
            } else {
                GlobalUtility_OTP.showErrorMessage(withStatus: message)
            }
        }
    }
    
    @IBAction func showDefaultUI() {
        self.lblMessage.text = nil
        let config = STPPaymentConfiguration()
        let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.default())
        viewController.apiClient = StripeAPIClient()
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        addCardViewController.dismiss(animated: true, completion: nil)
        self.lblMessage.text = "STPPaymentMethod StripeId : \(paymentMethod.stripeId)"
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        addCardViewController.dismiss(animated: true, completion: nil)
        self.lblMessage.text = "Stripe Token : \(token.tokenId)"
    }

}
