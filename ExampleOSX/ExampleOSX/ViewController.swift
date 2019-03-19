//
//  ViewController.swift
//  ExampleOSX
//
//  Created by 高宇 on 2019/3/14.
//  Copyright © 2019 高宇. All rights reserved.
//

import Cocoa
import TextFormater

class ViewController: NSViewController {

    @IBOutlet weak var labelFormatResult: NSTextField!
    @IBOutlet weak var textMarkupString: NSTextField!
    
    let textFormater = TextFormater()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textMarkupString.stringValue = "Enter markup text here"
        labelFormatResult.attributedStringValue = textFormater.parse("Result here will be")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func textboxMarkupStringChanged(_ sender: Any) {
        labelFormatResult.attributedStringValue = textFormater.parse(textMarkupString.stringValue)
        
    }
    
}

