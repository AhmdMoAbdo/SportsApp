//
//  TeamDeatilsViewController.swift
//  SportsApp
//
//  Created by Ahmed on 21/05/2023.
//

import UIKit
import Kingfisher

class TeamDeatilsViewController: UIViewController {
    @IBOutlet weak var TeamName: UILabel!
    @IBOutlet weak var PlayersTable: UITableView!
    @IBOutlet weak var TeamImg: UIImageView!
    var team:Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "PlayersTableViewCell", bundle: nil)
        PlayersTable.register(cellNib, forCellReuseIdentifier: "player")
        TeamName.text = team.team_name!
        TeamImg.kf.setImage(with: URL(string: team.team_logo ?? ""), placeholder: UIImage(named: "football"))
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension TeamDeatilsViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team.players!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "player") as! PlayersTableViewCell
        cell.playerName.text = "\(team.players?[indexPath.row].player_name ?? "")"
        cell.playerNumber.text = "\(team.players?[indexPath.row].player_number ?? "")"
        if(cell.playerNumber.text == ""){
            cell.shirtNOLabel.text = ""
        }
        cell.playerPosition.text = "\(team.players?[indexPath.row].player_type ?? "")"
        cell.playerImage.kf.setImage(with: URL(string: team.players?[indexPath.row].player_image ?? ""),placeholder: UIImage(named: "football"))
        cell.playerImage.layer.cornerRadius = 20
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}
