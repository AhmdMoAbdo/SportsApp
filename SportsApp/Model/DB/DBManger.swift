//
//  DBManger.swift
//  SportsApp
//
//  Created by Ahmed on 22/05/2023.
//

import Foundation
import CoreData

protocol DBMangerProtocol{
    func insertToCoreData(leagueObj:League,sport:String)
    func fetchFromCoreData(sport:String)->Array<League>
    func deleteFromCoreData(deletedLeague:League,sport:String)
    func isFavourite(leagueInQuestion:League,sport:String)->Bool
}

class DBManger:DBMangerProtocol{
    
    var appDelegate:AppDelegate!
    var managerContext:NSManagedObjectContext!
    
    init(appDelegate: AppDelegate!) {
        self.appDelegate = appDelegate
        self.managerContext = appDelegate.persistentContainer.viewContext
    }
    
    
    func insertToCoreData(leagueObj:League,sport:String){
        let entity = NSEntityDescription.entity(forEntityName: sport, in: managerContext)
        let league = NSManagedObject(entity: entity!, insertInto: managerContext)
        league.setValue(leagueObj.league_key, forKey: "key")
        league.setValue(leagueObj.league_logo, forKey: "logo")
        league.setValue(leagueObj.league_name, forKey: "name")
        do{
            try managerContext.save()
            print("inserted")
        }catch let error as NSError{
                print(error.localizedDescription)
        }
    }
    
    func fetchFromCoreData(sport:String)->Array<League>{
        var arr:Array<League> = Array()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:sport)
        do{
            let returnedArr = try managerContext.fetch(fetchRequest)
            for item in returnedArr{
                var league = League()
                league.league_name = item.value(forKey: "name") as? String
                league.league_key = item.value(forKey: "key") as? Int
                league.league_logo = item.value(forKey: "logo") as? String
                arr.append(league)
            }
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        return arr
    }
    
    func deleteFromCoreData(deletedLeague:League,sport:String){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: sport)
        do{
            let returnedArr = try managerContext.fetch(fetchRequest)
            for item in returnedArr{
                if(deletedLeague.league_key == item.value(forKey: "key") as? Int){
                    managerContext.delete(item)
                }
            }
            do{
                try managerContext.save()
                print("Deleted")
            }catch let error as NSError{
                print(error.localizedDescription)
            }
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    
    func isFavourite(leagueInQuestion:League,sport:String)->Bool{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: sport)
        do{
            let returnedArr = try managerContext.fetch(fetchRequest)
            for item in returnedArr{
                if(leagueInQuestion.league_key == item.value(forKey: "key") as? Int){
                    return true
                }
            }
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        return false
    }
    
}
