//
//  UniversityRequest.swift
//  todoapp
//
//  Created by Benjamin Earley on 12/21/18.
//  Copyright © 2018 Benjamin Earley. All rights reserved.
//

import Foundation

class UniversityRequest: APIRequest {
    var method = RequestType.GET
    var path = "search"
    var parameters = [String: String]()
    
    init(name: String) {
        parameters["name"] = name
    }
}
