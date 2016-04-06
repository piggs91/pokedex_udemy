//
//  BlurredView.swift
//  pokedex
//
//  Created by Ravi Rathore on 4/6/16.
//  Copyright © 2016 Ravi Rathore. All rights reserved.
//
//

import Foundation
import UIKit

class BlurredActivityIndicatorView  {
    private var activityIndicator :UIActivityIndicatorView!
    private var newView : UIView!
    static let sharedInstance = BlurredActivityIndicatorView()
    private init(){} // A private initializer to make sure that we create only one instance
    
    
    
    
    func startActivityIndicator(containerView : UIView){
        activityIndicator  = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        newView = UIView()
        newView.backgroundColor = UIColor.blackColor()
        newView.alpha = 0.3
        newView.addSubview(activityIndicator)
        containerView.addSubview(newView)
        let views = ["view":newView , "activityIndicator":activityIndicator]
        newView.translatesAutoresizingMaskIntoConstraints = false
        var contraints = [NSLayoutConstraint]()
        let h = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: [], metrics: nil, views: views)
        contraints += h
        let v = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view]-|", options: [], metrics: nil, views: views)
        contraints += v
        let h1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[activityIndicator(40)]-|", options:NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
        let v1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[activityIndicator(40)]-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
        contraints += h1
        contraints += v1
        
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activateConstraints(contraints)
    }
    
    func stopActivityIndicator(){
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        self.newView.removeFromSuperview()
    }
    
    
}