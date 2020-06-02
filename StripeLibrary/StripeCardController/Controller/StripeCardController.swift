//
//  ViewController.swift
//  StripeLibrary
//
//  Created by hb on 27/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit
import Stripe

class StripeCardController: UIViewController {
    
    @IBOutlet private weak var viewCard: UIView!
    @IBOutlet private weak var imgCard: UIImageView!
    @IBOutlet private weak var lblCardNumber: UILabel!
    @IBOutlet private weak var lblExpiry: UILabel!
    @IBOutlet private weak var lblName: UILabel!

    @IBOutlet private weak var txtCardNumber: UITextField!
    @IBOutlet private weak var txtExpiryDate: UITextField!
    @IBOutlet private weak var txtName: UITextField!
    @IBOutlet private weak var txtCVV: UITextField!
    @IBOutlet private weak var btnPayment: UIButton!
    
    @IBOutlet private var layoutLbls: [UILabel]!
    @IBOutlet private var inputLbls: [UILabel]!
    @IBOutlet private var sepLbls: [UILabel]!

    private var cardType: String = "unknown"
    private var config: StripeUIConfig = StripeUIConfig()
    
    var callBack: ((String?, String?, Bool, StripeCardController) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initalSetup()
    }
    
    private func initalSetup() {
        self.navigationItem.title = config.title
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(close))
        
        view.backgroundColor = config.screenBGColor
        
        btnPayment.setTitle(config.paymentBtnTitle, for: .normal)
        btnPayment.setTitleColor(config.paymentBtnFGColor, for: .normal)
        btnPayment.backgroundColor = config.paymentBtnBGColor
        btnPayment.titleLabel?.font = UIFont.init(name: config.paymentBtnFont.fontName, size: btnPayment.titleLabel!.font.pointSize)

        viewCard.backgroundColor = config.cardLayoutBGColor
        
        configureLabel(label: lblCardNumber, font: config.cardLayoutFont, color: config.cardLayoutFGColor)
        configureLabel(label: lblExpiry, font: config.cardLayoutFont, color: config.cardLayoutFGColor)
        configureLabel(label: lblName, font: config.cardLayoutFont, color: config.cardLayoutFGColor)
        
        for element in layoutLbls {
            configureLabel(label: element, font: config.cardLayoutFont, color: config.cardLayoutLabelColor)
        }
        
        for element in inputLbls {
            configureLabel(label: element, font: config.inputFieldFont, color: config.inputFieldLabelColor)
        }
        
        for element in sepLbls {
            element.backgroundColor = config.inputFieldSeparatorColor
        }
        
        configureTextField(textField: txtCardNumber, font: config.inputFieldFont, color: config.inputFieldTextColor)
        configureTextField(textField: txtExpiryDate, font: config.inputFieldFont, color: config.inputFieldTextColor)
        configureTextField(textField: txtName, font: config.inputFieldFont, color: config.inputFieldTextColor)
        configureTextField(textField: txtCVV, font: config.inputFieldFont, color: config.inputFieldTextColor)

        setupCardInfo()
    }
    
    private func configureLabel(label: UILabel, font: UIFont, color: UIColor) {
        label.font = UIFont.init(name: font.fontName, size: label.font.pointSize)
        label.textColor = color
    }
    
    private func configureTextField(textField: UITextField, font: UIFont, color: UIColor) {
        textField.font = UIFont.init(name: font.fontName, size: textField.font!.pointSize)
        textField.textColor = color
    }
    
    private func getStripeToken() {
        
        let expiry = txtExpiryDate.text?.components(separatedBy: "/")

        let cardParams = STPCardParams()
        cardParams.name = txtName.text ?? ""
        cardParams.number = DECardNumberFormatter().clearNumber(from: txtCardNumber.text ?? "")
        cardParams.expMonth = UInt(Int(expiry?.first ?? "") ?? 12)
        cardParams.expYear = UInt(Int(expiry?.last ?? "") ?? 20)
        cardParams.cvc = txtCVV.text ?? ""
        
        STPAPIClient.shared().createToken(withCard: cardParams) { [weak self] (token, error) in
            guard let weakSelf = self else {return}
            if error == nil{
                weakSelf.callBack?(token?.tokenId, nil, true, weakSelf)
            } else {
                print(error)
                weakSelf.callBack?(nil, error?.localizedDescription, false, weakSelf)
            }
        }
    }
    
    private func setupCardInfo() {
        lblName.text = txtName.text
        lblExpiry.text = txtExpiryDate.text
        imgCard.image = UIImage(named: cardType)
        if (txtCardNumber.text ?? "") == "" {
            lblCardNumber.text = DECardNumberFormatter().cardFormat(for: txtCardNumber.text ?? "")
        } else {
            let string = DECardNumberFormatter().cardFormat(for: txtCardNumber.text ?? "")
            var final = ""
            for i in string.indices[string.startIndex..<string.endIndex] {
                if i < (self.txtCardNumber.text ?? "").endIndex {
                    final.append((self.txtCardNumber.text ?? "")[i])
                } else {
                    final.append(string[i])
                }
            }
            lblCardNumber.text = final
        }
    }
    
    private func validate() -> Bool {
        
        if (lblCardNumber.text ?? "").contains("X") {
            callBack?(nil, "Please enter valid card number", false, self)
            return false
        } else if (lblName.text ?? "").isEmpty {
            callBack?(nil, "Please enter card holder name", false, self)
            return false
        } else if (lblExpiry.text ?? "").isEmpty || (lblExpiry.text ?? "").count < 5 {
            callBack?(nil, "Please enter valid expiry date (MM/YY)", false, self)
            return false
        } else if (txtCVV.text ?? "").isEmpty || (txtCVV.text ?? "").count < 3 {
            callBack?(nil, "Please enter valid security code (cvv)", false, self)
            return false
        }
        return true
    }
    
    @IBAction private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func makePaymentTapped() {
        if validate() {
            getStripeToken()
        }
    }
    
    /// This method is use to show/present Stripe Custom UI Controller
    /// - Parameter config: Object of StripeUIConfig (fonts, colors, titles etc...)
    /// - Parameter from: show from controller
    /// - Parameter callback: In callback you will receive (stripe token object, error message, success or failed, Stripe Controller object)
    class func show(with config: StripeUIConfig, from: UIViewController, callback: @escaping ((String?, String?, Bool, StripeCardController) -> Void)) {
        if let vc = UIStoryboard.init(name: "StripeCard", bundle: Bundle.main).instantiateViewController(withIdentifier: "kStripeCardController") as? StripeCardController {
            vc.config = config
            vc.callBack = callback
            from.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
    }

}

extension StripeCardController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(20)) {
            if textField == self.txtCardNumber {
                self.cardType = "\(DECardNumberFormatter().cardBrand(from: self.txtCardNumber.text ?? ""))" .lowercased()
                self.txtCardNumber.text = DECardNumberFormatter().number(from: self.txtCardNumber.text ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            } else if textField == self.txtExpiryDate {
                self.txtExpiryDate.text = DECardNumberFormatter().expiry(from: self.txtExpiryDate.text ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            self.setupCardInfo()
        }
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        if textField == self.txtCVV {
           return (textField.text?.appending(string).count ?? 0) <= 3
        }
        return true
    }
}

