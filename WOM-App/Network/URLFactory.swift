import Foundation

enum CountryCode: String {
    case US
    case CL
    case SE
}

struct URLFactory {
   func generateURL(with countryCode: CountryCode) -> URL? {
        return URL(string: String(format: "https://itunes.apple.com/%@/rss/topsongs/limit=10/json", countryCode.rawValue))
    }
}
