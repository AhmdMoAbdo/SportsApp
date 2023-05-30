//
//  FavoritesViewController.swift
//  SportsApp
//
//  Created by Ahmed on 19/05/2023.
//

import UIKit
import Reachability

class FavoritesViewController: UIViewController {

    var reachability:Reachability!
    @IBOutlet weak var favoriteLeaguesTable: UITableView!
    var footballArr:[League]!
    var basketballArr:[League]!
    var cricketArr:[League]!
    var tennisArr:[League]!
    var viewModel:FavoritesViewModel!
    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            reachability = try Reachability()
        }catch let error{
            print (error.localizedDescription)
        }
        reachability.whenReachable = { _ in
            self.isConnected = true
            print("connected")
        }
        reachability.whenUnreachable = { _ in
            self.isConnected = false
            print("not connected")
        }
        let cellNib = UINib(nibName: "CustomLeaguesTableViewCell", bundle: nil)
        favoriteLeaguesTable.register(cellNib, forCellReuseIdentifier: "customLeagueCell")
        viewModel = FavoritesViewModel(db: DBManger(appDelegate: UIApplication.shared.delegate as? AppDelegate))
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        footballArr = viewModel.getFavorites(sport: "football")
        basketballArr = viewModel.getFavorites(sport: "basketball")
        cricketArr = viewModel.getFavorites(sport: "cricket")
        tennisArr = viewModel.getFavorites(sport: "tennis")
        favoriteLeaguesTable.reloadData()
    }
}

extension FavoritesViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return footballArr.count
        case 1:
            return basketballArr.count
        case 2:
            return cricketArr.count
        default:
            return tennisArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customLeagueCell") as! CustomLeaguesTableViewCell
        switch indexPath.section {
        case 0:
            cell.leagueName.text = footballArr[indexPath.row].league_name
            cell.leagueImage.kf.setImage(with:URL(string: footballArr[indexPath.row].league_logo ?? ""), placeholder: UIImage(named: "football"))
        case 1:
            cell.leagueName.text = basketballArr[indexPath.row].league_name
            cell.leagueImage.kf.setImage(with:URL(string: basketballArr[indexPath.row].league_logo ?? ""), placeholder: UIImage(named: "basketball"))
        case 2:
            cell.leagueName.text = cricketArr[indexPath.row].league_name
            cell.leagueImage.kf.setImage(with:URL(string: cricketArr[indexPath.row].league_logo ?? ""), placeholder: UIImage(named: "cricket"))
        default:
            cell.leagueName.text = tennisArr[indexPath.row].league_name
            cell.leagueImage.kf.setImage(with:URL(string: tennisArr[indexPath.row].league_logo ?? ""), placeholder: UIImage(named: "tennis"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isConnected){
            let leagueDetails = self.storyboard?.instantiateViewController(withIdentifier: "leagueDetails") as! LeagueDetailsViewController
            switch indexPath.section {
            case 0:
                leagueDetails.league = footballArr[indexPath.row]
                leagueDetails.sport = "football"
            case 1:
                leagueDetails.league = basketballArr[indexPath.row]
                leagueDetails.sport = "basketball"
            case 2:
                leagueDetails.league = cricketArr[indexPath.row]
                leagueDetails.sport = "cricket"
            default:
                leagueDetails.league = tennisArr[indexPath.row]
                leagueDetails.sport = "tennis"
            }
            leagueDetails.favConrtoller = self
            self.present(leagueDetails, animated: true)
        }else{
            let alert = UIAlertController(title: "Error", message: "Please Connect to the internet \nto view the league details", preferredStyle: .actionSheet)
            let actionOk = UIAlertAction(title: "OK", style: .default)
            alert.addAction(actionOk)
            self.present(alert, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "Football"
            case 1:
                return "Basketball"
            case 2:
                return "Cricket"
            default:
                return "tennis"
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this league from favorites?", preferredStyle: .alert)
        let actionDelete = UIAlertAction(title: "Delete", style: .destructive) { UIAlertAction in
            switch indexPath.section {
                case 0:
                self.viewModel.deleteFromFavourites(league: self.footballArr[indexPath.row], sport: "football")
                self.footballArr = self.viewModel.getFavorites(sport: "football")
                case 1:
                self.viewModel.deleteFromFavourites(league: self.basketballArr[indexPath.row], sport: "basketball")
                self.basketballArr = self.viewModel.getFavorites(sport: "basketball")
                case 2:
                self.viewModel.deleteFromFavourites(league: self.cricketArr[indexPath.row], sport: "cricket")
                self.cricketArr = self.viewModel.getFavorites(sport: "cricket")
                default:
                self.viewModel.deleteFromFavourites(league: self.tennisArr[indexPath.row], sport: "tennis")
                self.tennisArr = self.viewModel.getFavorites(sport: "tennis")
            }
            self.favoriteLeaguesTable.reloadData()

        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(actionDelete)
        alert.addAction(actionCancel)
        self.present(alert, animated: true)
    }
}
