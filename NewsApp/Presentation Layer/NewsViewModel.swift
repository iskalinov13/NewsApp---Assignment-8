//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by FIskalinov on 14.11.2024.
//

import Foundation

final class NewsViewModel {
    // MARK: Properties
    private let newsService: NewsService
    private(set) var news: [New] = []
    
    // MARK: Callbacks
    var didLoadNews: (([New]) -> Void)?
    
    // MARK: Init
    init(newsService: NewsService) {
        self.newsService = newsService
    }
    
    func getTopHeadLines() {
        newsService.getTopHeadLines(
            success: { [weak self] news in
                self?.news = news
                self?.didLoadNews?(news)
            },
            failure: { error in
                print(error.localizedDescription.description)
            }
        )
    }
}
