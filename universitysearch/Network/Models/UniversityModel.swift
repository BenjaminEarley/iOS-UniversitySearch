//
//  UniversityModel.swift
//  todoapp
//
//  Created by Benjamin Earley on 12/21/18.
//  Copyright © 2018 Benjamin Earley. All rights reserved.
//

import Foundation

struct UniversityModel: Codable {
    let name: String
    let webPages: [String]?
    let country: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case webPages = "web_pages"
        case country
    }
    
    var description: String {
        get {
            if let webPage = webPages?.first {
                return "\(country) • \(webPage)"
            } else {
                return country
            }
        }
    }
}
