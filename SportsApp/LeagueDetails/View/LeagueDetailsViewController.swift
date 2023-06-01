//
//  LeagueDetailsViewController.swift
//  SportsApp
//
//  Created by Ahmed on 20/05/2023.
//

import UIKit
import Kingfisher
import Alamofire

class LeagueDetailsViewController: UIViewController {
    
    @IBOutlet weak var heartImg: UIImageView!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueDetailsCollection: UICollectionView!
    var viewModel:LeagueDetailsViewModel!
    var upcomingEvents:[Event] = []
    var latestResults:[Event] = []
    var teams:[Team] = []
    var league:League!
    var sport:String = ""
    var isFavorite = true
    var currentDate = ""
    var prevYear = ""
    var nextYear = ""
    var favConrtoller:FavoritesViewController!
    var latestHeaderCount = 0
    var teamsCount = 0
    var fakeCell = 0
    var networkIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkIndicator = UIActivityIndicatorView(style: .large)
        networkIndicator.center = self.view.center
        self.view.addSubview(networkIndicator)
        networkIndicator.startAnimating()
        var group = DispatchGroup()
        prepareDates()
        leagueName.text = league.league_name
        let cellNib = UINib(nibName: "EventCollectionViewCell", bundle: nil)
        leagueDetailsCollection.register(cellNib, forCellWithReuseIdentifier: "leagueDetailsCell")
        let teamsCellNib = UINib(nibName: "TeamsCollectionViewCell", bundle: nil)
        leagueDetailsCollection.register(teamsCellNib, forCellWithReuseIdentifier: "teamsCell")
        let headerNib = UINib(nibName: "HeaderCollectionViewCell", bundle: nil)
        leagueDetailsCollection.register(headerNib, forCellWithReuseIdentifier: "header")
        
        viewModel = LeagueDetailsViewModel(api: ApiHandler(), db: DBManger(appDelegate: UIApplication.shared.delegate as? AppDelegate))
            isFavorite = viewModel.isFavourite(league: league, sport: sport)
            if(isFavorite){
                heartImg.image = UIImage(systemName: "heart.fill")
            }else{
                heartImg.image = UIImage(systemName: "heart")
            }
        var upComingParameters: Parameters = [
            "met": "Fixtures",
            "leagueId":"\(league.league_key!)",
            "from":currentDate,
            "to":nextYear
        ]
        group.enter()
        viewModel.getItems(parameters: &upComingParameters,sport:sport){[weak self] (result:[Event]) in
            group.leave()
            if(result.isEmpty){
                self?.upcomingEvents = Array()
                self?.fakeCell = 1
                DispatchQueue.main.async { [weak self] in
                    self?.leagueDetailsCollection.reloadData()
                }
            }else{
                self?.upcomingEvents = result
                DispatchQueue.main.async { [weak self] in
                    self?.leagueDetailsCollection.reloadData()
                }
            }
        }
        var latestParameters: Parameters = [
            "met": "Fixtures",
            "leagueId":"\(league.league_key!)",
            "from":prevYear,
            "to":currentDate
        ]
        group.enter()
        viewModel.getItems(parameters: &latestParameters,sport:sport){[weak self] (result:[Event]) in
            group.leave()
            if(result.isEmpty){
                self?.latestResults = Array()
            }else{
                self?.latestResults = result
                if(!(self?.latestResults.isEmpty)!){
                    self?.latestHeaderCount = 1
                }
                DispatchQueue.main.async { [weak self] in
                    self?.leagueDetailsCollection.reloadData()
                }
            }
        }
        
        var teamsParameters: Parameters = [
            "met": "Teams",
            "leagueId":"\(league.league_key!)"
        ]
        if(sport == "tennis"){
            teamsParameters["met"] = "Players"
            teamsParameters.removeValue(forKey: "leagueId")
            group.enter()
            viewModel.getItems(parameters: &teamsParameters,sport:sport){[weak self] (result:[Team]) in
                group.leave()
                if(result.isEmpty){
                    self?.teams = Array()
                }else{
                    self?.teams = result
                    if(!(self?.teams.isEmpty)!){
                        self?.teamsCount = 1
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.leagueDetailsCollection.reloadData()
                    }
                }
            }
        }else{
            viewModel.getItems(parameters: &teamsParameters,sport:sport){[weak self] (result:[Team]) in
                if(result.isEmpty){
                    self?.teams = Array()
                }else{
                    self?.teams = result
                    if(!(self?.teams.isEmpty)!){
                        self?.teamsCount = 1
                    }
                    DispatchQueue.main.async {
                        self?.leagueDetailsCollection.reloadData()
                    }
                }
            }
        }
        
        let layout = UICollectionViewCompositionalLayout{index,environment in
            switch index{
            case 0:
                return self.drawHeaderSection()
            case 1:
                return self.drawTheTopSection()
            case 2:
                return self.drawHeaderSection()
            case 3:
                return self.drawMiddleSection()
            case 4:
                return self.drawHeaderSection()
            default:
                if(self.sport != "tennis"){
                    return self.drawBottomSection()
                }else{
                    return self.drawMiddleSection()
                }
            }
        }
        leagueDetailsCollection.setCollectionViewLayout(layout, animated: true)
        group.notify(queue: .main){[weak self] in
            self?.networkIndicator.stopAnimating()
        }
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func addToOrDeleteFromFavorites(_ sender: Any) {
        if(isFavorite){
            isFavorite = false
            viewModel.deleteFromDB(league: league, sport: sport)
            heartImg.image = UIImage(systemName: "heart")
            let alert = UIAlertController(title: "Done", message: "Removed From Favorites", preferredStyle: .actionSheet)
            let actionOk = UIAlertAction(title: "OK", style: .default)
            alert.addAction(actionOk)
            self.present(alert, animated: true)
            
        }else{
            isFavorite = true
            viewModel.insertIntoDB(league: league, sport: sport)
            heartImg.image = UIImage(systemName: "heart.fill")
            let alert = UIAlertController(title: "Done", message: "Added To Favorites", preferredStyle: .actionSheet)
            let actionOk = UIAlertAction(title: "OK", style: .default)
            alert.addAction(actionOk)
            self.present(alert, animated: true)
        }
    }
    
    func prepareDates(){
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let dateAndTime = formatter.string(from: currentDateTime)
        let arr = dateAndTime.components(separatedBy: ",")[0].components(separatedBy: "/")
        currentDate = "\(arr[2])-\(arr[1])-\(arr[0])"
        print(currentDate)
        prevYear = "\(Int(arr[2])!-1)-\(arr[1])-\(arr[0])"
        nextYear = "\(Int(arr[2])!+1)-\(arr[1])-\(arr[0])"
    }
}

extension LeagueDetailsViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func drawTheTopSection()->NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = {(items,offset,environment) in
            items.forEach{item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width/2.0)
                let minScale:CGFloat = 0.8
                let maxScale:CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return section
    }
    
    func drawMiddleSection()->NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 0)
        return section
    }
    
    func drawHeaderSection()->NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        return section
    }
    
    func drawBottomSection()->NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 0)
        return section
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return max(min(10, upcomingEvents.count),fakeCell)
        case 2:
            return latestHeaderCount
        case 3:
            return min(10,latestResults.count)
        case 4:
            return teamsCount
        default:
            return teams.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath) as! HeaderCollectionViewCell
            cell.headerLabel.text = "Upcoming Events"
            return cell
        case 1:
            if(upcomingEvents.isEmpty){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamsCell", for: indexPath) as! TeamsCollectionViewCell
                cell.teamImg.image = UIImage(named: sport)
                let path = UIBezierPath(roundedRect:cell.overlayView.bounds,
                                        byRoundingCorners:[.topRight, .topLeft],
                                        cornerRadii: CGSize(width: 20, height:  20))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                cell.overlayView.layer.mask = maskLayer
                cell.teamName.text = "Data Not Available"
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "leagueDetailsCell", for: indexPath) as! EventCollectionViewCell
                if(sport == "tennis"){
                    cell.awayTeamImg.kf.setImage(with:URL(string: upcomingEvents[indexPath.row].event_second_player_logo ?? ""), placeholder: UIImage(named: sport))
                    cell.homeTeamImg.kf.setImage(with:URL(string: upcomingEvents[indexPath.row].event_first_player_logo ?? ""), placeholder: UIImage(named: sport))
                    cell.awayTeamNameLabel.text = upcomingEvents[indexPath.row].event_second_player
                    cell.homeTeamNameLabel.text = upcomingEvents[indexPath.row].event_first_player
                }
                else{
                    cell.awayTeamImg.kf.setImage(with:URL(string: upcomingEvents[indexPath.row].away_team_logo ?? ""), placeholder: UIImage(named: sport))
                    cell.homeTeamImg.kf.setImage(with:URL(string: upcomingEvents[indexPath.row].home_team_logo ?? ""), placeholder: UIImage(named: sport))
                    cell.awayTeamNameLabel.text = upcomingEvents[indexPath.row].event_away_team
                    cell.homeTeamNameLabel.text = upcomingEvents[indexPath.row].event_home_team
                    cell.leagueImg.kf.setImage(with:URL(string: upcomingEvents[indexPath.row].league_logo ?? ""), placeholder: UIImage(named: sport))
                }
                cell.dateLabel.text = upcomingEvents[indexPath.row].event_date
                cell.timeLabel.text = upcomingEvents[indexPath.row].event_time
                cell.scoreLabel.isHidden = true
                return cell
            }
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath) as! HeaderCollectionViewCell
            cell.headerLabel.text = "Latest Results"
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "leagueDetailsCell", for: indexPath) as! EventCollectionViewCell
            if(sport == "tennis"){
                cell.awayTeamImg.kf.setImage(with:URL(string: latestResults[indexPath.row].event_second_player_logo ?? ""), placeholder: UIImage(named: sport))
                cell.homeTeamImg.kf.setImage(with:URL(string: latestResults[indexPath.row].event_first_player_logo ?? ""), placeholder: UIImage(named: sport))
                cell.awayTeamNameLabel.text = latestResults[indexPath.row].event_second_player
                cell.homeTeamNameLabel.text = latestResults[indexPath.row].event_first_player
            }else{
                cell.awayTeamImg.kf.setImage(with:URL(string: latestResults[indexPath.row].away_team_logo ?? ""), placeholder: UIImage(named: sport))
                cell.homeTeamImg.kf.setImage(with:URL(string: latestResults[indexPath.row].home_team_logo ?? ""), placeholder: UIImage(named: sport))
                cell.awayTeamNameLabel.text = latestResults[indexPath.row].event_away_team
                cell.homeTeamNameLabel.text = latestResults[indexPath.row].event_home_team
            }
            cell.leagueImg.kf.setImage(with:URL(string: latestResults[indexPath.row].league_logo ?? ""), placeholder: UIImage(named: sport))
            cell.dateLabel.text = latestResults[indexPath.row].event_date
            cell.timeLabel.text = latestResults[indexPath.row].event_time
            cell.scoreLabel.text = latestResults[indexPath.row].event_final_result
            
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath) as! HeaderCollectionViewCell
            cell.headerLabel.text = "All Teams"
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamsCell", for: indexPath) as! TeamsCollectionViewCell
            cell.teamImg.kf.setImage(with:URL(string: teams[indexPath.row].team_logo ?? ""), placeholder: UIImage(named: sport))
            cell.teamName.text = teams[indexPath.row].team_name
//            cell.teamImg.layer.borderWidth = 4
//            cell.teamImg.layer.borderColor = UIColor.black.cgColor
//            cell.teamImg.layer.cornerRadius = cell.teamImg.frame.height/2
            let path = UIBezierPath(roundedRect:cell.overlayView.bounds,
                                    byRoundingCorners:[.topRight, .topLeft],
                                    cornerRadii: CGSize(width: 20, height:  20))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            cell.overlayView.layer.mask = maskLayer
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 5 && sport == "football"){
            let teamDetails = self.storyboard?.instantiateViewController(withIdentifier: "teamDetails") as! TeamDeatilsViewController
            teamDetails.team = teams[indexPath.row]
            self.present(teamDetails, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(favConrtoller != nil){
            favConrtoller.footballArr = favConrtoller.viewModel.getFavorites(sport: "football")
            favConrtoller.basketballArr = favConrtoller.viewModel.getFavorites(sport: "basketball")
            favConrtoller.cricketArr = favConrtoller.viewModel.getFavorites(sport: "cricket")
            favConrtoller.tennisArr = favConrtoller.viewModel.getFavorites(sport: "tennis")
            favConrtoller.favoriteLeaguesTable.reloadData()
            if(favConrtoller.footballArr.isEmpty && favConrtoller.basketballArr.isEmpty && favConrtoller.cricketArr.isEmpty && favConrtoller.tennisArr.isEmpty){
                favConrtoller.emptyView.isHidden = false
                favConrtoller.favoriteLeaguesTable.isHidden = true
            }else{
                favConrtoller.emptyView.isHidden = true
                favConrtoller.favoriteLeaguesTable.isHidden = false
            }
        }
    }
}


