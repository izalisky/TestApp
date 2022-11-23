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
        self.title = "Characters In Titles"
        self.formatingCharacterInTitleCount()
    }
    
    func formatingCharacterInTitleCount(){
        let keys = chars.keys.sorted(by: {$0<$1})
       var str = ""
        for key in keys {
            str.append("character \"\(key)\" - \(chars[key]!) ")
            str.append(chars[key]! == 1 ? "time \n" : "times \n")
        }
        textView.text = str
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
