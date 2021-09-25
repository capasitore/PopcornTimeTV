//
//  MovieView.swift
//  PopcornTimetvOS SwiftUI
//
//  Created by Alexandru Tudose on 19.06.2021.
//  Copyright © 2021 PopcornTime. All rights reserved.
//

import SwiftUI
import Kingfisher
import PopcornKit

struct MovieView: View {
    struct Theme {
        let fontSize: CGFloat = value(tvOS: 28, macOS: 16)
    }
    static let theme = Theme()
    
    var movie: Movie
    var lineLimit = 1
    var ratingsLoader: MovieRatingsLoader?
    @Environment(\.isFocused) var focused: Bool
    
    var body: some View {
        VStack {
            KFImage(URL(string: movie.smallCoverImage ?? ""))
                .resizable()
                .loadImmediately()
                .placeholder {
                    Image("Movie Placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .aspectRatio(contentMode: .fit)
                .overlay(alignment: .topTrailing) {
                    if movie.isWatched {
                        Image("Watched Indicator")
                    }
                }
                .overlay(alignment: .bottom) {
                    if focused {
                        RatingsOverlayView(ratings: movie.ratings)
                            .transition(.move(edge: .bottom))
                    }
                }
                .cornerRadius(10)
                .shadow(radius: 5)
//                .padding(.bottom, 5)
            Text(movie.title)
                .font(.system(size: MovieView.theme.fontSize, weight: .medium))
//                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(lineLimit)
                .shadow(color: .init(white: 0, opacity: 0.6), radius: 2, x: 0, y: 1)
                .padding(0)
                .zIndex(10)
        }
        .onAppear {
            ratingsLoader?.loadRatingIfMissing(movie: movie)
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(movie: Movie.dummy())
            .background(Color.red)
            .frame(width: 250, height: 460, alignment: .center)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        
//        MovieView(movie: Movie.dummy(ratings: .init(awards: nil, imdbRating: "24", metascore: "50", rottenTomatoes: "20")))
//            .background(Color.red)
//            .frame(width: 250, height: 460, alignment: .center)
//            .previewLayout(.sizeThatFits)
//            .preferredColorScheme(.dark)
//            .previewDisplayName("Ratings")
    }
}
