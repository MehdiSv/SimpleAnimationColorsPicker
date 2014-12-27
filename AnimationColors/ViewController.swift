//
//  ViewController.swift
//  AnimationColors
//
//  Created by Mehdi Sqalli on 27/12/14.
//  Copyright (c) 2014 MNT Developpement. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let colors = [UIColor.redColor(), UIColor.purpleColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.yellowColor(), UIColor.whiteColor(), UIColor.greenColor(), UIColor.grayColor()]
    var views:[UIView] = []
    var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "pressed:")
        longPress.minimumPressDuration = 0.1
        
        self.view.addGestureRecognizer(longPress)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in 0..<colors.count {
            let view = UIView(frame: CGRect(x: CGFloat(i) * self.view.frame.width / CGFloat(colors.count), y: self.view.frame.height - 50, width: self.view.frame.width / CGFloat(colors.count), height: 50))
            view.backgroundColor = colors[i]
            self.view.addSubview(view)
            views.append(view)
        }
        
        label = UILabel(frame: CGRect(x: self.view.frame.width / 5, y: self.view.frame.height / 5, width: self.view.frame.width * 3 / 5, height: 50))
        label.textColor = .whiteColor()
        label.text = "R: G: B:"
        self.view.addSubview(label)

        setupColorsWithLocation(nil)
    }
    
    func distanceBetweenTwoPoints(p1:CGPoint, p2:CGPoint) -> CGFloat {
        return hypot(p1.x - p2.x, p1.y - p2.y)
    }
    
    func displayColorRGBInLabel(color:UIColor) {
        var red:CGFloat = 0
        var blue:CGFloat = 0
        var green:CGFloat = 0
        var alpha:CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        label.text = "R: \(red) G: \(green) B: \(blue)"
    }
    
    func isColorViewTouched(point:CGPoint?) -> Bool {
        if let point = point {
            for i in 0..<views.count {
                if CGRectContainsPoint(views[i].frame, point) == true {
                    displayColorRGBInLabel(colors[i])
                    return true
                }
            }
        }
        
        return false
    }
    
    func setupColorsWithLocation(point:CGPoint?) {
        
        let colorViewTouched = isColorViewTouched(point)
        
        var distances:[CGFloat] = []
        for view in views {
            if colorViewTouched == true {
                let distance = distanceBetweenTwoPoints(point!, p2: view.center)
                distances.append(distance)
            }
        }
        let sumDistance = distances.reduce(0) { $0 + $1 }
        
        let numberColors = colors.count
        for i in 0..<numberColors {
            
            let view = views[i]
            
            if colorViewTouched == true {
                var tr = (2 - (distances[i] / sumDistance * CGFloat(numberColors)))
                if tr < 1 {
                    tr = 1
                }
                
                view.transform = CGAffineTransformMakeScale(1, tr)
            } else {
                view.transform = CGAffineTransformMakeScale(1, 1)
                label.text = "R: G: B:"
            }
            
            view.updateConstraints()
            view.layoutIfNeeded()
        }
        
    }
    
    func pressed(gestureRecognizer:UIGestureRecognizer) {
        
        let location = gestureRecognizer.locationInView(self.view)
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            setupColorsWithLocation(location)
            
        } else if gestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            setupColorsWithLocation(location)
            
        } else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            setupColorsWithLocation(nil)
            
        } else if gestureRecognizer.state == UIGestureRecognizerState.Cancelled {
            
            setupColorsWithLocation(nil)
        }
        
    }
    
}

