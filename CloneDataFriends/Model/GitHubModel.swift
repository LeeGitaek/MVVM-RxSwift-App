//
//  GitHubModel.swift
//  CloneDataFriends
//
//  Created by gitaeklee on 2021/01/31.
//

import Foundation


// MARK: -THEORY

// Decodable : 자신을 외부표현(external representation)에서 디코딩 할 수 있는 타입
// Encodable : 자신을 외부표현(external representation)으로 인코딩 할 수 있는 타입
// Codable   : Decodable과 Encodable프로토콜을 준수하는 타입(프로토콜)이다

// MARK: -CODE

struct GitHubModel: Decodable {
    let id:Int
    let fullName:String
    let description:String
    let stargazersCount: Int
    let url: URL
    
    private enum CodingKeys:String,CodingKey {
        case id
        case fullName = "full_name"
        case description
        case stargazersCount = "stargazers_count"
        case url = "html_url"
    }
}

struct SearchRepositoriesResponse:Decodable {
    let items:[GitHubModel]
}
