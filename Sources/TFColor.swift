//
//  TFColor.swift
//  TextFormater
//
//  Created by 高宇 on 2019/3/21.
//

import Foundation
import MarkdownKit

open class TFColor: MarkdownCommonElement {
    fileprivate static let regex = "(.?|^)(<color\\s\\w+>)(.+?)(</color>)"
    
    open var font: MarkdownFont?
    open var color: MarkdownColor?
    
    open var regex: String {
        return TFColor.regex
    }
    
    public init(defaultColor: MarkdownColor? = nil) {
        self.color = MarkdownParser.defaultColor
    }
    
    public func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
        
        let colorAttributedString = attributedString.attributedSubstring(from: match.range(at: 2))
        let colorString = colorAttributedString.string.dropFirst().dropLast().lowercased()
        
        var colorName = "black"
        if colorString.contains(" ") {
            colorName = colorString.components(separatedBy: " ")[1]
        }
        
        switch colorName {
        case "black":
            self.color = MarkdownColor.black
        case "blue":
            self.color = MarkdownColor.blue
        case "brown":
            self.color = MarkdownColor.brown
        case "cyan":
            self.color = MarkdownColor.cyan
        case "gray":
            self.color = MarkdownColor.gray
        case "green":
            self.color = MarkdownColor.green
        case "magenta":
            self.color = MarkdownColor.magenta
        case "orange":
            self.color = MarkdownColor.orange
        case "purple":
            self.color = MarkdownColor.purple
        case "red":
            self.color = MarkdownColor.red
        case "white":
            self.color = MarkdownColor.white
        case "yellow":
            self.color = MarkdownColor.yellow
        default:
            self.color = MarkdownColor.black
        }
        

        // deleting trailing markdown
        attributedString.deleteCharacters(in: match.range(at: 4))
        // formatting string (may alter the length)
        addAttributes(attributedString, range: match.range(at: 3))
        // deleting leading markdown
        attributedString.deleteCharacters(in: match.range(at: 2))
    }
}
