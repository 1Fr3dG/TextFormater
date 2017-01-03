//
//  ViewController.swift
//  TextFormater
//
//  Created by Alfred Gao on 01/01/2017.
//  Copyright (c) 2017 Alfred Gao. All rights reserved.
//

import UIKit
import TextFormater

class ViewController: UIViewController, UITextViewDelegate, GetImageForTextFormater {
    
    let textFormater = TextFormater()
    
    @IBOutlet weak var textResult: UITextView!
    
    @IBOutlet weak var textCode: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textFormater.imageDelegate = self
        textCode.text = "<align to=right><color name=red>blue</> <fontsize +=5>small</> test </> <br><center><blue>-----</></> <br><center><img key=100 width =78.5></><br>"
        textResult.attributedText = textFormater.format(textCode.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textViewDidChange(_ textView: UITextView) {
            textResult.attributedText = textFormater.format(textCode.text)
    }
    
    func getImage(byKey: String) -> UIImage? {
        switch byKey {
        case "50":
            return #imageLiteral(resourceName: "img50")
        case "100":
            return #imageLiteral(resourceName: "img100")
        case "200":
            return #imageLiteral(resourceName: "img200")
        case "400":
            return #imageLiteral(resourceName: "img400")
        case "1600":
            return #imageLiteral(resourceName: "img1600")
        default:
            return nil
        }
    }
}

