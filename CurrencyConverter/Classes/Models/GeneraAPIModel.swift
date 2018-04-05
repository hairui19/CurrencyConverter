//
//  GeneraAPIModel.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import ObjectMapper

struct GeneraAPIModel : ImmutableMappable {
    let success : Bool
    private let errorData : Any?
    
    var error : GenenralAPIErrorModel?{
        guard let errorData = errorData else{
            return nil
        }
        return try? Mapper<GenenralAPIErrorModel>().map(JSONObject: errorData)
    }
    
    init(map: Map) throws {
        self.success = try map.value("success")
        self.errorData = try? map.value("error")
    }
}

struct GenenralAPIErrorModel : ImmutableMappable{
    init(map: Map) throws {
        self.code = try map.value("code")
        self.type = try map.value("type")
        self.info = try map.value("info")
    }
    
    var code : String
    var type : String
    var info : String
    
}
