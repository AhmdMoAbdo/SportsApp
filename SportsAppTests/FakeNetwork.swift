//
//  FakeNetwork.swift
//  SportsAppTests
//
//  Created by Ahmed on 25/05/2023.
//

import Foundation
import Alamofire
@testable import SportsApp

class FakeNetwork{

    var shouldReturnError:Bool
    var response:Responce<Country>
    var country:[Country] = [Country(country_key: 1, country_name: "Egypt", country_iso2: "eg", country_logo: "")]
    
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
        response = Responce<Country>(success: 1,result: country)
    }
    
    func getData(parameters: inout Parameters, sport: String, completionHandler: @escaping (Responce<Country>?) -> Void){
        if shouldReturnError {
            completionHandler(nil)
        }else{
            completionHandler(response)
        }
    }
}
