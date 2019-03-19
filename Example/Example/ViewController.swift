//
//  ViewController.swift
//  Example
//
//  Created by 高宇 on 2019/3/19.
//  Copyright © 2019 高宇. All rights reserved.
//

import UIKit
import TextFormater

class ViewController: UIViewController {

    @IBOutlet weak var labelFormatResult: UILabel!
    @IBOutlet weak var textMarkupString: UITextField!
    
    let textFormater = TextFormater()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textMarkupString.text = "Enter Markup String here."
        labelFormatResult.attributedText=textFormater.parse(textMarkupString.text ?? "")
        
    }

    @IBAction func textboxMarkupStringChanged(_ sender: Any) {
        labelFormatResult.attributedText=textFormater.parse(textMarkupString.text ?? "")
    }
    
}


