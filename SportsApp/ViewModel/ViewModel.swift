//
//  ViewModel.swift
//  SportsApp
//
//  Created by Ahmed on 19/05/2023.
//

import Foundation
import Alamofire

protocol ViewModelProtocol{
    func getItems<T:Decodable>(parameters:inout Parameters,sport:String,completionHandler:@escaping ([T]) -> Void)
}

class ViewModel:ViewModelProtocol{
    private var apiClient:ApiProtocol
    init(api:ApiProtocol) {
        apiClient = api
    }
    func getItems<T:Decodable>(parameters:inout Parameters,sport:String,completionHandler:@escaping ([T]) -> Void){
        apiClient.getData(parameters: &parameters,sport:sport) { (result : Responce?) in
            completionHandler(result?.result ?? Array())
        }
    }
}
