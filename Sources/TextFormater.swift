//
//  TextFormater.swift
//
//  Created by Alfred Gao on 2016/10/11.
//  Copyright © 2016年 Alfred Gao. All rights reserved.
//

import Foundation
#if os(iOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
    public typealias UIFont = NSFont
    public typealias UIColor = NSColor
    public typealias UIImage = NSImage
    extension NSFont {
        func withSize(_ size: CGFloat) -> NSFont {
            return NSFont(name: self.fontName, size: size)!
        }
    }
#endif

/// 图片数据获取协议
///
/// delegation protocol for getting image data (as UIImage)
public protocol GetImageForTextFormater {
    func getImage(byKey: String) -> UIImage?
}


/// 文本格式化器
///
/// Text formater
///
/// - 将含有预定义格式化命令的 String 转化为 NSAttributedString
/// - convert string with formatting command to NSAttributedString
public class TextFormater : NSObject {
    /// 格式化命令控制字符
    ///
    /// Char used to seperate format command (from content)
    public var _cs = "<"
    public var _ce = ">"
    
    /// 缺省格式前缀, 将附加在所有格式文本之前
    ///
    /// default prefix, will be added to any string before formating
    public var defaultFormat: String = ""
    /// 动态格式前缀，将附加在所有格式文本之前，defaultFormat 之后
    ///
    /// Dynamic prefix, will be added to string, after defaultFormat
    ///
    /// - 用于 traitCollectionDidChange 等情况调整格式化参数
    /// - deisgned to adjust format according changes like traitCollectionDidChange
    public var dynamicFormat: String = ""
    /// 动态格式前缀代理，在**每次**`format`函数调用时调用该代理
    ///
    /// Dynamic prefix delegation, will be called during **every** `format` call
    ///
    /// 该值为 `nil` 时使用 `dynamicFormat`
    ///
    /// `format()` will use `dynamicFormat` when `dynamicFormatDelegate()` returns `nil`
    public var dynamicFormatDelegate: () -> String? = {return nil}
    
    /// 图片获取代理用类
    ///
    /// Dummy class for image deletation
    class NilImageDelegate: NSObject, GetImageForTextFormater {
        func getImage(byKey: String) -> UIImage? {
            return nil
        }
    }
    
    /// 图片获取代理
    ///
    /// deletate for image (used for img command)
    public var imageDelegate : GetImageForTextFormater = NilImageDelegate()
    
    /// 定制化字体
    ///
    /// custimized fonts
    #if os(iOS)
    public private(set) var fonts : [String : String] = [
        "normalfont" : UIFont.systemFont(ofSize: UIFont.systemFontSize).fontName,
        "boldfont" : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize).fontName,
        "italicfont" : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize).fontName,
        ]
    #elseif os(OSX)
    public private(set) var fonts : [String : String] = [
        "normalfont" : NSFont.systemFont(ofSize: NSFont.systemFontSize()).fontName,
        "boldfont" : NSFont.boldSystemFont(ofSize: NSFont.systemFontSize()).fontName,
        "italicfont" : NSFont.boldSystemFont(ofSize: NSFont.systemFontSize()).fontName,
        ]
    #endif
    /// 设置定制化字体
    ///
    /// set customized font
    ///
    /// - parameter name: 
    ///     - 格式化命令名
    ///     - name of command
    /// - parameter font: 
    ///     - 对应字体
    ///     - font (size ignored)
    public func setFont(name: String, font: UIFont) {
        fonts[name.lowercased()] = font.fontName
        setCommand(command: name.lowercased(), squance: "ThemeFont")
    }
    
    /// 标准字号
    ///
    /// default size of font
    #if os(iOS)
    public var normalFontSize: CGFloat = UIFont.systemFontSize
    #elseif os(OSX)
    public var normalFontSize: CGFloat = NSFont.systemFontSize()
    #endif
    /// 定制化颜色
    ///
    /// customized colors
    public private(set) var colors : [String : UIColor] = [
        "defaultColor" : UIColor.black,
        "clear" : UIColor.clear,
        "black" : UIColor.black,
        "blue" : UIColor.blue,
        "brown" : UIColor.brown,
        "gray" : UIColor.gray,
        "green" : UIColor.green,
        "magenta" : UIColor.magenta,
        "orange" : UIColor.orange,
        "purple" : UIColor.purple,
        "red" : UIColor.red,
        "yellow" : UIColor.yellow,
        "white" : UIColor.white,
    ]
    /// 设置定制化颜色
    ///
    /// set customized color
    /// - parameter name: 
    ///     - 格式化命令名，该命令只用于前景色；该颜色可用于 `<bgcolor name=colorname>` 命令
    ///     - color name and command, command can be used for **foreground**, color name can be used for both **foreground** and **background**
    /// - parameter color: 
    ///     - 对应颜色
    ///     - UIColor
    public func setColor(name: String, color: UIColor) {
        colors[name.lowercased()] = color
        setCommand(command: name.lowercased(), squance: "ForegroundColor")
    }
    
    /// 命令序列
    ///
    /// commands
    public private(set) var commandSquance : [String : String] = [
        "/" : "End",
        "#" : "Comments",
        "comment" : "Comments",
        "br": "NewLine",
        "font" : "Font",
        "color" : "ForegroundColor",
        "bgcolor" : "BackgroundColor",
        "align" : "Alignment",
        "left" : "Alignment",
        "center" : "Alignment",
        "right" : "Alignment",
        "b" : "ThemeFont",
        "i" : "ThemeFont",
        "fontsize" : "FontSizeAdjust",
        "img" : "Image",
    ]
    
    /// 增加格式化命令
    ///
    /// add new command to **commandSquance**
    private func setCommand(command: String, squance: String) {
        commandSquance[command] = squance
    }
    
    override public init () {
        super.init()
        for (name, _) in fonts {
            setCommand(command: name, squance: "ThemeFont")
        }
        for (name, _) in colors {
            setCommand(command: name, squance: "ForegroundColor")
        }
    }
    
    public convenience init (defaultFormat _f: String) {
        self.init()
        defaultFormat = _f
    }
    
    public convenience init (defaultFormat _f: String, controlCharacterBegin cs: Character, controlCharacterEnd ce: Character) {
        self.init()
        defaultFormat = _f
        _cs = String(cs)
        _ce = String(ce)
    }
    
    public init(copyFrom f: TextFormater) {
        super.init()
        _cs = f._cs
        _ce = f._ce
        defaultFormat = f.defaultFormat
        fonts = f.fonts
        normalFontSize = f.normalFontSize
        colors = f.colors
        commandSquance = f.commandSquance
    }
    
    /// 查找同属性历史命令
    ///
    /// find last attribute with same command type
    private func lastAttr(in attrs: [(String, Any)], with attrName: String) -> Any? {
        for (key, value) in attrs.reversed() {
            if key == attrName {
                return value
            }
        }
        return nil
    }
    
    /// 查找命令参数
    ///
    /// filter parameters from command string
    private func parameter(in command: String, withKey key: String) -> String? {
        if let keyPosition = command.range(of: " " + key + "=") {
            let stringAfterKey = command.substring(from: keyPosition.upperBound)
            if let valueEndPosition = stringAfterKey.range(of: " ") {
                return stringAfterKey.substring(to: valueEndPosition.lowerBound)
            } else {
                return stringAfterKey.substring(to: stringAfterKey.index(stringAfterKey.endIndex, offsetBy: -1))
            }
        } else {
            return nil
        }
    }
    
    /// 格式化字符串
    ///
    /// Format a string
    /// - parameter text:
    ///     - 带有格式化命令的字符串
    ///     - String with formatting commands
    public func format(_ text: String?) -> NSAttributedString? {
        let _text: String
        let _result = NSMutableAttributedString(string: "")
        
        let _controlSequancePattern = _cs + "[^" + _cs + _ce + "]*?" + _ce
        let regular = try! NSRegularExpression(pattern: _controlSequancePattern, options: .useUnicodeWordBoundaries)
        
        // 添加附加格式设置
        // add prefix
        guard text != nil else {
            return nil
        }
        if text == "" {
            return _result
        } else {
            let _appendx = ""
            // 目前不要求强制关闭标签
            // closer of command is NOT required
            //            for _ in regular.matches(in: KTTextFormater.defaultFormat + formatString, options: .reportProgress , range: NSMakeRange(0, (KTTextFormater.defaultFormat + formatString).characters.count)) {
            //                _appendx += _cs + _ce
            //            }
            let _dynamicFormat = dynamicFormatDelegate() ?? dynamicFormat
            _text = defaultFormat + _dynamicFormat + text! + _appendx + _cs + _ce
        }
        
        // 文本分段
        // seperate string with commands
        var formatedLocation = 0
        var attrs: [(String, Any)] = []
        attrs.append((NSFontAttributeName, UIFont(name: fonts["normalfont"]!, size: normalFontSize) as Any))
        for result in regular.matches(in: _text, options: .reportProgress, range: NSMakeRange(0, _text.utf16.count)) {
            if formatedLocation < result.range.location {
                // 本段为内容
                // this section is content
                let _t = (_text as NSString).substring(with: NSRange(location: formatedLocation, length: result.range.location - formatedLocation))
                var _attrDict: [String : Any] = [:]
                for (key, value) in attrs {
                    _attrDict[key] = value
                }
                _result.append(NSAttributedString(string: _t, attributes: _attrDict))
            }
            // 本段为格式命令
            // this section is formating command
            let _command = (_text as NSString).substring(with: result.range)
            
            let _commandName: String
            if result.range.length == 2 {
                _commandName = "NOACTION".lowercased()
            } else {
                if let spaceposition = _command.range(of: " ") {
                    _commandName = _command.substring(with: _command.index(_command.startIndex, offsetBy: 1) ..< spaceposition.lowerBound).lowercased()
                } else {
                    _commandName = _command.substring(with: _command.index(_command.startIndex, offsetBy: 1) ..< _command.index(_command.endIndex, offsetBy: -1)).lowercased()
                }
            }
            
            if let _sq = commandSquance[_commandName] {
                switch _sq {
                case "End":
                    attrs.removeLast()
                    
                case "NewLine":
                    _result.append(NSAttributedString(string: "\n"))
                    let currentfont: UIFont
                    if let _font = lastAttr(in: attrs, with: NSFontAttributeName) as? UIFont{
                        currentfont = _font
                    } else {
                        #if os(iOS)
                        currentfont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                        #elseif os(OSX)
                        currentfont = NSFont.systemFont(ofSize: NSFont.systemFontSize())
                        #endif
                    }
                    let newLineFont = currentfont.withSize(currentfont.pointSize / 2)
                    _result.append(NSAttributedString(string: "\n", attributes: [NSFontAttributeName: newLineFont]))
                    
                case "Comments":
                    break
                
                case "Image":
                    let attachment = NSTextAttachment()
                    if let _imgkey = parameter(in: _command, withKey: "key"),
                        let _img = imageDelegate.getImage(byKey: _imgkey) {
                        // image size
                        var _width = _img.size.width
                        var _height = _img.size.height
                        if let _widthstring = parameter(in: _command, withKey: "width"),
                            0 != (_widthstring as NSString).doubleValue {
                            _width = CGFloat((_widthstring as NSString).doubleValue)
                            _height = _img.size.height * _width / _img.size.width
                        }
                        if let _heightstring = parameter(in: _command, withKey: "height"),
                            0 != (_heightstring as NSString).doubleValue {
                            _height = CGFloat((_heightstring as NSString).doubleValue)
                        }
                        let currentFont: UIFont
                        if let _font = lastAttr(in: attrs, with: NSFontAttributeName) as? UIFont{
                            currentFont = _font
                        } else {
                            currentFont = UIFont(name: fonts["normalfont"]!, size: normalFontSize)!
                        }
                        // set the attachment
                        #if os(iOS)
                            attachment.image = _img
                            attachment.bounds = CGRect(x: 0.0, y: currentFont.descender, width: _width, height: _height)
                        #elseif os(OSX)
                            //var imageRect:CGRect = CGRectMake(0, 0, _img.size.width, _img.size.height)
                            let _imgResized = NSImage(cgImage: _img.cgImage(forProposedRect: nil, context: nil, hints: nil)!, size: NSSize(width: _width, height: _height))
                            let cell = NSTextAttachmentCell(imageCell: _imgResized)
                            attachment.attachmentCell = cell
                        #endif
                
                    }
                    var _attrs = attrs
                    _attrs.append((NSForegroundColorAttributeName, UIColor.clear))
                    _attrs.append((NSFontAttributeName, UIFont(name: fonts["normalfont"]!, size: 1)!))
                    _attrs.append((NSBackgroundColorAttributeName, UIColor.clear))
                    
                    var _attrDict: [String : Any] = [:]
                    for (key, value) in _attrs {
                        _attrDict[key] = value
                    }
                    _result.append(NSAttributedString(string: " ", attributes: _attrDict))
                    _result.append(NSAttributedString(attachment: attachment))
                    _result.append(NSAttributedString(string: " ", attributes: _attrDict))
                    
                case "Font":
                    let oldfont: UIFont
                    if let _font = lastAttr(in: attrs, with: NSFontAttributeName) as? UIFont{
                        oldfont = _font
                    } else {
                        #if os(iOS)
                        oldfont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                        #elseif os(OSX)
                        oldfont = UIFont.systemFont(ofSize: UIFont.systemFontSize())
                        #endif
                    }
                    
                    let newfont: UIFont
                    if let fontName = parameter(in: _command, withKey: "name") {
                        if let fontSize = parameter(in: _command, withKey: "size") {
                            if let _fontsize = NumberFormatter().number(from: fontSize) {
                                newfont = UIFont(name: fontName, size: CGFloat(_fontsize))!
                            } else {
                                newfont = UIFont(name: fontName, size: oldfont.pointSize)!
                            }
                        } else {
                            newfont = UIFont(name: fontName, size: oldfont.pointSize)!
                        }
                    } else {
                        if let fontSize = parameter(in: _command, withKey: "size") {
                            if let _fontsize = NumberFormatter().number(from: fontSize) {
                                newfont = UIFont(name: oldfont.fontName, size: CGFloat(_fontsize))!
                            } else {
                                newfont = oldfont
                            }
                        } else {
                            newfont = oldfont
                        }
                    }
                    
                    attrs.append((NSFontAttributeName, newfont))
                    
                case "FontSizeAdjust":
                    let oldfont: UIFont
                    if let _font = lastAttr(in: attrs, with: NSFontAttributeName) as? UIFont{
                        oldfont = _font
                    } else {
                        oldfont = UIFont(name: fonts["normalfont"]!, size: normalFontSize)!
                    }
                    
                    var _fontsizeadjust: CGFloat = 0
                    if let fontSize = parameter(in: _command, withKey: "+") {
                        _fontsizeadjust = NumberFormatter().number(from: fontSize) as! CGFloat
                    }
                    if let fontSize = parameter(in: _command, withKey: "-") {
                        _fontsizeadjust = -(NumberFormatter().number(from: fontSize) as! CGFloat)
                    }
                    
                    var newfont: UIFont
                    if _fontsizeadjust == 0 {
                        newfont = oldfont.withSize(normalFontSize)
                    } else {
                        newfont = oldfont.withSize(oldfont.pointSize + _fontsizeadjust)
                    }
                    
                    attrs.append((NSFontAttributeName, newfont))
                    
                case "ThemeFont":
                    #if os(iOS)
                    let oldfontsize = (lastAttr(in: attrs, with: NSFontAttributeName) as? UIFont)?.pointSize ?? UIFont.systemFontSize
                    #elseif os(OSX)
                    let oldfontsize = (lastAttr(in: attrs, with: NSFontAttributeName) as? UIFont)?.pointSize ?? UIFont.systemFontSize()
                    #endif
                    let newfontname: String
                    switch _commandName {
                    case "b":
                        newfontname = fonts["boldfont"]!
                    case "i":
                        newfontname = fonts["italicfont"]!
                    default:
                        if let _font = fonts[_commandName] {
                            newfontname = _font
                        } else {
                            newfontname = ""
                        }
                    }
                    
                    if let newfont = UIFont(name: newfontname, size: oldfontsize) {
                        attrs.append((NSFontAttributeName, newfont))
                    }
                    
                case "ForegroundColor":
                    var newcolor = UIColor.black
                    if _commandName == "color" {
                        if let _newcolorname = parameter(in: _command, withKey: "name"),
                            let _newcolor = colors[_newcolorname] {
                            newcolor = _newcolor
                        } else if let _ = parameter(in: _command, withKey: "rgb") {
                            //TODO: 设置 rbg 颜色
                        }
                    } else {
                        if let _newcolor = colors[_commandName] {
                            newcolor = _newcolor
                        }
                    }
                    
                    attrs.append((NSForegroundColorAttributeName, newcolor))
                    
                case "BackgroundColor":
                    var newcolor = UIColor.black
                    if let _newcolorname = parameter(in: _command, withKey: "name"),
                        let _newcolor = colors[_newcolorname] {
                        newcolor = _newcolor
                    } else if let _ = parameter(in: _command, withKey: "rgb") {
                        //TODO: 设置 rbg 颜色
                    }
                    
                    attrs.append((NSBackgroundColorAttributeName, newcolor))
                    
                case "Alignment":
                    let style = NSMutableParagraphStyle()
                    if let _olds = lastAttr(in: attrs, with: NSParagraphStyleAttributeName) {
                        style.setParagraphStyle(_olds as! NSParagraphStyle)
                    } else {
                        #if os(iOS)
                        style.setParagraphStyle(NSParagraphStyle.default)
                        #elseif os(OSX)
                        style.setParagraphStyle(NSParagraphStyle.default())
                        #endif
                    }
                    
                    if _commandName == "align" {
                        if let _position = parameter(in: _command, withKey: "to") {
                            switch _position {
                            case "left":
                                style.alignment = .left
                            case "center":
                                style.alignment = .center
                            case "right":
                                style.alignment = .right
                            default:
                                break
                            }
                        }
                    } else {
                        switch _commandName {
                        case "left":
                            style.alignment = .left
                        case "center":
                            style.alignment = .center
                        case "right":
                            style.alignment = .right
                        default:
                            break
                        }
                    }
                    attrs.append((NSParagraphStyleAttributeName, style))
                    
                default:
                    // should not put actions here
                    break
                }
            }else {
                // unknow command, do nothing
            }
            
            formatedLocation = result.range.location + result.range.length
        }
        
        return _result
    }
    
}
