//
//  ViewController.swift
//  SportsApp
//
//  Created by Ahmed on 19/05/2023.
//

import UIKit
import Alamofire

struct Sport{
    var name:String
    var img:String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var allSportsCollection: UICollectionView!
    var arr:[Sport] = [Sport(name: "FootBall", img: "football"),
                     Sport(name: "BasketBall", img: "basketball"),
                     Sport(name: "Tennis", img: "tennis"),
                     Sport(name: "Cricket", img: "cricket")]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllSportsCell", for:indexPath) as! AllSportsCollectionViewCell
        cell.name.text = arr[indexPath.row].name
        cell.img.image = UIImage(named:arr[indexPath.row].img)
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 3.3, height: 5.7)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.masksToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-16, height: collectionView.frame.height/2-16)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let countries = self.storyboard?.instantiateViewController(withIdentifier: "countries") as! CountriesViewController
        let leagues = self.storyboard?.instantiateViewController(withIdentifier: "leagues") as! LeaguesViewController
        switch indexPath.row {
        case 0:
            countries.sport = "football"
            countries.headerTitle = "All Countries"
            self.navigationController?.pushViewController(countries, animated: true)
        case 1:
            countries.sport = "basketball"
            countries.headerTitle = "All Countries"
            self.navigationController?.pushViewController(countries, animated: true)
        case 2:
            countries.sport = "tennis"
            countries.headerTitle = "Categories"
            self.navigationController?.pushViewController(countries, animated: true)
        default:
            leagues.sport = "cricket"
            leagues.parameters = ["met": "Leagues"]
            leagues.headerText = "All Leagues"
            self.navigationController?.pushViewController(leagues, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell!.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell!.layer.shadowRadius = 0.0
        cell!.layer.shadowOpacity = 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell!.layer.shadowOffset = CGSize(width: 3.3, height: 5.7)
        cell!.layer.shadowRadius = 8.0
        cell!.layer.shadowOpacity = 0.7
    }
}

