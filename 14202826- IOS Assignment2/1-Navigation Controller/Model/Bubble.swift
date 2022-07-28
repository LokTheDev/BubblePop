//
//  Bubble.swift
//  1-Navigation Controller
//
//  Created by Hua Zuo on 7/4/21.
//

import UIKit

class Bubble: UIButton {
    //get safe screen area height and width, prevent bubble appear outside of canva
    var screenWidth: UInt32 {
        return UInt32(UIScreen.main.bounds.width)
    }
    var screenHeight: UInt32 {
        return UInt32(UIScreen.main.bounds.height)
    }
    var bubbleVal = 0;
    var timeCount = 0;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //generate a number to decide which color bubble to show
        //and give different score (bubbleVal)
        let precentage = Int(arc4random_uniform(100))
        switch precentage {
        case 0...40:
            self.backgroundColor = .systemRed
            bubbleVal = 1
        case 41...70:
            self.backgroundColor = .systemPink
            bubbleVal = 2
        case 71...85:
            self.backgroundColor = .systemGreen
            bubbleVal = 5
        case 86...95:
            self.backgroundColor = .systemBlue
            bubbleVal = 8
        case 96...100:
            self.backgroundColor = .black
            bubbleVal = 10
        default:
            print("Error")
        }
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
    
    func shrink(btn: UIButton) {
        //Prevent Double Clicking same Bubble
        btn.isEnabled = false
        //Start Queue First
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(1)), execute: {
            self.removeFromSuperview()
            
        })
        //Then Run animation. so bubble disappear when animation is finised 
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 1.1
        springAnimation.fromValue = 1
        springAnimation.toValue = 0
        layer.add(springAnimation, forKey: nil)
        
        
        
    }
    
    var prevX:CGFloat = 100
    var prevY:CGFloat = 100
    func bubbleMove(){
        
        //Run When Bubble is not pressed within 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            //get xy position value (inside frame)
            
            let xMax = CGFloat(10 + arc4random_uniform(self.screenWidth - 150))
            let yMax = CGFloat(160 + arc4random_uniform(self.screenHeight - 250))
            //random to move Xposition or Yposition
            let xyGen = Int.random(in: 1...2)
            
            if(xyGen == 1){
                //Run Animation
                let springAnimation = CASpringAnimation(keyPath: "position.x")
                springAnimation.fromValue = self.prevX
                springAnimation.toValue = xMax
                
                springAnimation.beginTime = CACurrentMediaTime()
                
                //CATransaction.setCompletionBlock({
                //    self.layer.position.x = CGFloat(xMax)
                //})
                self.layer.add(springAnimation, forKey: nil)
                CATransaction.commit()
                
                //set New frame Position
                self.frame = CGRect(x: xMax, y: yMax, width: 50, height: 50)
                
                self.prevX = xMax
                self.bubbleMove()
            }else{
                let springAnimation = CASpringAnimation(keyPath: "position.y")
                springAnimation.fromValue = self.prevY
                springAnimation.toValue = yMax
                springAnimation.beginTime = CACurrentMediaTime()
                //CATransaction.setCompletionBlock({
                //   self.layer.position.x = CGFloat(yMax)
                //})
                self.layer.add(springAnimation, forKey: nil)
                CATransaction.commit()
                self.prevY = yMax
                self.bubbleMove()
            }
            
        })
        
        
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    
    
}
