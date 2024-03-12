import Foundation
import Combine

enum RequestError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
}

protocol ArtistListService {
    func getList(countryCode: CountryCode) -> AnyPublisher<Model, RequestError>
}

final class ArtistListApi: ArtistListService {
    private let urlFactory = URLFactory()
    private let urlSession = URLSession.shared
    
    func getList(countryCode: CountryCode) -> AnyPublisher<Model, RequestError> {
        guard let url = urlFactory.generateURL(with: countryCode) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                RequestError.networkError(error)
            }
            .flatMap { data, response -> AnyPublisher<Model, RequestError> in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return Fail(error: RequestError.invalidResponse).eraseToAnyPublisher()
                }
                
                do {
                    let model = try JSONDecoder().decode(Model.self, from: data)
                    return Just(model)
                        .setFailureType(to: RequestError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: .invalidResponse).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
