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
        self.title = "Movie Details"
        movieTitleLabel.text = movie?.title
        movieImageView.downloadImage(fromUrl: URL(string: movie?.image ?? "")!)
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
