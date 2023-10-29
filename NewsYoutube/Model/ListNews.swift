//
//  ListNews.swift
//  NewsYoutube
//
//  Created by anca dev on 20/10/23.
//

import Foundation

struct ListNews: Codable {
    let data: Data
}

struct Data: Codable {
    let posts: [Posts]
}

struct Posts: Codable {
    let title: String
    let thumbnail: String
}
