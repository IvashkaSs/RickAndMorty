import UIKit

class HeroController {
    static let shared = HeroController()
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    
    let baseURL = URL(string: "https://rickandmortyapi.com/api")!
    
    func fetchHeroes(queryItems: [String: String]? = nil, completion: @escaping (Result<HeroResponse, Error>) -> Void) {
        let baseCharactersURL = baseURL.appendingPathComponent("character")
        var components = URLComponents(url: baseCharactersURL, resolvingAgainstBaseURL: true)!
        
        if let queryItems = queryItems {
            let queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
            components.queryItems = queryItems
        }
        
        let charactersURL = components.url!
        
        let task = URLSession.shared.dataTask(with: charactersURL) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let heroResponse = try decoder.decode(HeroResponse.self, from: data)
                    
                    completion(.success(heroResponse))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            } else if let error = error {
                print(error)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping(UIImage?) -> Void) {
        if let imageFromCache = HeroController.imageCache.object(forKey: url as AnyObject) as? UIImage {
            completion(imageFromCache)
            return
        }
       
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                HeroController.imageCache.setObject(image, forKey: url as AnyObject)
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}
