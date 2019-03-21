//
//  TextFormater.swift
//
//  Created by Alfred Gao on 2019/03/15.
//  Copyright © 2019年 Alfred Gao. All rights reserved.
//

import MarkdownKit


/// 文本格式化器
///
/// Text formater
///
/// - 将含有预定义格式化命令的 String 转化为 NSAttributedString
/// - convert string with formatting command to NSAttributedString
public class TextFormater : NSObject {
    
    /// Markdown parser
    private var markdownParser:MarkdownParser
    
    public init(fontFamilies:[String] = ["Verdana","苹方-简"],
                fontSize:CGFloat = 0,
                color:MarkdownColor = MarkdownParser.defaultColor,
                boldFontFamilies:[String] = ["Didot","Hei"],
                boldFontSize:CGFloat = 0,
                boldFontColor:MarkdownColor = MarkdownParser.defaultColor,
                italicFontFamilies:[String] = ["Times New Roman","Kai"],
                italicFontSize:CGFloat = 0,
                italicFontColor:MarkdownColor = MarkdownParser.defaultColor,
                equationFontSize:CGFloat = 0,
                equationColor:MarkdownColor = MarkdownParser.defaultColor,
                imageDelegate:GetImageForTextFormater = NilImageDelegate()
        ) {
        markdownParser = MarkdownParser(font: MarkdownFont(names: fontFamilies, size: fontSize) ?? MarkdownParser.defaultFont,
                                        color: color)
        super.init()
        
        // 设置粗体字体
        if boldFontFamilies.first != nil {
            #if os(OSX)
            markdownParser.bold.font = MarkdownFont(names: boldFontFamilies, size: boldFontSize)?.bold()
            #elseif os(iOS)
            markdownParser.bold.font = UIFont(descriptor: MarkdownFont(names: boldFontFamilies, size: boldFontSize)!.fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
            #endif
        }
        if boldFontColor != MarkdownParser.defaultColor {
            markdownParser.bold.color = boldFontColor
        }
        // 设置斜体字体
        if italicFontFamilies.first != nil {
            #if os(OSX)
            markdownParser.italic.font = MarkdownFont(names: italicFontFamilies, size: italicFontSize)?.italic()
            #elseif os(iOS)
            markdownParser.italic.font = UIFont(descriptor: MarkdownFont(names: italicFontFamilies, size: italicFontSize)!.fontDescriptor.withSymbolicTraits(.traitItalic)!, size: 0)
            #endif
        }
        if italicFontColor != MarkdownParser.defaultColor {
            markdownParser.italic.color = italicFontColor
        }
        // 设置LaTeX
        var _equationFont = markdownParser.font
        if equationFontSize != 0 {
            _equationFont = MarkdownFont(name: markdownParser.font.fontName, size: equationFontSize)!
        } else {
            _equationFont = MarkdownFont(name: markdownParser.font.fontName, size: markdownParser.font.pointSize)!
        }
        
        let equationPaser = LaTeXEquation(font: _equationFont, color: equationColor)
        // 设置图片
        let imagePaser = TFImage(imageDelegate: imageDelegate)
    
        
        markdownParser.addCustomElement(equationPaser)
        markdownParser.addCustomElement(imagePaser)
        markdownParser.addCustomElement(TFCenter())
        markdownParser.addCustomElement(TFBGColor())
        markdownParser.addCustomElement(TFColor())
        markdownParser.addCustomElement(TFBlankLine())
    }
    
    /// formater
    public func parse(_ text:String) -> NSAttributedString {
        
        return markdownParser.parse(text)
    }

}

public extension MarkdownFont {
    convenience init?(names:[String], size:CGFloat) {
        var fontSize = size
        if size == 0 {
            fontSize = MarkdownParser.defaultFont.pointSize
        }
        
        #if os(iOS)
            if names.first != nil {
                let mainFontName = names.first!
                
                let descriptors = names.map { UIFontDescriptor(fontAttributes: [.name: $0]) }
                
                let attributes: [UIFontDescriptor.AttributeName: Any] = [
                    UIFontDescriptor.AttributeName.cascadeList: descriptors,
                    UIFontDescriptor.AttributeName.name: mainFontName,
                    UIFontDescriptor.AttributeName.size: fontSize,
                    ]
                
                let customFontDescriptor: UIFontDescriptor = UIFontDescriptor(fontAttributes: attributes)
                self.init(descriptor: customFontDescriptor, size: fontSize)
            }
            else{
                let systemFont = UIFont.systemFont(ofSize: fontSize)
                let systemFontDescriptor: UIFontDescriptor = systemFont.fontDescriptor
                self.init(descriptor: systemFontDescriptor, size: fontSize)
            }
        #elseif os(OSX)
            if names.first != nil {
                let mainFontName = names.first!
                
                let descriptors = names.map { NSFontDescriptor(fontAttributes: [.name: $0]) }
                
                let attributes: [NSFontDescriptor.AttributeName: Any] = [
                    NSFontDescriptor.AttributeName.cascadeList: descriptors,
                    NSFontDescriptor.AttributeName.name: mainFontName,
                    NSFontDescriptor.AttributeName.size: fontSize,
                    ]
                
                let customFontDescriptor: NSFontDescriptor = NSFontDescriptor(fontAttributes: attributes)
                self.init(descriptor: customFontDescriptor, size: fontSize)
            }
            else{
                let systemFont = NSFont.systemFont(ofSize: fontSize)
                let systemFontDescriptor: NSFontDescriptor = systemFont.fontDescriptor
                self.init(descriptor: systemFontDescriptor, size: fontSize)
            }
        #endif
    }
}

