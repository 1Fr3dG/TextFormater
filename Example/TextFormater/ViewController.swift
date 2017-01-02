//
//  ViewController.swift
//  TextFormater
//
//  Created by Alfred Gao on 01/01/2017.
//  Copyright (c) 2017 Alfred Gao. All rights reserved.
//

import UIKit
import TextFormater

class ViewController: UIViewController, UITextViewDelegate {
    
    let textFormater = TextFormater()
    
    @IBOutlet weak var textResult: UITextView!
    
    @IBOutlet weak var textCode: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textResult.attributedText = textFormater.format(textCode.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textViewDidChange(_ textView: UITextView) {
            textResult.attributedText = textFormater.format(textCode.text)
    }
}

