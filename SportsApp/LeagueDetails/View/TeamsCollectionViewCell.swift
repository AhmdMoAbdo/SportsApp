//
//  TeamsCollectionViewCell.swift
//  SportsApp
//
//  Created by Ahmed on 20/05/2023.
//

import UIKit

class TeamsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
