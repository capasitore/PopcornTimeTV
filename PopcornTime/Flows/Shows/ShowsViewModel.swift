//
//  ShowsViewModel.swift
//  PopcornTimetvOS SwiftUI
//
//  Created by Alexandru Tudose on 27.06.2021.
//  Copyright © 2021 PopcornTime. All rights reserved.
//

import SwiftUI
import PopcornKit

class ShowsViewModel: ObservableObject, ShowRatingsLoader {
    @Published var isLoading = false
    var page = 1
    @Published var hasNextPage = false
    @Published var currentFilter: ShowManager.Filters = .trending {
        didSet { reload() }
    }
    @Published var currentGenre = NetworkManager.Genres.all {
        didSet { reload() }
    }
    @Published var error: Error? = nil
    @Published var shows: [Show] = []
    var lastReloadDate: Date?
    
    func reload() {
        shows = []
        page = 1
        loadShows()
    }
    
    func loadShows() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        PopcornKit.loadShows(page, filterBy: currentFilter, genre: currentGenre) { [unowned self] (shows, error) in
            isLoading = false
//            print(shows, error)
//            print(shows!.toJSON())
            
            guard let shows = shows else {
                self.error = error
                return
            }
            
            if page == 1 {
                lastReloadDate = Date()
            }
            
            self.shows = (self.shows + shows).uniqued
            self.hasNextPage = !self.shows.isEmpty
            self.page += 1
        }
    }
    
    func appDidBecomeActive() {
        let _4Hours = 4 * 60 * 60.0
        if _4Hours < abs(lastReloadDate?.timeIntervalSinceNow ?? 0)  {
            self.reload()
        }
    }
}



extension Show {
    static func dummy() -> Self {
        var show = Show.init(JSON: showDetailsJSON)!
        show.actors = .init(JSONArray: showActorsJSON)
        show.crew = .init(JSONArray: showCrewJSON)
        show.related = dummiesFromJSON()
        show.episodes = .init(JSONArray: showEpisodesJSON)
        return show
    }
    
    static func dummiesFromJSON() -> [Show] {
        return .init(JSONArray: showJSON)
    }
}





let showDetailsJSON: [String: Any] = ["synopsis": "After stealing the Tesseract during the events of “Avengers: Endgame,” an alternate version of Loki is brought to the mysterious Time Variance Authority, a bureaucratic organization that exists outside of time and space and monitors the timeline. They give Loki a choice: face being erased from existence due to being a “time variant”or help fix the timeline and stop a greater threat.", "imdb_id": "tt9140554", "air_day": "", "tvdb_id": "362472", "rating": ["percentage": 87.0], "slug": "loki", "genres": ["action & adventure", "comedy", "drama", "sci-fi & fantasy"], "status": "Returning Series", "runtime": "52", "year": "2021", "air_time": "", "title": "Loki", "images": ["poster": "http://image.tmdb.org/t/p/w780/kEl2t3OhXc3Zb9FBh1AuYzRTgZp.jpg", "fanart": "http://image.tmdb.org/t/p/original/Afp8OhiO0Ajb3NPoCBvfu2pqaeO.jpg"]]

let showCrewJSON: [[String: Any]] = [["person": ["name": "Ian Shorr", "ids": ["imdb": "nm2135380", "tmdb": 82941]], "job": "Screenplay", "roleType": "writing"], ["job": "Screenstory", "roleType": "writing", "person": ["ids": ["tmdb": 1319500, "imdb": "nm2089442"], "name": "Todd Stein"]], ["person": ["ids": ["imdb": "nm0278475", "tmdb": 18265], "name": "Mauro Fiore"], "job": "Director of Photography", "roleType": "camera"], ["person": ["ids": ["imdb": "nm0119322", "tmdb": 3987], "name": "Conrad Buff IV"], "job": "Editor", "roleType": "unknown"], ["roleType": "production", "person": ["name": "Lorenzo Di Bonaventura", "ids": ["imdb": "nm0225146", "tmdb": 10952]], "job": "Producer"], ["person": ["name": "Mark Vahradian", "ids": ["tmdb": 24309, "imdb": "nm1680607"]], "roleType": "production", "job": "Producer"], ["person": ["ids": ["tmdb": 13240, "imdb": "nm0000242"], "name": "Mark Wahlberg"], "job": "Producer", "roleType": "production"], ["job": "Producer", "roleType": "production", "person": ["name": "Mark Huffam", "ids": ["imdb": "nm0400240", "tmdb": 8401]]], ["person": ["ids": ["tmdb": 183044, "imdb": "nm0506100"], "name": "Stephen Levinson"], "roleType": "production", "job": "Producer"], ["job": "Director", "roleType": "directing", "person": ["name": "Antoine Fuqua", "ids": ["tmdb": 20907, "imdb": "nm0298807"]]], ["job": "Executive Producer", "roleType": "production", "person": ["ids": ["imdb": "nm0298807", "tmdb": 20907], "name": "Antoine Fuqua"]]]

let showActorsJSON: [[String: Any]] = [["person": ["name": "Dylan O\'Brien", "ids": ["imdb": "nm3729721", "tmdb": 527393]], "character": "Heinrich Treadway"], ["person": ["ids": ["tmdb": 13240, "imdb": "nm0000242"], "name": "Mark Wahlberg"], "character": "Evan McCauley"], ["character": "Bathurst 1985", "person": ["ids": ["tmdb": 36669, "imdb": "nm1670029"], "name": "Rupert Friend"]], ["person": ["name": "Sophie Cookson", "ids": ["tmdb": 1282054, "imdb": "nm5824400"]], "character": "Nora Brightman"], ["person": ["name": "Chiwetel Ejiofor", "ids": ["imdb": "nm0252230", "tmdb": 5294]], "character": "Bathurst 2020"], ["person": ["name": "Toby Jones", "ids": ["imdb": "nm0429363", "tmdb": 13014]], "character": "Bryan Porter"], ["person": ["ids": ["tmdb": 1232690, "imdb": "nm4419317"], "name": "Liz Carr"], "character": "Garrick"], ["person": ["name": "Wallis Day", "ids": ["tmdb": 1715541, "imdb": "nm5363417"]], "character": "Shin"], ["person": ["ids": ["imdb": "nm3433735", "tmdb": 116264], "name": "Tom Hughes"], "character": "Abel"], ["person": ["ids": ["tmdb": 1399750, "imdb": "nm3664502"], "name": "Kae Alexander"], "character": "Trace"], ["character": "Artisan", "person": ["name": "Jason Mantzoukas", "ids": ["tmdb": 111683, "imdb": "nm1727621"]]], ["person": ["name": "Joana Ribeiro", "ids": ["tmdb": 1686493, "imdb": "nm4940278"]], "character": "Leona"], ["person": ["ids": ["tmdb": 3107735, "imdb": "nm10435035"], "name": "Lillia Langley"], "character": "Modern Day Girl"], ["person": ["ids": ["imdb": "nm5380206", "tmdb": 1503909], "name": "Raffiella Chapman"], "character": "Jinya"], ["character": "Kovic", "person": ["ids": ["tmdb": 238164, "imdb": "nm1778512"], "name": "Jóhannes Haukur Jóhannesson"]]]

let showRelatedJSON: [[String: Any]] = [["rating": ["percentage": 0.0], "year": "2021", "title": "Infinite", "synopsis": "A troubled young man haunted by memories of two past lives stumbles upon the centuries-old secret society of similar individuals and dares to join their ranks.", "certification": "PG-13", "genres": ["action", "adventure", "drama", "science fiction"], "runtime": "106", "imdb_id": "tt6654210", "images": ["poster": "http://image.tmdb.org/t/p/w780/niw2AKHz6XmwiRMLWaoyAOAti0G.jpg", "fanart": "http://image.tmdb.org/t/p/original/wjQXZTlFM3PVEUmKf1sUajjygqT.jpg"], "trailer": "http://www.youtube.com/watch?v=zI2qbr99H64"]]

let showJSON: [[String: Any]] =
    [["tvdb_id": "362472", "title": "Loki", "synopsis": "No summary available.", "imdb_id": "tt9140554", "rating": ["percentage": 87.0], "genres": [], "images": ["poster": "http://image.tmdb.org/t/p/w780/kEl2t3OhXc3Zb9FBh1AuYzRTgZp.jpg", "fanart": "http://image.tmdb.org/t/p/original/Afp8OhiO0Ajb3NPoCBvfu2pqaeO.jpg"], "slug": "loki", "year": "2021"], ["title": "The Blacklist", "rating": ["percentage": 74.0], "tvdb_id": "266189", "imdb_id": "tt2741602", "slug": "the-blacklist", "genres": [], "synopsis": "No summary available.", "images": ["poster": "http://image.tmdb.org/t/p/w780/htJzeRcYI2ewMm4PTrg98UMXShe.jpg", "fanart": "http://image.tmdb.org/t/p/original/zXpSJLcczUt6EfbdULZanguzy87.jpg"], "year": "2013"], ["synopsis": "No summary available.", "imdb_id": "tt3502248", "images": ["fanart": "http://image.tmdb.org/t/p/original/23S5oKZjlXehjNLEhMQuxjwbyuA.jpg", "poster": "http://image.tmdb.org/t/p/w780/fmBAmAyR6aMo1HAutV0oZ8Y7emb.jpg"], "slug": "bosch", "title": "Bosch", "genres": [], "year": "2015", "rating": ["percentage": 79.0], "tvdb_id": "277928"], ["images": ["fanart": "http://image.tmdb.org/t/p/original/iudXgng9XSdA0zB5eySmYIga9CY.jpg", "poster": "http://image.tmdb.org/t/p/w780/r8ODGmfNbZQlNhiJl2xQENE2jsk.jpg"], "slug": "van-helsing", "year": "2016", "title": "Van Helsing", "rating": ["percentage": 69.0], "tvdb_id": "308772", "imdb_id": "tt5197820", "synopsis": "No summary available.", "genres": []], ["rating": ["percentage": 87.0], "imdb_id": "tt2861424", "title": "Rick and Morty", "year": "2013", "slug": "rick-and-morty", "images": ["poster": "http://image.tmdb.org/t/p/w780/8kOWDBK6XlPUzckuHDo3wwVRFwt.jpg", "fanart": "http://image.tmdb.org/t/p/original/eV3XnUul4UfIivz3kxgeIozeo50.jpg"], "genres": [], "tvdb_id": "275274", "synopsis": "No summary available."], ["genres": [], "title": "Friends", "rating": ["percentage": 84.0], "imdb_id": "tt0108778", "slug": "friends", "year": "1994", "tvdb_id": "79168", "synopsis": "No summary available.", "images": ["poster": "http://image.tmdb.org/t/p/w780/f496cm9enuEsZkSPzCwnTESEK5s.jpg", "fanart": "http://image.tmdb.org/t/p/original/l0qVZIpXtIo7km9u5Yqh0nKPOr5.jpg"]], ["slug": "the-flash", "rating": ["percentage": 77.0], "tvdb_id": "279121", "synopsis": "No summary available.", "imdb_id": "tt3107288", "genres": [], "images": ["poster": "http://image.tmdb.org/t/p/w780/lJA2RCMfsWoskqlQhXPSLFQGXEJ.jpg", "fanart": "http://image.tmdb.org/t/p/original/z59kJfcElR9eHO9rJbWp4qWMuee.jpg"], "year": "2014", "title": "The Flash"], ["year": "2007", "imdb_id": "tt0898266", "title": "The Big Bang Theory", "rating": ["percentage": 77.0], "synopsis": "No summary available.", "tvdb_id": "80379", "images": ["poster": "http://image.tmdb.org/t/p/w780/ooBGRQBdbGzBxAVfExiO8r7kloA.jpg", "fanart": "http://image.tmdb.org/t/p/original/7RySzFeK3LPVMXcPtqfZnl6u4p1.jpg"], "slug": "the-big-bang-theory", "genres": []], ["genres": [], "synopsis": "No summary available.", "tvdb_id": "75978", "year": "1999", "title": "Family Guy", "images": ["poster": "http://image.tmdb.org/t/p/w780/eWWCRjBfLyePh2tfZdvNcIvKSJe.jpg", "fanart": "http://image.tmdb.org/t/p/original/eyO5b3b3wgfiyuIKQMAyekh40A2.jpg"], "imdb_id": "tt0182576", "rating": ["percentage": 70.0], "slug": "family-guy"], ["images": ["poster": "http://image.tmdb.org/t/p/w780/rBcLw5cgZSxdC3NbFJZOmLaF8Mu.jpg", "fanart": "http://image.tmdb.org/t/p/original/hNiGqLsiD30C194lci7VYDmciHD.jpg"], "imdb_id": "tt5834204", "tvdb_id": "321239", "rating": ["percentage": 81.0], "year": "2017", "synopsis": "No summary available.", "genres": [], "title": "The Handmaid\'s Tale", "slug": "the-handmaids-tale"], ["rating": ["percentage": 84.0], "title": "New Amsterdam", "year": "2018", "slug": "new-amsterdam", "imdb_id": "tt7817340", "tvdb_id": "349272", "synopsis": "No summary available.", "genres": [], "images": ["poster": "http://image.tmdb.org/t/p/w780/wKTAz8fkoXJoHqPpi4ArAUGDtco.jpg", "fanart": "http://image.tmdb.org/t/p/original/kXdfhKazlnRhnyc687DDdZJPaoJ.jpg"]], ["imdb_id": "tt11192306", "genres": [], "synopsis": "No summary available.", "slug": "superman--lois", "year": "2021", "images": ["poster": "http://image.tmdb.org/t/p/w780/vlv1gn98GqMnKHLSh0dNciqGfBl.jpg", "fanart": "http://image.tmdb.org/t/p/original/pPKiIJEEcV0E1hpVcWRXyp73ZpX.jpg"], "tvdb_id": "375655", "rating": ["percentage": 83.0], "title": "Superman & Lois"], ["synopsis": "No summary available.", "images": ["fanart": "http://image.tmdb.org/t/p/original/eSVvx8xys2NuFhl8fevXt41wX7v.jpg", "poster": "http://image.tmdb.org/t/p/w780/7OFxU0bBO0HDL4klXmM1ahJPbv8.jpg"], "slug": "clarice", "imdb_id": "tt2177268", "genres": [], "rating": ["percentage": 75.0], "year": "2021", "tvdb_id": "376395", "title": "Clarice"], ["rating": ["percentage": 71.0], "imdb_id": "tt1433870", "slug": "masterchef-australia", "genres": [], "images": ["fanart": "http://image.tmdb.org/t/p/original/hvWbem7FXSKTrzZ8XRaofjHxZoc.jpg", "poster": "http://image.tmdb.org/t/p/w780/m5akdtbWznF8KpOewKyKw0C36s1.jpg"], "synopsis": "No summary available.", "year": "2009", "tvdb_id": "92091", "title": "MasterChef Australia"], ["rating": ["percentage": 0.0], "slug": "clarksons-farm", "tvdb_id": "378165", "title": "Clarkson\'s Farm", "genres": [], "year": "2021", "imdb_id": "tt10541088", "synopsis": "No summary available.", "images": ["fanart": "http://image.tmdb.org/t/p/original/mScfCQ7byPNpd3NCob1XvwQZR8k.jpg", "poster": "http://image.tmdb.org/t/p/w780/3lyP0ZH3BDeMuVc7EMaSMm8JiVe.jpg"]], ["rating": ["percentage": 95.0], "year": "2021", "imdb_id": "tt12708542", "title": "Star Wars: The Bad Batch", "images": ["poster": "http://image.tmdb.org/t/p/w780/WjQmEWFrOf98nT5aEfUfVYz9N2.jpg", "fanart": "http://image.tmdb.org/t/p/original/sjxtIUCWR74yPPcZFfTsToepfWm.jpg"], "slug": "star-wars-the-bad-batch", "synopsis": "No summary available.", "genres": [], "tvdb_id": "385376"], ["tvdb_id": "71663", "slug": "the-simpsons", "synopsis": "No summary available.", "title": "The Simpsons", "images": ["poster": "http://image.tmdb.org/t/p/w780/2IWouZK4gkgHhJa3oyYuSWfSqbG.jpg", "fanart": "http://image.tmdb.org/t/p/original/hpU2cHC9tk90hswCFEpf5AtbqoL.jpg"], "rating": ["percentage": 78.0], "imdb_id": "tt0096697", "genres": [], "year": "1989"], ["tvdb_id": "254203", "rating": ["percentage": 63.0], "images": ["fanart": "http://image.tmdb.org/t/p/original/fxGvJ8o6oCQVwxb96D2NuOgNAkU.jpg", "poster": "http://image.tmdb.org/t/p/w780/A8mKQA5EfAz78govyLuBnrxkhWD.jpg"], "year": "2012", "slug": "bering-sea-gold", "synopsis": "No summary available.", "imdb_id": "tt2182427", "title": "Bering Sea Gold", "genres": []], ["title": "Game of Thrones", "synopsis": "No summary available.", "rating": ["percentage": 84.0], "imdb_id": "tt0944947", "slug": "game-of-thrones", "tvdb_id": "121361", "genres": [], "year": "2011", "images": ["poster": "http://image.tmdb.org/t/p/w780/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg", "fanart": "http://image.tmdb.org/t/p/original/suopoADq0k8YZr4dQXcU6pToj6s.jpg"]], ["synopsis": "No summary available.", "imdb_id": "tt4052886", "genres": [], "images": ["poster": "http://image.tmdb.org/t/p/w780/4EYPN5mVIhKLfxGruy7Dy41dTVn.jpg", "fanart": "http://image.tmdb.org/t/p/original/ta5oblpMlEcIPIS2YGcq9XEkWK2.jpg"], "tvdb_id": "295685", "rating": ["percentage": 85.0], "slug": "lucifer", "title": "Lucifer", "year": "2016"], ["imdb_id": "tt0397306", "year": "2005", "tvdb_id": "73141", "synopsis": "No summary available.", "genres": [], "images": ["poster": "http://image.tmdb.org/t/p/w780/aC1q422YhQR7k82GB8gW4KoD91p.jpg", "fanart": "http://image.tmdb.org/t/p/original/vJO8LeIDFXlvgUgGBAvyfK6BywD.jpg"], "rating": ["percentage": 67.0], "title": "American Dad!", "slug": "american-dad"], ["genres": [], "synopsis": "No summary available.", "imdb_id": "tt8879940", "tvdb_id": "362829", "slug": "mythic-quest-ravens-banquet", "year": "2020", "images": ["poster": "http://image.tmdb.org/t/p/w780/lEPXDqTntfWGWoU4E0xtxhFn2Wj.jpg", "fanart": "http://image.tmdb.org/t/p/original/3rTC68FlKeFsTZ3P0oC3S727Xqd.jpg"], "title": "Mythic Quest: Raven\'s Banquet", "rating": ["percentage": 72.0]], ["imdb_id": "tt2467372", "slug": "brooklyn-nine-nine", "title": "Brooklyn Nine-Nine", "synopsis": "No summary available.", "year": "2013", "genres": [], "tvdb_id": "269586", "images": ["fanart": "http://image.tmdb.org/t/p/original/ncC9ZgZuKOdaVm7yXinUn26Qyok.jpg", "poster": "http://image.tmdb.org/t/p/w780/dzj0oLZWe3qMgK4jlgdKWPVxxIx.jpg"], "rating": ["percentage": 82.0]], ["images": ["poster": "http://image.tmdb.org/t/p/w780/6tfT03sGp9k4c0J3dypjrI8TSAI.jpg", "fanart": "http://image.tmdb.org/t/p/original/mZjZgY6ObiKtVuKVDrnS9VnuNlE.jpg"], "rating": ["percentage": 86.0], "title": "The Good Doctor", "imdb_id": "tt6470478", "year": "2017", "tvdb_id": "328634", "synopsis": "No summary available.", "genres": [], "slug": "the-good-doctor"], ["synopsis": "No summary available.", "genres": [], "rating": ["percentage": 77.0], "slug": "manifest", "images": ["poster": "http://image.tmdb.org/t/p/w780/1xeiUxShzNn8TNdMqy3Hvo9o2R.jpg", "fanart": "http://image.tmdb.org/t/p/original/3ib0uov9Qq9JtTIEGL39irTa3vZ.jpg"], "tvdb_id": "349271", "title": "Manifest", "year": "2018", "imdb_id": "tt8421350"], ["slug": "alone", "tvdb_id": "295936", "imdb_id": "tt4803766", "genres": [], "synopsis": "No summary available.", "images": ["fanart": "http://image.tmdb.org/t/p/original/wcX3J5juFUMXhivZ9rHB7NgwLYa.jpg", "poster": "http://image.tmdb.org/t/p/w780/c2NlSxn82m6q2Z3NXjVuGmbzG2m.jpg"], "title": "Alone", "rating": ["percentage": 67.0], "year": "2015"], ["year": "2021", "imdb_id": "tt10155688", "title": "Mare of Easttown", "genres": [], "images": ["fanart": "http://image.tmdb.org/t/p/original/whWHhs6p1YVMKDsH9yuvF2KR64d.jpg", "poster": "http://image.tmdb.org/t/p/w780/78aK4Msbr22A5PGa6PZV0pAvdwf.jpg"], "rating": ["percentage": 100.0], "tvdb_id": "370112", "slug": "mare-of-easttown", "synopsis": "No summary available."], ["slug": "dcs-legends-of-tomorrow", "year": "2016", "tvdb_id": "295760", "images": ["poster": "http://image.tmdb.org/t/p/w780/yJ3xE11IDIe29LJsSbhzwt5Oxtd.jpg", "fanart": "http://image.tmdb.org/t/p/original/be8fOACxsVyaX6lZLlQOWNqF0g2.jpg"], "title": "DC\'s Legends of Tomorrow", "imdb_id": "tt4532368", "synopsis": "No summary available.", "rating": ["percentage": 72.0], "genres": []], ["synopsis": "No summary available.", "tvdb_id": "75897", "year": "1997", "genres": [], "slug": "south-park", "imdb_id": "tt0121955", "rating": ["percentage": 82.0], "images": ["fanart": "http://image.tmdb.org/t/p/original/7uihCghJiyYFTXSh1BOPdHQN8xK.jpg", "poster": "http://image.tmdb.org/t/p/w780/iiCY2QIGSnmtVkIdjkKAfwDs0KF.jpg"], "title": "South Park"], ["year": "2019", "synopsis": "No summary available.", "images": ["poster": "http://image.tmdb.org/t/p/w780/pDZ1oMOZ7N1UtRBjRrYwzPSCgGY.jpg", "fanart": "http://image.tmdb.org/t/p/original/kri75jPdoOdaiZJ5p7AU4qEHTuL.jpg"], "imdb_id": "tt9686194", "slug": "war-of-the-worlds", "tvdb_id": "370139", "genres": [], "title": "War of the Worlds", "rating": ["percentage": 74.0]], ["images": ["poster": "http://image.tmdb.org/t/p/w780/4UjiPdFKJGJYdxwRs2Rzg7EmWqr.jpg", "fanart": "http://image.tmdb.org/t/p/original/58PON1OrnBiX6CqEHgeWKVwrCn6.jpg"], "synopsis": "No summary available.", "rating": ["percentage": 76.0], "year": "2015", "imdb_id": "tt3743822", "slug": "fear-the-walking-dead", "title": "Fear the Walking Dead", "genres": [], "tvdb_id": "290853"], ["rating": ["percentage": 82.0], "synopsis": "No summary available.", "year": "2005", "tvdb_id": "75805", "images": ["poster": "http://image.tmdb.org/t/p/w780/xX3vAWdCb828T48HM9OvvD0p4PC.jpg", "fanart": "http://image.tmdb.org/t/p/original/w6t8mFlyB6JKcEGm3cojvylIc5O.jpg"], "slug": "its-always-sunny-in-philadelphia", "title": "It\'s Always Sunny in Philadelphia", "genres": [], "imdb_id": "tt0472954"], ["year": "2017", "genres": [], "images": ["poster": "http://image.tmdb.org/t/p/w780/eNOeNrNEXMnxg1YZCKogBaEzi20.jpg", "fanart": "http://image.tmdb.org/t/p/original/oLeIp3ZkPXBAehPwgkF8kKFlbFf.jpg"], "rating": ["percentage": 74.0], "synopsis": "No summary available.", "tvdb_id": "320766", "title": "The Good Fight", "slug": "the-good-fight", "imdb_id": "tt5853176"], ["rating": ["percentage": 75.0], "tvdb_id": "355837", "synopsis": "No summary available.", "imdb_id": "tt12809988", "genres": [], "slug": "sweet-tooth", "images": ["poster": "http://image.tmdb.org/t/p/w780/rgMfhcrVZjuy5b7Pn0KzCRCEnMX.jpg", "fanart": "http://image.tmdb.org/t/p/original/esvxytagsQdRIZtpsa8mXBCfZJq.jpg"], "title": "Sweet Tooth", "year": "2021"], ["year": "2008", "slug": "breaking-bad", "images": ["poster": "http://image.tmdb.org/t/p/w780/ggFHVNu6YYI5L9pCfOacjizRGt.jpg", "fanart": "http://image.tmdb.org/t/p/original/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg"], "title": "Breaking Bad", "rating": ["percentage": 87.0], "synopsis": "No summary available.", "tvdb_id": "81189", "genres": [], "imdb_id": "tt0903747"], ["tvdb_id": "75760", "slug": "how-i-met-your-mother", "imdb_id": "tt0460649", "images": ["poster": "http://image.tmdb.org/t/p/w780/dvxSvr6OmYGvvt8Z1VdBlPfL1Lf.jpg", "fanart": "http://image.tmdb.org/t/p/original/5BMwFwNzSidVYArn561acqtktxv.jpg"], "rating": ["percentage": 81.0], "year": "2005", "title": "How I Met Your Mother", "synopsis": "No summary available.", "genres": []], ["title": "Dexter", "genres": [], "year": "2006", "tvdb_id": "79349", "imdb_id": "tt0773262", "slug": "dexter", "synopsis": "No summary available.", "images": ["poster": "http://image.tmdb.org/t/p/w780/p4rx3FW14Ayx1dLHJQBqDGw9YiX.jpg", "fanart": "http://image.tmdb.org/t/p/original/ecT6wR78bXHLbqAwtLNMDVirdit.jpg"], "rating": ["percentage": 82.0]], ["synopsis": "No summary available.", "images": ["poster": "http://image.tmdb.org/t/p/w780/9akij7PqZ1g6zl42DQQTtL9CTSb.jpg", "fanart": "http://image.tmdb.org/t/p/original/5s9XHTB9SLPdg3mNU6BlSLnZ9Qq.jpg"], "tvdb_id": "161511", "slug": "shameless", "title": "Shameless", "year": "2011", "rating": ["percentage": 80.0], "imdb_id": "tt1586680", "genres": []], ["imdb_id": "tt0118480", "year": "1997", "genres": [], "synopsis": "No summary available.", "title": "Stargate SG-1", "tvdb_id": "72449", "images": ["poster": "http://image.tmdb.org/t/p/w780/9Jegw0yle4x8jlmLNZon37Os27h.jpg", "fanart": "http://image.tmdb.org/t/p/original/li9SZBpVzJz81ouqifVuH5C7Nod.jpg"], "rating": ["percentage": 82.0], "slug": "stargate-sg-1"], ["slug": "legacies", "tvdb_id": "349309", "images": ["poster": "http://image.tmdb.org/t/p/w780/qTZIgXrBKURBK1KrsT7fe3qwtl9.jpg", "fanart": "http://image.tmdb.org/t/p/original/fRYwdeNjMqC30EhofPx5PlDpdun.jpg"], "title": "Legacies", "synopsis": "No summary available.", "genres": [], "year": "2018", "imdb_id": "tt8103070", "rating": ["percentage": 86.0]], ["synopsis": "No summary available.", "year": "2017", "imdb_id": "tt6128300", "rating": ["percentage": 82.0], "title": "Dynasty", "genres": [], "images": ["poster": "http://image.tmdb.org/t/p/w780/3EcGm1G99rzJCDsn6cQTGJrslzL.jpg", "fanart": "http://image.tmdb.org/t/p/original/wG6mZsEvglT73RJl5aDyv22PPub.jpg"], "slug": "dynasty", "tvdb_id": "328749"], ["genres": [], "title": "Walker", "slug": "walker", "tvdb_id": "371768", "images": ["poster": "http://image.tmdb.org/t/p/w780/y4VHQbbY1UcAjHN7UTGu0MGyVl2.jpg", "fanart": "http://image.tmdb.org/t/p/original/s2IXx944vnZUtAxC2nPydOfqakh.jpg"], "rating": ["percentage": 68.0], "year": "2021", "imdb_id": "tt11006642", "synopsis": "No summary available."], ["rating": ["percentage": 76.0], "slug": "mr-inbetween", "synopsis": "No summary available.", "year": "2018", "imdb_id": "tt7472896", "genres": [], "images": ["poster": "http://image.tmdb.org/t/p/w780/4e1W3K0EK9Nxet61zicOAK2bIqf.jpg", "fanart": "http://image.tmdb.org/t/p/original/2INMEKxee4z0mVYpHCS4AdPxgOb.jpg"], "title": "Mr Inbetween", "tvdb_id": "349743"], ["tvdb_id": "280619", "genres": [], "images": ["poster": "http://image.tmdb.org/t/p/w780/5vQlVWkIMPhZ88OWchJsgwGEK9.jpg", "fanart": "http://image.tmdb.org/t/p/original/uUwnClwdMA12bpHgeKgkQrbu5Oe.jpg"], "imdb_id": "tt3230854", "slug": "the-expanse", "year": "2015", "synopsis": "No summary available.", "rating": ["percentage": 79.0], "title": "The Expanse"], ["synopsis": "No summary available.", "genres": [], "images": ["fanart": "http://image.tmdb.org/t/p/original/80BRASQnT9KT7BkFeEI0EdeRIF3.jpg", "poster": "http://image.tmdb.org/t/p/w780/gHUCCMy1vvj58tzE3dZqeC9SXus.jpg"], "slug": "marvels-agents-of-shield", "year": "2013", "title": "Marvel\'s Agents of S.H.I.E.L.D.", "imdb_id": "tt2364582", "tvdb_id": "263365", "rating": ["percentage": 74.0]], ["genres": [], "title": "The Rookie", "slug": "the-rookie", "imdb_id": "tt7587890", "rating": ["percentage": 80.0], "synopsis": "No summary available.", "images": ["poster": "http://image.tmdb.org/t/p/w780/6hChiX0vIjWY4y2kz1WndHVMsDu.jpg", "fanart": "http://image.tmdb.org/t/p/original/Aof7R1if9jKhHCk6M7UGyEQWQSk.jpg"], "year": "2018", "tvdb_id": "350665"], ["genres": [], "images": ["fanart": "http://image.tmdb.org/t/p/original/ucyQMoSTH5FkCcQl4G4rLMtRSsJ.jpg", "poster": "http://image.tmdb.org/t/p/w780/5BD0kiTGnDxONqdrsswTewnk6WH.jpg"], "title": "The X-Files", "synopsis": "No summary available.", "tvdb_id": "77398", "year": "1993", "rating": ["percentage": 83.0], "slug": "the-x-files", "imdb_id": "tt0106179"], ["rating": ["percentage": 61.0], "images": ["poster": "http://image.tmdb.org/t/p/w780/c3EurMWJu1hXKUeJVvLIoJaN26j.jpg", "fanart": "http://image.tmdb.org/t/p/original/pdyjTfPDzd5mZ1qJnFbaXVdIIS6.jpg"], "imdb_id": "tt0350448", "year": "2003", "tvdb_id": "72231", "slug": "real-time-with-bill-maher", "synopsis": "No summary available.", "genres": [], "title": "Real Time with Bill Maher"], ["synopsis": "No summary available.", "title": "Bones", "tvdb_id": "75682", "year": "2005", "rating": ["percentage": 83.0], "imdb_id": "tt0460627", "genres": [], "slug": "bones", "images": ["poster": "http://image.tmdb.org/t/p/w780/eyTu5c8LniVciRZIOSHTvvkkgJa.jpg", "fanart": "http://image.tmdb.org/t/p/original/uwbue4X5f3r1b4z19EP6lSlRED6.jpg"]], ["year": "2012", "genres": [], "slug": "rupauls-drag-race-all-stars", "synopsis": "No summary available.", "rating": ["percentage": 85.0], "imdb_id": "tt2301351", "images": ["poster": "http://image.tmdb.org/t/p/w780/lYrCRjc4pDJL9oHNLux0KEyqATE.jpg", "fanart": "http://image.tmdb.org/t/p/original/eaCHkWtW2bbOmTI3IhD0vi0hp98.jpg"], "tvdb_id": "263380", "title": "RuPaul\'s Drag Race All Stars"]]


var showEpisodesJSON: [[String: Any]] = [["overview": "After stealing the Tesseract in \"Avengers: Endgame,\" Loki lands before the Time Variance Authority.", "tvdb_id": 8234217, "title": "Glorious Purpose", "episode": 1, "season": 1, "first_aired": 1623196800.0, "show": ["genres": ["action & adventure", "comedy", "drama", "sci-fi & fantasy"], "title": "Loki", "rating": ["percentage": 87.0], "air_time": "", "images": ["poster": "http://image.tmdb.org/t/p/w780/kEl2t3OhXc3Zb9FBh1AuYzRTgZp.jpg", "fanart": "http://image.tmdb.org/t/p/original/Afp8OhiO0Ajb3NPoCBvfu2pqaeO.jpg"], "tvdb_id": "362472", "runtime": "52", "synopsis": "After stealing the Tesseract during the events of “Avengers: Endgame,” an alternate version of Loki is brought to the mysterious Time Variance Authority, a bureaucratic organization that exists outside of time and space and monitors the timeline. They give Loki a choice: face being erased from existence due to being a “time variant”or help fix the timeline and stop a greater threat.", "status": "Returning Series", "slug": "loki", "ids": ["tmdb": 84958], "air_day": "", "imdb_id": "tt9140554", "year": "2021"]], ["first_aired": 1623801600.0, "episode": 2, "show": ["air_time": "", "runtime": "52", "slug": "loki", "title": "Loki", "tvdb_id": "362472", "imdb_id": "tt9140554", "year": "2021", "status": "Returning Series", "images": ["fanart": "http://image.tmdb.org/t/p/original/Afp8OhiO0Ajb3NPoCBvfu2pqaeO.jpg", "poster": "http://image.tmdb.org/t/p/w780/kEl2t3OhXc3Zb9FBh1AuYzRTgZp.jpg"], "genres": ["action & adventure", "comedy", "drama", "sci-fi & fantasy"], "air_day": "", "synopsis": "After stealing the Tesseract during the events of “Avengers: Endgame,” an alternate version of Loki is brought to the mysterious Time Variance Authority, a bureaucratic organization that exists outside of time and space and monitors the timeline. They give Loki a choice: face being erased from existence due to being a “time variant”or help fix the timeline and stop a greater threat.", "rating": ["percentage": 87.0], "ids": ["tmdb": 84958]], "overview": "Mobius puts Loki to work, but not everyone at TVA is thrilled about the God of Mischief\'s presence.", "tvdb_id": 8452516, "title": "The Variant", "season": 1], ["tvdb_id": 8452517, "title": "Lamentis", "first_aired": 1624406400.0, "episode": 3, "season": 1, "show": ["images": ["poster": "http://image.tmdb.org/t/p/w780/kEl2t3OhXc3Zb9FBh1AuYzRTgZp.jpg", "fanart": "http://image.tmdb.org/t/p/original/Afp8OhiO0Ajb3NPoCBvfu2pqaeO.jpg"], "slug": "loki", "runtime": "52", "synopsis": "After stealing the Tesseract during the events of “Avengers: Endgame,” an alternate version of Loki is brought to the mysterious Time Variance Authority, a bureaucratic organization that exists outside of time and space and monitors the timeline. They give Loki a choice: face being erased from existence due to being a “time variant”or help fix the timeline and stop a greater threat.", "genres": ["action & adventure", "comedy", "drama", "sci-fi & fantasy"], "status": "Returning Series", "air_day": "", "imdb_id": "tt9140554", "year": "2021", "title": "Loki", "ids": ["tmdb": 84958], "rating": ["percentage": 87.0], "tvdb_id": "362472", "air_time": ""], "overview": "Loki finds out The Variant\'s plans, but he has his own that will forever alter both their destinies."], ["first_aired": 1625011200.0, "show": ["tvdb_id": "362472", "title": "Loki", "slug": "loki", "year": "2021", "status": "Returning Series", "runtime": "52", "air_day": "", "ids": ["tmdb": 84958], "genres": ["action & adventure", "comedy", "drama", "sci-fi & fantasy"], "imdb_id": "tt9140554", "rating": ["percentage": 87.0], "synopsis": "After stealing the Tesseract during the events of “Avengers: Endgame,” an alternate version of Loki is brought to the mysterious Time Variance Authority, a bureaucratic organization that exists outside of time and space and monitors the timeline. They give Loki a choice: face being erased from existence due to being a “time variant”or help fix the timeline and stop a greater threat.", "images": ["fanart": "http://image.tmdb.org/t/p/original/Afp8OhiO0Ajb3NPoCBvfu2pqaeO.jpg", "poster": "http://image.tmdb.org/t/p/w780/kEl2t3OhXc3Zb9FBh1AuYzRTgZp.jpg"], "air_time": ""], "episode": 4, "tvdb_id": 8452518, "overview": "Frayed nerves and paranoia infiltrate the TVA as Mobius and Hunter B-15 search for Loki and Sylvie.", "title": "The Nexus Event", "season": 1]]
