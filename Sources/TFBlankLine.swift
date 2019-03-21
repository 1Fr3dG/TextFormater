//
//  TFBlankLine.swift
//  TextFormater
//
//  Created by 高宇 on 2019/3/21.
//

import Foundation
import MarkdownKit

open class TFBlankLine: MarkdownCommonElement {
    fileprivate static let regex = "<br>|<br />"
    
    open var font: MarkdownFont?
    open var color: MarkdownColor?
    
    open var regex: String {
        return TFBlankLine.regex
    }
    
    public init() {
        
    }
    
    public func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
        attributedString.replaceCharacters(in: match.range, with: "\n")
    }
}
