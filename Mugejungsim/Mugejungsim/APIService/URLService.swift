//
//  URLService.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/28/24.
//

import Foundation

class URLService {
    static let shared = URLService()
    
    let baseURLString: String
    
    private init() {
        self.baseURLString = "https://mugejunsim.store"
//        self.baseURLString = "#"
    }
    
    var baseURL: String {
        return baseURLString
    }
}
