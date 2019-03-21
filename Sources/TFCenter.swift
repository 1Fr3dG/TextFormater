//
//  TFCenter.swift
//  TextFormater
//
//  Created by 高宇 on 2019/3/21.
//

import Foundation
import MarkdownKit

open class TFCenter: MarkdownCommonElement {
    fileprivate static let regex = "(.?|^)(<center>)(.+?)(</center>)"
    
    open var font: MarkdownFont?
    open var color: MarkdownColor?
    
    open var regex: String {
        return TFCenter.regex
    }
    
    public init() {
        
    }
    
    open func addAttributes(_ attributedString: NSMutableAttributedString, range: NSRange) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: style, range: range)
        attributedString.insert(NSAttributedString(string: "\n"), at: range.upperBound)
        attributedString.insert(NSAttributedString(string: "\n"), at: range.lowerBound)
    }
}
