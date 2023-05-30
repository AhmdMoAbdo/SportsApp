//
//  LeagueDetailsViewModel.swift
//  SportsApp
//
//  Created by Ahmed on 22/05/2023.
//

import Foundation
import Alamofire

protocol LeagueDetailsViewModelProtocol{
    func getItems<T:Decodable>(parameters:inout Parameters,sport:String,completionHandler:@escaping ([T]) -> Void)
    
    func insertIntoDB(league:League,sport:String)
    func deleteFromDB(league:League,sport:String)
    func isFavourite(league:League,sport:String)->Bool
}

class LeagueDetailsViewModel:LeagueDetailsViewModelProtocol{
    
    private var apiClient:ApiProtocol
    private var dbManger:DBMangerProtocol
    
    init(api:ApiProtocol,db:DBMangerProtocol) {
        apiClient = api
        dbManger = db
    }
    
    func getItems<T:Decodable>(parameters:inout Parameters,sport:String,completionHandler:@escaping ([T]) -> Void){
        apiClient.getData(parameters: &parameters,sport:sport) { (result : Responce?) in
            completionHandler(result?.result ?? Array())
        }
    }
    
    func insertIntoDB(league: League, sport: String) {
        dbManger.insertToCoreData(leagueObj: league, sport: sport.capitalized)
    }
    
    func deleteFromDB(league: League, sport: String) {
        dbManger.deleteFromCoreData(deletedLeague: league, sport: sport.capitalized)
    }
    
    func isFavourite(league: League, sport: String) -> Bool {
        dbManger.isFavourite(leagueInQuestion: league, sport: sport.capitalized)
    }
    
}
