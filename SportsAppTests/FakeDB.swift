//
//  FakeDB.swift
//  SportsAppTests
//
//  Created by Ahmed on 25/05/2023.
//

import Foundation
@testable import SportsApp

class FakeDB:DBMangerProtocol{
    
    var arr:[League] = []
    
    func insertToCoreData(leagueObj: SportsApp.League, sport: String) {
        arr.append(leagueObj)
    }
    
    func fetchFromCoreData(sport: String) -> Array<SportsApp.League> {
        return arr
    }
    
    func deleteFromCoreData(deletedLeague: SportsApp.League, sport: String) {
        for index in arr.indices{
            if arr[index].league_key == deletedLeague.league_key{
                arr.remove(at:index)
            }
        }
    }
    
    func isFavourite(leagueInQuestion: SportsApp.League, sport: String) -> Bool {
        for index in arr.indices{
            if arr[index].league_key == leagueInQuestion.league_key{
                return true
            }
        }
        return false
    }
}
