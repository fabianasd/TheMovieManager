//
//  Movie.swift
//  TheMovieManager
//
//  Created by Fabiana Petrovick on 18/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation
//filme é outro trecho em conformidade com o protocolo codificavel
struct Movie: Codable, Equatable {
    
    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
    
    var releaseYear: String {
        return String(releaseDate.prefix(4))
    }
//havia muitas propriedades, bem como uma enumeracao de chaves de codificacao para cada uma
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
}
