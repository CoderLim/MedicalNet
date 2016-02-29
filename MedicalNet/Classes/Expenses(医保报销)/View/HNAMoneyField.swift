//
//  HNAMoneyField.swift
//  MedicalNet
//
//  Created by gengliming on 16/1/20.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

import UIKit

class HNAMoneyField: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.delegate = self
        self.textAlignment = .Right
        self.keyboardType = .NumberPad
    }
    
    // 得到正确的字符串
    var originalText: String? {
        get {
            let str = self.text?.stringByReplacingOccurrencesOfString(",", withString: "")
            return str?.stringByReplacingOccurrencesOfString("¥", withString: "")
        }
    }

    // MARK: UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var text = textField.text
        text = (text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        text = text?.stringByReplacingOccurrencesOfString(",", withString: "")
        text = text?.stringByReplacingOccurrencesOfString("¥", withString: "")
        
        //
        var newString = ""
        var count:Int = 0
        for c in (text?.characters.reverse())! {
            if count != 0 && count%3 == 0 {
                newString = "\(c),\(newString)"
            } else {
                newString = "\(c)\(newString)"
            }
            count++
        }
        
        if !newString.isEmpty {
            textField.text = "¥\(newString)"
        } else {
            textField.text = ""
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(UITextFieldTextDidChangeNotification, object: nil)
        
        return false
    }
    
}
