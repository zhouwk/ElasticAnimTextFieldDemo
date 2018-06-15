//
//  ElasticAnimTextField.swift
//  ElasticAnimTextFieldDemo
//
//  Created by 周伟克 on 2018/6/14.
//  Copyright © 2018年 周伟克. All rights reserved.
//

import UIKit

class ElasticAnimTextField: UITextField {
    
    let elasticAnimView = ElasticAnimView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 被hitTest 中的super.hitTest(point, with: event) 触发，否则无法触发
        return super.point(inside: point, with: event)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            if !isFirstResponder {
                becomeFirstResponder()
            }
            return elasticAnimView
        }
        return nil
    }
    
    func initUI() {
        borderStyle = .none
        backgroundColor = UIColor.white
        clipsToBounds = false
        addSubview(elasticAnimView)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }


    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        elasticAnimView.frame = bounds
    }
    
    
    
}
