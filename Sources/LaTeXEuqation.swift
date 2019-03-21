//
//  LaTeXEuqation.swift
//  TextFormater
//
//  Created by 高宇 on 2019/3/16.
//

import Foundation
import MarkdownKit
import iosMath

open class LaTeXEquation: MarkdownCommonElement,MarkdownElement {
    
    fileprivate static let regex = "(.?|^)(\\${1,2})(.+?)(\\2)"
    
    open var font: MarkdownFont?
    open var color: MarkdownColor?
    private var textAlignment = MTTextAlignment.left
    private var labelMode = MTMathUILabelMode.text
    
    open var regex: String {
        return LaTeXEquation.regex
    }
    
    public init(font: MarkdownFont? = MarkdownParser.defaultFont,
                color: MarkdownColor? = MarkdownParser.defaultColor) {
        self.font = font
        self.color = color
    }
    
    #if os(iOS)
    private func getImage(from label: MTMathUILabel) -> UIImage? {
        var newFrame = label.frame
        newFrame.size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        label.frame = newFrame
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let verticalFlip = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: label.frame.size.height)
        context.concatenate(verticalFlip)
        label.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(), let cgImage = image.cgImage else {
            return nil
        }
        UIGraphicsEndImageContext()
        return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: image.imageOrientation)
    }
    #elseif os(OSX)
    private func getImage(from label: MTMathUILabel) -> NSImage? {
        label.setFrameSize(label.fittingSize)
        //get image data of LaTeX
        guard let pdfimage = NSImage(data: label.dataWithPDF(inside: label.bounds)) else {
            return nil
        }
        //flip image
        let image = NSImage(size: (pdfimage.size), flipped: true){
            (rect:NSRect) -> Bool in
            pdfimage.draw(in: rect, from: NSZeroRect, operation: NSCompositingOperation.sourceOver, fraction: 1)
            return true
        }
        return image
    }
    #endif
    
    private func formatLaTeX(latex:String) -> NSMutableAttributedString {
        let label = MTMathUILabel()
        label.textColor = self.color ?? MarkdownColor.black
        label.fontSize = self.font?.pointSize ?? 20
        label.labelMode = self.labelMode
        label.textAlignment = self.textAlignment
        label.latex = latex
        
        guard let image = self.getImage(from: label) else {
            return NSMutableAttributedString(string: latex)
        }
        
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        let latexString = NSMutableAttributedString(attachment: textAttachment)
        if self.labelMode == .display {
            latexString.insert(NSAttributedString(string: "\n"), at: latexString.length)
            latexString.insert(NSAttributedString(string: "\n"), at: 0)
        }
        if self.textAlignment == .center {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            latexString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, latexString.length))
        }
        return latexString
    }
    
    open func addAttributes(_ attributedString: NSMutableAttributedString, range: NSRange) {
        let latex = attributedString.attributedSubstring(from: range).string.replacingOccurrences(of: "\\005c", with: "\\")
        let latexString = formatLaTeX(latex: latex)
        latexString.addAttribute(.baselineOffset, value: CGFloat(-latexString.size().height/2+((self.font?.pointSize ?? 0)/2)), range: NSRange(location: 0, length: latexString.length))

        attributedString.replaceCharacters(in: range, with: latexString)
    }
    
    public func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
        
        let command = attributedString.attributedSubstring(from: match.range(at: 2)).string
        
        if command == "$" {
            self.labelMode = .text
            self.textAlignment = .left
        } else {
            // "$$"
            self.labelMode = .display
            self.textAlignment = .center
        }
        // deleting trailing markdown
        attributedString.deleteCharacters(in: match.range(at: 4))
        // formatting string (may alter the length)
        addAttributes(attributedString, range: match.range(at: 3))
        // deleting leading markdown
        attributedString.deleteCharacters(in: match.range(at: 2))
    }
}

