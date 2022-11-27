//
//  MoviewDetailsController.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 21.11.2022.
//

import UIKit

class MoviewDetailsController: UIViewController {
    
    @IBOutlet weak var movieTitleLabel : UILabel!
    @IBOutlet weak var movieImageView : UIImageView!
    var movie : Movie?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Movie Details", comment: "")
        movieTitleLabel.text = movie?.title
        if let imageUrl = self.movie?.image {
            if let url = URL(string: imageUrl){
                movieImageView.downloadImage(fromUrl: url)
            }
        }
    }
    
}
