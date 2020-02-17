//
//  ProductButton.swift
//  WhatHa
//
//  Created by kim jason on 17/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import Foundation
import Material

class ProductButton : RaisedButton {
    
    var bgColor:UIColor = RedColor
    var desTitle:String = ""
    var discountTitle:String = ""
    
    override init(title: String?, titleColor: UIColor) {
        super.init(title: title, titleColor: titleColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func prepare() {
                super.prepare()
//        self.title = BtnTitle
//        self.titleColor = WhiteColor
//        self.pulseColor = WhiteColor
        self.backgroundColor = bgColor
        self.isUserInteractionEnabled = true
        self.layer.zPosition = 1
        self.layer.shadowOpacity = 0.0
        self.layer.shadowColor = UIColor.clear.cgColor
        self.titleLabel?.font = setFontDefault(size: 15)
  
        
        var desLabel = setLabel(title: self.desTitle, size: 13, textColor: WhiteColor, textAlign: .left, numberOfLines: 0)
        var discountLabel = setLabel(title: self.discountTitle, size: 13, textColor: WhiteColor, textAlign: .left, numberOfLines: 0)
        
        self.addSubview(desLabel)
        self.addSubview(discountLabel)
        
        desLabel.snp.makeConstraints{ m in
            m.centerY.equalToSuperview()
            m.left.equalTo(8)
        }
        
        discountLabel.snp.makeConstraints{ m in
            m.bottom.equalTo(self).offset(-8)
            m.right.equalTo(self).offset(-8)
        }
        
//        self.titleLabel!.snp.removeConstraints()
//        
//        self.titleLabel!.snp.makeConstraints{ m in
//            m.top.equalTo(self).offset(8)
//            m.right.equalTo(self).offset(-8)
//        }
    }
}


