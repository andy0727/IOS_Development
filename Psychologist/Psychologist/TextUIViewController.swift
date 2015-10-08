//
//  TextUIViewController.swift
//  Psychologist
//
//  Created by Andy Zhu on 8/16/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class TextUIViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    {
        didSet{
            textView.text = text
        }
    }
    var text: String = ""{
        didSet{
            textView?.text = text
        }
    }
    override var preferredContentSize: CGSize{
        get{
            if textView != nil && presentingViewController != nil{
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else{
                return super.preferredContentSize
            }
        }
        set{
            super.preferredContentSize = newValue
        }
    }
}
