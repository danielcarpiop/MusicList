import Foundation
import Combine

enum RequestError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
}

protocol ArtistListService {
    func getList(countryCode: CountryCode) -> AnyPublisher<Model, Error>
}

final class ArtistListApi: ArtistListService {
    private let urlFactory = URLFactory()
    private let urlSession = URLSession.shared
    
    func getList(countryCode: CountryCode) -> AnyPublisher<Model, Error> {
        guard let url = urlFactory.generateURL(with: countryCode) else {
            return Fail(error: RequestError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw RequestError.invalidResponse
                }
                return data
            }
            .decode(type: Model.self, decoder: JSONDecoder())
            .mapError { error in
                switch error {
                case is URLError:
                    return RequestError.networkError(error)
                default:
                    return error
                }
            }
            .eraseToAnyPublisher()
    }
}
