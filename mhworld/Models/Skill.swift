//
//  Skill.swift
//  mhworld
//
//  Created by Nikhil Sharma on 11/2/18.
//  Copyright © 2018 nikhil. All rights reserved.
//

import Foundation
import ObjectMapper

struct Skill: Mappable {
    var name: String?
    var level: Int?
    var max: Int?
    var id: Int?
    
    init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
    }
    
    init(name: String, level: Int, id: Int) {
        self.name = name
        self.level = level
        self.id = id
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        level <- map["level"]
        max <- map["max"]
        id <- map["id"]
    }
}
