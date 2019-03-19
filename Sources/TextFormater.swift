//
//  TextFormater.swift
//
//  Created by Alfred Gao on 2019/03/15.
//  Copyright © 2019年 Alfred Gao. All rights reserved.
//

#if os(iOS)
    typealias TFFont = UIFont
    typealias TFColor = UIColor
    typealias TFImage = UIImage
#elseif os(OSX)
    typealias TFFont = NSFont
    typealias TFColor = NSColor
    typealias TFImage = NSImage
#endif


import MarkdownKit


/// 文本格式化器
///
/// Text formater
///
/// - 将含有预定义格式化命令的 String 转化为 NSAttributedString
/// - convert string with formatting command to NSAttributedString
public class TextFormater : NSObject {
    
    /// Markdown parser
    private var markdownParser = MarkdownParser()
    
    public override init() {
        super.init()
        markdownParser.addCustomElement(LaTeXEquation())
    }
    
    /// formater
    public func parse(_ text:String) -> NSAttributedString {
        
        
        return markdownParser.parse(text)
    }

}

