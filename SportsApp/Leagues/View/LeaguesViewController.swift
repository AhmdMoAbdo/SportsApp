//
//  LeaguesViewController.swift
//  SportsApp
//
//  Created by Ahmed on 20/05/2023.
//

import UIKit
import Kingfisher
import Alamofire

class LeaguesViewController: UIViewController {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var leagueTable: UITableView!
    var sport:String = ""
    var arr:[League] = []
    var parameters:Parameters!
    var country:Country!
    var headerText = ""
    var networkIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        networkIndicator = UIActivityIndicatorView(style: .large)
        networkIndicator.center = self.view.center
        self.view.addSubview(networkIndicator)
        networkIndicator.startAnimating()
        countryName.text = headerText
        let cellNib = UINib(nibName: "CustomLeaguesTableViewCell", bundle: nil)
        leagueTable.register(cellNib, forCellReuseIdentifier: "customLeagueCell")
        let viewModel = ViewModel(api: ApiHandler())
        viewModel.getItems(parameters: &parameters,sport:sport){[weak self] (result:[League]) in
            if(result.isEmpty){
                self?.arr = Array()
            }else{
                self?.arr = result
                DispatchQueue.main.async { [weak self] in
                    self?.leagueTable.reloadData()
                    self?.networkIndicator.stopAnimating()
                }
            }
        }

    }

    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LeaguesViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customLeagueCell") as! CustomLeaguesTableViewCell
        cell.leagueName.text = arr[indexPath.row].league_name
        cell.leagueImage.kf.setImage(with:URL(string: arr[indexPath.row].league_logo ?? ""), placeholder: UIImage(named: sport))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leagueDetails = self.storyboard?.instantiateViewController(withIdentifier: "leagueDetails") as! LeagueDetailsViewController
        leagueDetails.league = arr[indexPath.row]
        leagueDetails.sport = self.sport
        self.present(leagueDetails, animated: true)
    }
    
}
