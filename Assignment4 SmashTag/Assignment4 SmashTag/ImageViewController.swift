//
//  ImageViewController.swift
//  Assignment4 SmashTag
//
//  Created by Andy Zhu on 8/30/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 2.0
        }
    }
    var url: NSURL?{
        didSet{
            image = nil
            if view.window != nil{
                fetchImage()
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var image: UIImage? {
        didSet{
            imageView.image = image
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    var imageView = UIImageView()
    
    func fetchImage(){
        if let imageUrl = url{
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)){ () -> Void in
                let imageData = NSData(contentsOfURL: imageUrl)
                dispatch_async(dispatch_get_main_queue()){ [unowned self] in
                    if imageData != nil{
                        self.image = UIImage(data: imageData!)
                    }else{
                        self.image = nil
                    }
                }
            }
        }
    }
    
    // Mark: - Delegate for scrollView
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // Mark: -initialize the view by connecting everything
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }


}
