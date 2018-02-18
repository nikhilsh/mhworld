//
//  Builder.swift
//  mhworld
//
//  Created by Nikhil Sharma on 14/2/18.
//  Copyright © 2018 nikhil. All rights reserved.
//

import Foundation
import ObjectMapper

struct Builder: Mappable {
    var skills: [String: Int]?
    var head: String?
    var legs: String?
    var body: String?
    var waist: String?
    var arms: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        skills <- map["skills"]
        head <- map["head"]
        legs <- map["legs"]
        body <- map["body"]
        waist <- map["waist"]
        arms <- map["arms"]
    }
}
