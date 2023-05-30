//
//  PlayersTableViewCell.swift
//  SportsApp
//
//  Created by Ahmed on 21/05/2023.
//

import UIKit

class PlayersTableViewCell: UITableViewCell {

    @IBOutlet weak var playerNumber: UILabel!
    @IBOutlet weak var playerPosition: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var shirtNOLabel: UILabel!
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
    
    override var frame:CGRect{
        get {return super.frame}
        set(newFrame){
            var frame = newFrame
            frame.origin.x += 8
            frame.size.width -= 16
            frame.origin.y += 8
            frame.size.height -= 16
            super.frame = frame
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
