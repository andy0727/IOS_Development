//
//  ViewController.swift
//  Autolayout
//
//  Created by Andy Zhu on 8/16/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pswField: UITextField!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var pswLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pswField.delegate = self
        loginField.delegate = self
        updateUI()
    }
    
    
    var secure: Bool = false {didSet{updateUI()}}
    
    
    // this is to hide the keyboard when click on return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func updateUI(){
        pswField.secureTextEntry = secure
        pswLabel.text = secure ? "Secured Password" : "Password"
        nameLabel.text = loggedinUser?.name
        companyLabel.text = loggedinUser?.company
        image = loggedinUser?.image
    }
    
    
    @IBAction func changeSecurity(sender: UIButton) {
        secure = !secure
    }
    
    var loggedinUser :User? {didSet{updateUI()}}
    @IBAction func login(sender: UIButton) {
        loggedinUser =  User.login(loginField.text ?? "", password: pswField.text ?? "")
    }
    
    var image: UIImage?{
        get{
            return imageView.image
        }set{
            imageView.image = newValue
            if let constaintView = imageView{
                if let newImage = image{
                    aspectRatioConstraint = NSLayoutConstraint(
                        item: constaintView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: constaintView,
                        attribute: .Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                }else{
                    aspectRatioConstraint = nil
                }
            }
        }
    }
    
    var aspectRatioConstraint: NSLayoutConstraint? {
        willSet{
            if let exsistingConstarint = aspectRatioConstraint{
                view.removeConstraint(exsistingConstarint)
            }
        }
        didSet{
            if let newConstraint = aspectRatioConstraint{
                view.addConstraint(newConstraint)
            }
        }
    }
}

extension User{
    var image: UIImage? {
        if let image = UIImage(named: login){
            return image
        }else{ return UIImage(named: "unknown_user")}
    }
    
}

extension UIImage{
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}

