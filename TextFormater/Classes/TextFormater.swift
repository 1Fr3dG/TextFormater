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
    typealias UIFont = NSFont
    typealias UIColor = NSColor
#endif

/// 文本格式化器
/// 将含有预定义格式化命令的 String 转化为 NSAttributedString
public class TextFormater : NSObject {
    /// 格式化命令控制字符
    public var _cs = "<"
    public var _ce = ">"
    
    /// 缺省格式前缀, 将附加在所有格式文本之前
    public var defaultFormat: String = ""
    /// 动态格式前缀，将附加在所有格式文本之前，defaultFormat 之后
    /// 用于 traitCollectionDidChange 等情况调整格式化参数
    public var dynamicFormat: String = ""
    
    /// 定制化字体
    public private(set) var fonts : [String : String] = [
        "normalfont" : UIFont.systemFont(ofSize: UIFont.systemFontSize).fontName,
        "boldfont" : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize).fontName,
        "italicfont" : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize).fontName,
        ]
    /// 设置定制化字体
    /// - parameter name: 格式化命令名
    /// - parameter font: 对应字体
    public func setFont(name: String, font: UIFont) {
        fonts[name.lowercased()] = font.fontName
        setCommand(command: name.lowercased(), squance: "ThemeFont")
    }
    
    /// 标准字号
    public var normalFontSize: CGFloat = UIFont.systemFontSize
    
    /// 定制化颜色
    public private(set) var colors : [String : UIColor] = [
        "defaultColor" : UIColor.black,
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
    /// - parameter name: 格式化命令名，该命令只用于前景色；该颜色可用于 \<bgcolor name=colorname\> 命令
    /// - parameter color: 对应颜色
    public func setColor(name: String, color: UIColor) {
        colors[name.lowercased()] = color
        setCommand(command: name.lowercased(), squance: "ForegroundColor")
    }
    
    /// 命令序列
    public private(set) var commandSquance : [String : String] = [
        "/" : "End",
        "#" : "Comments",
        "comment" : "Comments",
        "br": "NewLine",
        "font" : "Font",
        "color" : "ForegroundColor",
        "align" : "Alignment",
        "left" : "Alignment",
        "center" : "Alignment",
        "right" : "Alignment",
        "b" : "ThemeFont",
        "i" : "ThemeFont",
        "fontsize" : "FontSizeAdjust",
        
    ]
    
    /// 增加格式化命令
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
    private func lastAttr(in attrs: [(String, Any)], with attrName: String) -> Any? {
        for (key, value) in attrs.reversed() {
            if key == attrName {
                return value
            }
        }
        return nil
    }
    
    /// 查找命令参数
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
    public func format(_ text: String?) -> NSAttributedString {
        let _text: String
        let _result = NSMutableAttributedString(string: "")
        
        let _controlSequancePattern = _cs + "[^" + _cs + _ce + "]*?" + _ce
        let regular = try! NSRegularExpression(pattern: _controlSequancePattern, options: .useUnicodeWordBoundaries)
        
        // 添加附加格式设置
        if text == nil || text == "" {
            return _result
        } else {
            let _appendx = ""
            // 目前不要求强制关闭标签
            //            for _ in regular.matches(in: KTTextFormater.defaultFormat + formatString, options: .reportProgress , range: NSMakeRange(0, (KTTextFormater.defaultFormat + formatString).characters.count)) {
            //                _appendx += _cs + _ce
            //            }
            _text = defaultFormat + dynamicFormat + text! + _appendx + _cs + _ce
        }
        
        // 文本分段
        var formatedLocation = 0
        var attrs: [(String, Any)] = []
        attrs.append((NSFontAttributeName, UIFont(name: fonts["normalfont"]!, size: normalFontSize) as Any))
        for result in regular.matches(in: _text, options: .reportProgress, range: NSMakeRange(0, _text.utf16.count)) {
            if formatedLocation < result.range.location {
                // 本段为内容
                let _t = (_text as NSString).substring(with: NSRange(location: formatedLocation, length: result.range.location - formatedLocation))
                var _attrDict: [String : Any] = [:]
                for (key, value) in attrs {
                    _attrDict[key] = value
                }
                _result.append(NSAttributedString(string: _t, attributes: _attrDict))
            }
            // 本段为格式命令
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
                        currentfont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                    }
                    let newLineFont = currentfont.withSize(currentfont.pointSize / 2)
                    _result.append(NSAttributedString(string: "\n", attributes: [NSFontAttributeName: newLineFont]))
                    
                case "Comments":
                    break
                    
                case "Font":
                    let oldfont: UIFont
                    if let _font = lastAttr(in: attrs, with: NSFontAttributeName) as? UIFont{
                        oldfont = _font
                    } else {
                        oldfont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
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
                    let oldfontsize = (lastAttr(in: attrs, with: NSFontAttributeName) as? UIFont)?.pointSize ?? UIFont.systemFontSize
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
                    
                case "Alignment":
                    let style = NSMutableParagraphStyle()
                    if let _olds = lastAttr(in: attrs, with: NSParagraphStyleAttributeName) {
                        style.setParagraphStyle(_olds as! NSParagraphStyle)
                    } else {
                        style.setParagraphStyle(NSParagraphStyle.default)
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
