//
//  Beritacell.swift
//  NewsYoutube
//
//  Created by anca dev on 22/10/23.
//

import UIKit

class Beritacell: UITableViewCell {

    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var labelJudul: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageThumbnail.layer.cornerRadius = 12
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
