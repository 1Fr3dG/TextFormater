//
//  TFBGColor.swift
//  TextFormater
//
//  Created by 高宇 on 2019/3/21.
//

import Foundation
import MarkdownKit


open class TFBGColor: MarkdownCommonElement {
    fileprivate static let regex = "(.?|^)(<bgcolor\\s\\w+>)(.+?)(</bgcolor>)"
    
    open var font: MarkdownFont?
    open var color: MarkdownColor?
    open var bgcolor: MarkdownColor
    
    open var regex: String {
        return TFBGColor.regex
    }
    
    public init(defaultColor: MarkdownColor? = nil) {
        self.bgcolor = defaultColor ?? MarkdownColor.white
    }
    
    open func addAttributes(_ attributedString: NSMutableAttributedString, range: NSRange) {
        attributedString.addAttribute(.backgroundColor, value: self.bgcolor, range: range)
    }
    
    public func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
        
        let colorAttributedString = attributedString.attributedSubstring(from: match.range(at: 2))
        let colorString = colorAttributedString.string.dropFirst().dropLast().lowercased()
        
        var colorName = "white"
        if colorString.contains(" ") {
            colorName = colorString.components(separatedBy: " ")[1]
        }
        
        switch colorName {
        case "black":
            self.bgcolor = MarkdownColor.black
        case "blue":
            self.bgcolor = MarkdownColor.blue
        case "brown":
            self.bgcolor = MarkdownColor.brown
        case "cyan":
            self.bgcolor = MarkdownColor.cyan
        case "gray":
            self.bgcolor = MarkdownColor.gray
        case "green":
            self.bgcolor = MarkdownColor.green
        case "magenta":
            self.bgcolor = MarkdownColor.magenta
        case "orange":
            self.bgcolor = MarkdownColor.orange
        case "purple":
            self.bgcolor = MarkdownColor.purple
        case "red":
            self.bgcolor = MarkdownColor.red
        case "white":
            self.bgcolor = MarkdownColor.white
        case "yellow":
            self.color = MarkdownColor.yellow
        default:
            self.bgcolor = MarkdownColor.black
        }
        
        
        // deleting trailing markdown
        attributedString.deleteCharacters(in: match.range(at: 4))
        // formatting string (may alter the length)
        addAttributes(attributedString, range: match.range(at: 3))
        // deleting leading markdown
        attributedString.deleteCharacters(in: match.range(at: 2))
    }
}
