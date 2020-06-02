//
//  StripeUIConfig.swift
//  StripeLibrary
//
//  Created by hb on 02/06/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

class StripeUIConfig {
    var title: String = "Credit Card Payment"
    var screenBGColor: UIColor = .white
    
    var paymentBtnTitle: String = "Make Payment"
    var paymentBtnBGColor: UIColor = .black
    var paymentBtnFGColor: UIColor = .white
    var paymentBtnFont: UIFont = UIFont.init(name: "Helvetica-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17)

    var cardLayoutBGColor: UIColor = .black
    var cardLayoutLabelColor: UIColor = .lightGray
    var cardLayoutFGColor: UIColor = .white
    var cardLayoutFont: UIFont = UIFont.init(name: "Helvetica-Light", size: 17) ?? UIFont.systemFont(ofSize: 12)
    
    var inputFieldLabelColor: UIColor = .lightGray
    var inputFieldTextColor: UIColor = .black
    var inputFieldSeparatorColor: UIColor = .lightGray
    var inputFieldFont: UIFont = UIFont.init(name: "Helvetica", size: 17) ?? UIFont.systemFont(ofSize: 12)
}
