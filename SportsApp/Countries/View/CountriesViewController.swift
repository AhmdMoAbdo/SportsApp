//
//  CountriesViewController.swift
//  SportsApp
//
//  Created by Ahmed on 19/05/2023.
//

import UIKit
import Alamofire
import Kingfisher

class CountriesViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var countriesCollection: UICollectionView!
    var arr:[Country] = []
    var sport:String = ""
    var headerTitle:String = ""
    var viewModel:ViewModelProtocol!
    var networkIndicator:UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        networkIndicator = UIActivityIndicatorView(style: .large)
        networkIndicator.center = self.view.center
        self.view.addSubview(networkIndicator)
        networkIndicator.startAnimating()
        headerLabel.text = headerTitle
        viewModel = ViewModel(api: ApiHandler())
        prepateData()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    func prepateData(){
        var parameters: Parameters = ["met": "Countries"]
        viewModel.getItems(parameters: &parameters,sport:sport){[weak self] (result:[Country]) in
            if(result.isEmpty){
                self?.arr = Array()
            }else{
                self?.arr = result
                DispatchQueue.main.async { [weak self] in
                    self?.countriesCollection.reloadData()
                    self?.networkIndicator.stopAnimating()
                }
            }
        }
    }
}

extension CountriesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryCell", for:indexPath) as! CountriesCollectionViewCell
        cell.name.text = arr[indexPath.row].country_name
        cell.img.kf.setImage(with:URL(string: arr[indexPath.row].country_logo ?? ""), placeholder: UIImage(named: sport))
        if(sport != "football"){
            cell.img.contentMode = .scaleAspectFit
        }
        cell.contentView.layer.cornerRadius = 20
     //   cell.contentView.backgroundColor = UIColor.white
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 3.3, height: 5.7)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.masksToBounds = false
        cell.labelView.layer.cornerRadius = 10
        cell.labelView.layer.shadowColor = UIColor.gray.cgColor
        cell.labelView.layer.shadowOffset = CGSize(width: 0.1, height: 2.0)
        cell.labelView.layer.shadowRadius = 7.0
        cell.labelView.layer.shadowOpacity = 0.7
        cell.labelView.layer.masksToBounds = false
        
        cell.overlayView.layer.cornerRadius = 10
        cell.overlayView.layer.shadowColor = UIColor.gray.cgColor
        cell.overlayView.layer.shadowOffset = CGSize(width: 0.1, height: 2.0)
        cell.overlayView.layer.shadowRadius = 7.0
        cell.overlayView.layer.shadowOpacity = 0.7
        cell.overlayView.layer.masksToBounds = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 32, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-16, height: collectionView.frame.height/5-16)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let leagues = self.storyboard?.instantiateViewController(identifier: "leagues") as! LeaguesViewController
        leagues.country = arr[indexPath.row]
        leagues.sport = self.sport
        leagues.parameters = [
            "met": "Leagues",
            "countryId":"\(arr[indexPath.row].country_key!)"
        ]
        leagues.headerText = arr[indexPath.row].country_name!
        self.navigationController?.pushViewController(leagues, animated: true)
    }
}

