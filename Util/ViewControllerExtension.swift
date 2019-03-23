//
//  ViewControllerExtension.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import Rswift

extension UIViewController {

    func showError(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: R.string.localizable.buttonOkay(), style: .default)
        alertController.addAction(okAction)
        
        alertController.view.tintColor = App.Color.alertControllerTintColor
        alertController.view.backgroundColor = App.Color.alertControllerBackgroundColor
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func askQuestion(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: R.string.localizable.buttonCancel(), style: .cancel)
        alertController.addAction(cancelAction)
        
        let buttonAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        alertController.addAction(buttonAction)
        
        alertController.view.tintColor = App.Color.alertControllerTintColor
        alertController.view.backgroundColor = App.Color.alertControllerBackgroundColor
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showToast(message: String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height - 150, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = App.Font.alertTextFont
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
                toastLabel.removeFromSuperview()
            })
    }
}
