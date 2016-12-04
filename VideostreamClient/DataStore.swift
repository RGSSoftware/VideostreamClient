//
//  DataStore.swift
//  VideostreamClient
//
//  Created by PC on 11/23/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import Foundation
import Alamofire

typealias NextPageClosure = (_ indexPaths: [NSIndexPath], _ error: Error?) -> (Void)
typealias FetchClosure = (_ isSuccessful: Bool, _ error: Error?) -> (Void)

class DataStore {
    private let limit: Int
    private let baseURL: String
    
    private let streamStatus: Bool?
    
    var currentPage: Int
    
    var isEnd = false
    var data: [[String: Any]] = []
    
    init(baseURL: String, fetchSize: Int, streamStatus: Bool? = nil) {
        self.baseURL = baseURL
        limit = fetchSize
        self.streamStatus = streamStatus
        
        currentPage = 0
    }
    

    
    func fetch(_ fetchClosure: @escaping FetchClosure){
        
        var q = "?page=\(currentPage)&limit=\(limit)"
        if let streamStatus = streamStatus {
            if streamStatus {
                q = q + "&streamStatus=1"
            } else {
                q = q + "&streamStatus=0"
            }
        }
        
        Alamofire.request(baseURL + q, method: .get).responseJSON {[weak self] (response) in
            guard let strongSelf = self else { return }
            
            if (response.response?.statusCode)! > 200 {
                print(response.result.value)
            }
            
            print(response.result.value)
            
            strongSelf.data = response.result.value as! [[String : Any]]

            if strongSelf.data.count < strongSelf.limit {
                strongSelf.isEnd = true
            }
            
            fetchClosure(true, nil)
            
        }
    }

    func loadNextPage(nextPageClosure: @escaping NextPageClosure){
        currentPage += 1
        Alamofire.request(baseURL + "&limit=\(limit)&page=\(currentPage)", method: .get).responseJSON {[weak self] (response) in
            guard let strongSelf = self else { return }
            
            let results = response.result.value as! [[String : Any]]
            
            
            strongSelf.data.append(contentsOf: results)
            
            if strongSelf.data.count < strongSelf.limit {
                strongSelf.isEnd = true
            }
            
            var indexPaths: [NSIndexPath] = []
            for index in ((strongSelf.currentPage * strongSelf.limit) - 1)..<results.count {
                indexPaths.append(NSIndexPath(row: index, section: 0))
            }
            
            nextPageClosure(indexPaths, nil)
        }
    }
}
