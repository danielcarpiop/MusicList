import Foundation

enum RequestError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
}

protocol ArtistListService {
    func getList(countryCode: CountryCode, completion: @escaping (Result<Model, Error>) -> Void)
}

final class ArtistListApi: ArtistListService {
    private let urlFactory = URLFactory()
    private let urlSession = URLSession.shared
    
    func getList(countryCode: CountryCode, completion: @escaping (Result<Model, Error>) -> Void) {
        let url = urlFactory.generateURL(with: countryCode)
        
        urlSession.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(RequestError.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(RequestError.invalidResponse))
                return
            }
            
            guard let data else {
                completion(.failure(RequestError.invalidResponse))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
