import Foundation

enum CountryCode: String {
    case US
    case CL
    case SE
}

struct URLFactory {
    private let baseURL = "https://itunes.apple.com/"
    private let endpoint = "/rss/topsongs/limit=10/json"
    
    func generateURL(with countryCode: CountryCode) -> URL {
        let urlString = String(format: "\(baseURL)%@\(endpoint)", countryCode.rawValue)
        guard let url = URL(string: urlString) else {
            fatalError("Error trying to construct the country code")
        }
        return url
    }
}
