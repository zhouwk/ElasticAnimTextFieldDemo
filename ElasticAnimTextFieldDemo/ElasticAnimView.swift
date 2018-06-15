//
//  ElasticAnimView.swift
//  ElasticAnimTextFieldDemo
//
//  Created by 周伟克 on 2018/6/14.
//  Copyright © 2018年 周伟克. All rights reserved.
//

import UIKit

enum ElasticState {
    case normal
    case animating
}

class ElasticAnimView: UIView {

    /*
     * 因为无法直接设置elasticAnimLayer的弹簧动画，通过下面4个点的弹簧动画，通过他们动画过
     * 程的展示层的center 构建elasticAnimLayer的path， 在通过displaylink实时渲染，从而间接创建elasticAnimLayer的弹簧动画
     */
    
    let elasticLayer = CAShapeLayer()
    let topPointView = UIView()
    let bottomPointView = UIView()
    let leftPointView = UIView()
    let rightPointView = UIView()
    
    var width: CGFloat {
        return self.frame.width
    }
    
    var height: CGFloat {
        return self.frame.height
    }
    
    var state = ElasticState.normal
    
    
    lazy var displayLink: CADisplayLink = {
        
        let displayLink = CADisplayLink(target: self,
                                        selector: #selector(updateElasticLayerBezi))
        displayLink.isPaused = true
        displayLink.add(to: .main, forMode: .commonModes)
        return displayLink
    }()
    
    
    @IBInspectable var test = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if state == .animating {
            return
        }
        state = .animating
        animatePointViews()
        startUpdateElasticLayerBezi()
        
    }
    
    
    func startUpdateElasticLayerBezi() {
        displayLink.isPaused = false
    }
    
    func stopUpdateElasticLayerBezi() {
        displayLink.isPaused = true
    }
    
    
    @objc func updateElasticLayerBezi() {
        
        
        let top = topPointView.layer.presentation()?.position ?? .zero
        let bottom = bottomPointView.layer.presentation()?.position ?? .zero
        let left = leftPointView.layer.presentation()?.position ?? .zero
        let right = rightPointView.layer.presentation()?.position ?? .zero
        
        
        let bezi = UIBezierPath()
        bezi.move(to: .zero)
        bezi.addQuadCurve(to: CGPoint(x: width, y: 0), controlPoint: top)
        bezi.addQuadCurve(to: CGPoint(x: width, y: height), controlPoint: right)
        bezi.addQuadCurve(to: CGPoint(x: 0, y: height), controlPoint: bottom)
        bezi.addQuadCurve(to: .zero, controlPoint: left)
        
        elasticLayer.path = bezi.cgPath
        
    }
    
    
    
    func initUI() {
        
        elasticLayer.anchorPoint = .zero
        elasticLayer.fillColor = UIColor.white.cgColor
        layer.addSublayer(elasticLayer)
        
        for pointView in [topPointView, bottomPointView, leftPointView, rightPointView] {
            pointView.frame.size = CGSize(width: 5, height: 5)
            pointView.backgroundColor = UIColor.green
            pointView.isHidden = true
            addSubview(pointView)
        }
    }
    
    
    func animatePointViews() {
        
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.5, options: [], animations: {
            
            self.topPointView.center.y -= 10
            self.bottomPointView.center.y += 10
            self.leftPointView.center.x -= 10
            self.rightPointView.center.x += 10
            
        }) { (finished) in
            // 动画结束之前： 1.再次调用animatePointViews， finished = true， 2.调用layer.removeAnim finished = false
            UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.15, initialSpringVelocity: 5.5, options: [], animations: {
                self.resumePointViewsPosition()
            }, completion: { (_) in
                self.stopUpdateElasticLayerBezi()
                self.state = .normal
            })
        }
    }
    
    
    /// 4个controlPointView恢复原始位置
    func resumePointViewsPosition() {
        
        topPointView.center = CGPoint(x: width * 0.5, y: 0)
        bottomPointView.center = CGPoint(x: width * 0.5, y: height)
        leftPointView.center = CGPoint(x: 0, y: height * 0.5)
        rightPointView.center = CGPoint(x: width, y: height * 0.5)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        elasticLayer.bounds = bounds
        resumePointViewsPosition()
    }
    
    
    func textRectForBounds() -> CGRect {
        return .zero
    }
    
    
    override func removeFromSuperview() {
        displayLink.invalidate()
        super.removeFromSuperview()
    }

}
