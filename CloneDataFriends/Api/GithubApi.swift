//
//  GithubApi.swift
//  CloneDataFriends
//
//  Created by gitaeklee on 2021/01/31.
//

import Foundation
import APIKit

final class GitHubApi {}

// MARK: -API struct & extension
extension GitHubApi {
    struct SearchRequest:GitHubRequest {

    
        let language:String
        let page:Int
        
        init(language:String = "Swift",page:Int){
            self.language = language
            self.page = page
        }
        
        let method:HTTPMethod = .get
        let path:String = "/search/repositories"
        
        var parameters: Any? {
            var params = [String:Any]()
            params["q"] = language
            params["sort"] = "stars"
            params["page"] = "\(page)"
            return params
        }
        
        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> [GitHubModel] {
            guard let data = object as? Data else {
                throw ResponseError.unexpectedObject(object)
            }
            let res = try JSONDecoder().decode(SearchRepositoriesResponse.self, from: data)
            return res.items
        }
    }
    
}
