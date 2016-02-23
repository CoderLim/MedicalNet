//
//  HNABankNoField.swift
//  MedicalNet
//
//  Created by gengliming on 16/1/8.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

import Foundation
import UIKit

@objc class HNABankNoField: UITextField,UITextFieldDelegate {
    // MARK:- property
    var originalText: String? {
        get {
            return self.text?.stringByReplacingOccurrencesOfString(" ", withString: "")
        }
    }
    
    // MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    // MARK:- delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let characterSet = NSCharacterSet(charactersInString: "0123456789\\b")
        
        //
        guard (string.rangeOfCharacterFromSet(characterSet.invertedSet) == nil) else {
            return false
        }
        
        //
        var text = textField.text
        text = (text! as NSString).stringByReplacingCharactersInRange(range, withString: string) as String
        text = text?.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        //
        var newString = ""
        var count:Int = 0
        for c in (text?.characters.reverse())! {
            if count != 0 && count%4 == 0 {
                newString = "\(c) \(newString)"
            } else {
                newString = "\(c)\(newString)"
            }
            count++
        }
        
        textField.text = newString
        
        // 发送文本变化的通知
        NSNotificationCenter.defaultCenter().postNotificationName(UITextFieldTextDidChangeNotification, object: nil)
        
        return false
    }
}
