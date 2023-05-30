//
//  ApiHandler.swift
//  SportsApp
//
//  Created by Ahmed on 19/05/2023.
//

import Foundation
import Alamofire

class ApiHandler:ApiProtocol{
    func getData<T:Decodable>( parameters:inout Parameters,sport:String,completionHandler:@escaping (T?) -> Void){
        let url =  "https://apiv2.allsportsapi.com/\(sport)/?"
        parameters["APIkey"] = "b5a6573a47d03176dae60a6da11e01a1d44c6f3d995b73e390aa04f5e286eec8"
        AF.request(url,parameters: parameters).response{response in
            switch response.result {
            case .success(let data):
                do{
                    let result = try JSONDecoder().decode(T.self, from: data!)
                    completionHandler(result)
                }catch let error{
                    completionHandler(nil)
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
