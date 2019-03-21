//
//  TFImage.swift
//  TextFormater
//
//  Created by 高宇 on 2019/3/21.
//

import Foundation
import MarkdownKit

/// 图片数据获取协议
///
/// delegation protocol for getting image data
public protocol GetImageForTextFormater {
    #if os(iOS)
        func getImage(byKey: String) -> UIImage?
    #elseif os(OSX)
        func getImage(byKey: String) -> NSImage?
    #endif
}

/// 图片获取代理用类
///
/// Dummy class for image deletation
public class NilImageDelegate: NSObject, GetImageForTextFormater {
    #if os(iOS)
    public func getImage(byKey: String) -> UIImage? { return nil }
    #elseif os(OSX)
    public func getImage(byKey: String) -> NSImage? { return nil }
    #endif
}

open class TFImage: MarkdownCommonElement,MarkdownElement {
    
    fileprivate static let regex = "(.?|^)(<img>)(.+?)(</img>)"
    
    open var font: MarkdownFont?
    open var color: MarkdownColor?
    open var imageDelegate: GetImageForTextFormater
    
    open var regex: String {
        return TFImage.regex
    }
    
    public init(imageDelegate: GetImageForTextFormater = NilImageDelegate()) {
        self.imageDelegate = imageDelegate
    }
    
    open func addAttributes(_ attributedString: NSMutableAttributedString, range: NSRange) {
        let textAttachment = NSTextAttachment()
        let imageKey = attributedString.attributedSubstring(from: range).string
        if let image = imageDelegate.getImage(byKey: imageKey) {
            textAttachment.image = image
            let _aString = NSMutableAttributedString(attachment: textAttachment)
            attributedString.replaceCharacters(in: range, with: _aString)
        }
    }
}
