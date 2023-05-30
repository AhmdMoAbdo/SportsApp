//
//  ModelClasses.swift
//  SportsApp
//
//  Created by Ahmed on 19/05/2023.
//

import Foundation

struct Responce<T:Decodable>:Decodable{
    var success:Int
    var result = Array<T>()
}

struct League:Decodable{
    var league_key:Int?
    var league_name:String?
    var country_key:Int?
    var country_name:String?
    var league_logo:String?
    var country_logo:String?
}

struct Team:Decodable{
    var team_key:Int?
    var team_name:String?
    var team_logo:String?
    var players:Array<Player>?
}

struct Player:Decodable{
    var player_key:Int64?
    var player_name:String?
    var player_number:String?
    var player_country:String?
    var player_type:String?
    var player_age:String?
    var player_match_played:String?
    var player_goals:String?
    var player_yellow_cards:String?
    var player_red_cards:String?
    var player_image:String?
}

struct Country:Decodable{
    var country_key:Int?
    var country_name :String?
    var country_iso2:String?
    var country_logo: String?
}

struct Event:Decodable{
    var event_key:Int?
    var event_date:String?
    var event_time: String?
    var event_home_team:String?
    var home_team_key:Int?
    var event_away_team:String?
    var away_team_key: Int?
    var event_halftime_result:String?
    var event_final_result:String?
    var event_ft_result:String?
    var event_penalty_result:String?
    var event_status:String?
    var country_name:String?
    var league_name:String?
    var league_key:Int?
    var league_round:String?
    var league_season:String
    var event_live:String?
    var event_stadium:String?
    var event_referee:String?
    var home_team_logo:String?
    var away_team_logo:String?
    var event_country_key:Int?
    var league_logo:String?
    var country_logo:String?
    
    //Added for tennis
    var event_first_player:String?
    var first_player_key:Int?
    var event_second_player:String?
    var second_player_key:Int?
    var event_game_result:String?
    var event_serve:String?
    var event_winner:String?
    var event_first_player_logo:String?
    var event_second_player_logo:String?
}

struct TennisPlayer:Decodable{
   // var 
}

extension String {
    var capitalized: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
}


