//
//  CharacterInTitleController.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 22.11.2022.
//

import UIKit

class CharacterInTitleController: UIViewController {
    
    @IBOutlet weak var textView : UITextView!
    var chars = [String:Int]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Characters In Titles", comment: "")
        self.formatingCharacterInTitleCount()
    }
    
    func formatingCharacterInTitleCount(){
        let character = NSLocalizedString("character", comment: "")
        let time = NSLocalizedString("time", comment: "")
        let times = NSLocalizedString("times", comment: "")
        let keys = chars.keys.sorted(by: {$0<$1})
       var str = ""
        for key in keys {
            if let count = chars[key] {
                str.append(character + " \"\(key)\" - \(count) ")
                str.append((count == 1 ? time : times) + " \n")
            }
        }
        textView.text = str
    }
    
}
