//
//  NASAAPIManager.swift
//  NASAM
//
//  Created by alumno on 07/11/24.
//
import Foundation

class NASAAPIManager {
    let apiKey = "XYmE8LeYWHJpjqC5s4oTMf9SNbBwf0oa08hJdLqf"
    let baseURL = "https://images-api.nasa.gov/search"
    
    func fetchImages(for query: String, completion: @escaping (Result<[NASAImage], Error>) -> Void) {
        let queryURL = "\(baseURL)?q=\(query)&media_type=image"
        
        guard let url = URL(string: queryURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(NASAImageResponse.self, from: data)
                completion(.success(decodedResponse.collection.items))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    func fetchFact(completion: @escaping (Result<Fact, Error>) -> Void) {
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
                  completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
                  return
              }
              
              URLSession.shared.dataTask(with: url) { data, response, error in
                  if let error = error {
                      completion(.failure(error))
                      return
                  }
                  
                  guard let data = data else {
                      completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Datos inválidos"])))
                      return
                  }
                  
                  do {
                      let fact = try JSONDecoder().decode(Fact.self, from: data)
                      completion(.success(fact))
                  } catch {
                      completion(.failure(error))
                  }
                  print("Fetching URL: \(urlString)")
              }.resume()
    }


}

struct NASAImageResponse: Codable {
    let collection: NASAImageCollection
}

struct NASAImageCollection: Codable {
    let items: [NASAImage]
}

struct NASAImage: Codable {
    let links: [NASAImageLink]?
    let data: [NASAImageData]
}

struct NASAImageLink: Codable {
    let href: String
}

struct NASAImageData: Codable {
    let title: String
    let description: String?
}
struct Fact: Codable {
    let title: String
    let date: String
    let explanation: String
    let url: String?
}




