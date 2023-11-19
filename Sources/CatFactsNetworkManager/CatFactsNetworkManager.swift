
import Foundation

final class CatFactsNetworkManager {
    private let baseURL = "https://catfact.ninja/"
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    func fetchFacts<T: Decodable>(limit: Int, completion: @escaping (Result<T, Error>) -> Void) {
        let urlStr = "\(baseURL)facts?limit=\(limit)"
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let catFactsResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(catFactsResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
