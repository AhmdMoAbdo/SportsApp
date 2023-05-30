//
//  FavoriteViewModel.swift
//  SportsApp
//
//  Created by Ahmed on 22/05/2023.
//

import Foundation

protocol FavoritesViewModelProtocol{
    
    func getFavorites(sport:String)->[League]
    func deleteFromFavourites(league:League,sport:String)
}

class FavoritesViewModel:FavoritesViewModelProtocol{
    
    private var dbManger:DBMangerProtocol
    
    init(db:DBMangerProtocol) {
        dbManger = db
    }
    
    func getFavorites(sport: String)->[League] {
        return dbManger.fetchFromCoreData(sport: sport.capitalized)
    }
    
    func deleteFromFavourites(league:League,sport:String){
        dbManger.deleteFromCoreData(deletedLeague: league, sport: sport.capitalized)
    }
}
