//
//  ApiProtocol.swift
//  SportsApp
//
//  Created by Ahmed on 19/05/2023.
//

import Foundation
import Alamofire

protocol ApiProtocol{
    func getData<T:Decodable>( parameters:inout Parameters,sport:String,completionHandler:@escaping (T?) -> Void)
}
