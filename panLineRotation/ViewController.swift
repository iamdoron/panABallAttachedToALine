//
//  ViewController.swift
//  panLineRotation
//
//  Created by Doron Pagot on 12/11/14.
//  Copyright (c) 2014 Doron Pagot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var recognizer: UIPanGestureRecognizer!
    var ballView: UIView!
    let ballSize: CGFloat = 60
    var endOfLineAnchor = CGPoint.zeroPoint
    var lineLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ballView = createBallView()
        ballView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        endOfLineAnchor = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.8)
        
        lineLayer.strokeColor = UIColor.blackColor().CGColor
        lineLayer.path = pathFromBallToAnchor()
        view.layer.addSublayer(lineLayer)
        view.addSubview(ballView)
        
        recognizer = UIPanGestureRecognizer(target: self, action: "didPanBall:")
        ballView.addGestureRecognizer(recognizer)
        
    }

    func pathFromBallToAnchor() -> CGPathRef {
        var bazier = UIBezierPath()
        bazier.moveToPoint(ballView.center)
        bazier.addLineToPoint(endOfLineAnchor)
        return bazier.CGPath
    }
    
    var originalCenter = CGPoint.zeroPoint
    func didPanBall(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            originalCenter = sender.view!.center
        } else if (sender.state == .Changed)
        {
            let translation = sender.translationInView(self.view)
            sender.view!.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y + translation.y)
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            lineLayer.path = pathFromBallToAnchor()
            CATransaction.commit()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createBallView() -> UIView {
        var ball = UIView(frame: CGRectMake(view.bounds.width / 2, 0, ballSize, ballSize))
        ball.backgroundColor = UIColor(red: 240/255.0, green: 130/255.0, blue: 131/255.0, alpha: 1)
        
        ball.layer.cornerRadius = ballSize / 2
        ball.layer.masksToBounds = true
        return ball
    }
    
    func createLineFrom(start: CGPoint, to end: CGPoint) {
        var xDist = Double(start.x - end.x)
        var yDist = Double(start.y - end.y)
        var distance = sqrt(xDist*xDist - yDist*yDist)
        createVerticalLineThatStartsAt(start, withHeight: distance)
    }
    
    func createVerticalLineThatStartsAt(start: CGPoint, withHeight height: Double) -> UIView {
        var rect = CGRect(origin: start, size: CGSize(width: 1.0, height: height))
//        var x = CGRect(origin: start, size: CGSize(width: 1, height: height))
        return UIView(frame: rect)
    }

}

