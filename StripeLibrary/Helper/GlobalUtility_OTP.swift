//
//  GlobalUtility.swift
//
//  Created by Binal Shah on 06/09/19.
//  Copyright © 2019 Hidden Brains. All rights reserved.
//
//

import UIKit
import SwiftMessages

@objc class GlobalUtility_OTP: NSObject {
    
    /// Shows toast sucess message on top with the given message.
    class func showSuccessMessage(withStatus message : String?)
    {
        if message == nil {
            return
        }
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.button?.isHidden = true
        
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        view.bodyLabel?.font = UIFont.systemFont(ofSize: 14.0)
        view.configureContent(title: "", body: message!)
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.ignoreDuplicates = true
        config.interactiveHide = true
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: view)
    }
    
    /// Shows toast error message on top with the given message.
    class func showErrorMessage(withStatus message : String?)
    {
        if message == nil {
            return
        }
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.button?.isHidden = true
        
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        view.bodyLabel?.font = UIFont.systemFont(ofSize: 14.0)
        view.configureContent(title: "", body: message!)
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.ignoreDuplicates = true
        config.interactiveHide = true
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: view)
    }

}

