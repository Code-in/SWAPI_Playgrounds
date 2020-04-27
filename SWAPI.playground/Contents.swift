import UIKit

struct Person: Decodable {
    let name: String
    /*let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let homeworld: String*/
    let films: [URL]
    /*let species: [String]
    let vehicles: [String]
    let starships: [String]
    let created: String
    let edited: String
    let url: String*/
}

struct Film: Decodable {
    let title: String
    let episode_id: Int
    let opening_crawl: String
    let director: String
    let producer: String
    let release_date: String
    let characters: [String]
    let planets: [String]
    let starships: [String]
    let vehicles: [String]
    let species: [String]
    let created: String
    let edited: String
    let url: String
}

class SwapiService {
    static let baseURL = URL(string: "https://swapi.dev/")
    static let apiEndpoint = "api"
    static let personItem = "people"
    static let filmItem = "films"
    
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {

        guard let baseURL = self.baseURL else { return completion(nil)}
        
        let apiURL = baseURL.appendingPathComponent(apiEndpoint)
        
        let partialApiURL = apiURL.appendingPathComponent(personItem)
        
        let finalURL = partialApiURL.appendingPathComponent("1")
        
        print("finalURL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { ( data, _, error) in
            if let error = error {
                print("URLSession error: \(error.localizedDescription)")
                return completion(nil)
            }
            guard let returnData = data else { return completion(nil) }
            print("Decoding error: \(returnData)")
            do {
                let personFilmInfo = try JSONDecoder().decode(Person.self, from: returnData)
                print("got here")
                let person = personFilmInfo
                return completion(person)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        } .resume()
    }
    
    static func fetchFilm(url: URL,  completion: @escaping (Film?) -> Void) {

        //guard let finalURL = url else { return completion(nil)}
        
        print("finalURL: \(url)")
        
        URLSession.shared.dataTask(with: url) { ( data, _, error) in
            if let error = error {
                print("URLSession error: \(error.localizedDescription)")
                return completion(nil)
            }
            guard let returnData = data else { return completion(nil) }
            print("Decoding error: \(returnData)")
            do {
                let personFilmInfo = try JSONDecoder().decode(Film.self, from: returnData)
                print("got here")
                let person = personFilmInfo
                return completion(person)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        } .resume()
    }
    
    
} // EoC


var personObj: Person

SwapiService.fetchPerson(id: 1) { (person) in
    guard let person = person else { return }
    print("Person: \(person)")
    
    for url in person.films {
        SwapiService.fetchFilm(url: url) { (film) in
            guard let film = film else { return }
            print("Film: \(film)")
        }
    }

}


