//
//  diggerImg.swift
//  mylittlemonster
//
//  Created by David Clare on 2/19/16.
//  Copyright © 2016 David Clare. All rights reserved.
//


import Foundation
import UIKit

class heroimg: UIImageView {
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        playIdleAnimation()
    }
    
    
    func playIdleAnimation(){
        
        self.image = UIImage(named: "walk1.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var x=1 ; x <= 12; x++
        {
            let img = UIImage(named: "walk\(x).png")
            imgArray.append(img!)
        }
        
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
        
        
    }
    
    
    func playDeathAnimation()
    {
        self.image = UIImage(named: "heroDead5.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var x=1 ; x <= 5; x++
        {
            let img = UIImage(named: "heroDead\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
        
    }
    
    
}