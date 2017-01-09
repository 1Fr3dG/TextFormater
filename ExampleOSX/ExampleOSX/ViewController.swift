//
//  ViewController.swift
//  ExampleOSX
//
//  Created by Alfred Gao on 2017/1/4.
//  Copyright © 2017年 Alfred Gao. All rights reserved.
//

import Cocoa
import TextFormater

class ViewController: NSViewController, GetImageForTextFormater {
    
    let textFormater = TextFormater()
    
    @IBOutlet var textResult: NSTextView!
    @IBOutlet weak var textCode: NSTextFieldCell!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFormater.imageDelegate = self
        textCode.title = "<align to=right><color name=red>blue</> <fontsize +=5>small</> test </> <br><center><blue>-----</></> <br><center><img key=100 width=78.5></><br>"
        
        textResult.textStorage?.setAttributedString(textFormater.format(textCode.title)!)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func textChanged(_ sender: Any) {
        textResult.textStorage?.setAttributedString(textFormater.format(textCode.title)!)
    }
    
    func getImage(byKey: String) -> NSImage? {
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

