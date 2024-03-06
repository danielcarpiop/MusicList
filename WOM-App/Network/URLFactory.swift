import Foundation

enum CountryCode: String {
    case US
    case CL
    case SE
}

struct URLFactory {
   func generateURL(with countryCode: CountryCode) -> URL {
        let urlString = String(format: "https://itunes.apple.com/%@/rss/topsongs/limit=10/json", countryCode.rawValue)
        guard let url = URL(string: urlString) else {
            fatalError("Error trying to construct the country code")
        }
        return url
    }
}
