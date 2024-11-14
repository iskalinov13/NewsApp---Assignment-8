//
//  New.swift
//  NewsApp
//
//  Created by FIskalinov on 14.11.2024.
//

import Foundation

struct NewsWrapper: Codable {
    let status: String
    let totalResults: Int
    let articles: [New]
}

// MARK: - Article
struct New: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
