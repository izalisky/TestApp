//
//  MoviewPreviewCell.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 21.11.2022.
//

import UIKit

class MoviewPreviewCell: UITableViewCell {
    @IBOutlet weak var movieImageView : UIImageView!
    @IBOutlet weak var movieTitleLabel : UILabel!
    @IBOutlet weak var movieRankLabel : UILabel!
    
    var movie : Movie? {
        didSet {
            if movie != oldValue {
            movieTitleLabel.text = movie?.title
            movieRankLabel.text = movie?.rank
                if let imageUrl = movie?.image {
                    movieImageView.downloadImage(fromUrl: URL(string: imageUrl)!)
                }
            }
        }
    }
    
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
