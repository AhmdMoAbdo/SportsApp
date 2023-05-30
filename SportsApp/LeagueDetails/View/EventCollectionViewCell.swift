//
//  EventCollectionViewCell.swift
//  SportsApp
//
//  Created by Ahmed on 20/05/2023.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var homeTeamImg: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var leagueImg: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var awayTeamImg: UIImageView!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .white
        backgroundColor = .clear
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3.3, height: 5.7)
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.7
        layer.masksToBounds = false
    }

}
