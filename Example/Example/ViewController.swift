//
//  ViewController.swift
//  Example
//
//  Created by 高宇 on 2019/3/19.
//  Copyright © 2019 高宇. All rights reserved.
//

import UIKit
import TextFormater

class TestImageProvider: NSObject,GetImageForTextFormater {
    public func getImage(byKey : String) -> UIImage? {
        return #imageLiteral(resourceName: "test.jpg")
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var labelFormatResult: UILabel!
    @IBOutlet weak var textMarkupString: UITextField!
    
    let textFormater = TextFormater(fontSize:20,
                                    boldFontSize:20,
                                    italicFontSize:20,
                                    equationFontSize:30,
                                    imageDelegate: TestImageProvider())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textMarkupString.text = "#Test #测试  ###Markdown * **Bold 粗体** * *Italic 斜体* * NewLine <br> 换行 * <color red>c</color><color blue>o</color><color yellow>l</color><color purple>o</color>c * <bgcolor red>背</bgcolor><bgcolor blue><color white>景</color></bgcolor><bgcolor green>色</bgcolor> ###LaTeX 1. Inline 行内公式 $\\\\frac { x ^ { 2 } + 4 x } { x - 1 } - \\\\frac { 72 x - 72 } { x ^ { 2 } + 4 x } = 18$ Equation 2. 独立公式 $$\\\\ell ( \\\\theta ) = \\\\sum _ { i = 1 } ^ { m } \\\\log p ( x ; \\\\theta )$$"
        labelFormatResult.attributedText=textFormater.parse(textMarkupString.text ?? "")
        
    }

    @IBAction func textboxMarkupStringChanged(_ sender: Any) {
        labelFormatResult.attributedText=textFormater.parse(textMarkupString.text ?? "")
    }
    
}


