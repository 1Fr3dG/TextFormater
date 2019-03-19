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
    
    fileprivate static let regex = "(.?|^)(\\${1,3})(.+?)(\\2)"
    
    open var font: MarkdownFont?
    open var color: MarkdownColor?
    open var textHighlightColor: MarkdownColor?
    open var textBackgroundColor: MarkdownColor?
    
    open var regex: String {
        return LaTeXEquation.regex
    }
    
    public init(font: MarkdownFont? = MarkdownCode.defaultFont,
                color: MarkdownColor? = nil,
                textHighlightColor: MarkdownColor? = MarkdownCode.defaultHighlightColor,
                textBackgroundColor: MarkdownColor? = MarkdownCode.defaultBackgroundColor) {
        self.font = font
        self.color = color
        self.textHighlightColor = textHighlightColor
        self.textBackgroundColor = textBackgroundColor
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
    
    private func formatLaTeX(latex:String, color:MarkdownColor? = nil) -> NSAttributedString {
        let label = MTMathUILabel()
        label.textColor = color ?? self.color ?? MarkdownColor.black
        label.latex = latex
        
        guard let image = self.getImage(from: label) else {
            return NSAttributedString(string: latex)
        }
        
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        let latexString = NSMutableAttributedString(attachment: textAttachment)
        return latexString
    }
    
    open func addAttributes(_ attributedString: NSMutableAttributedString, range: NSRange) {
        print(attributedString.string)
        let latex = attributedString.attributedSubstring(from: range).string.replacingOccurrences(of: "\\005c", with: "\\")
        print(latex)
        let latexString = formatLaTeX(latex: latex)

        attributedString.replaceCharacters(in: range, with: latexString)
    }
}

