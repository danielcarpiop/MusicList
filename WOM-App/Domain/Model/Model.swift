import UIKit

struct Model: Codable {
    let feed: Feed
}

struct Feed: Codable {
    let entry: [Entry]
}

struct Entry: Codable {
    let title: Title
    let imReleaseDate: ReleaseDate?
    let rights: Rights
    let imImage: [Image]
    let link: [Link]
    let id: Id

    enum CodingKeys: String, CodingKey {
        case title
        case imReleaseDate = "im:releaseDate"
        case rights
        case imImage = "im:image"
        case link
        case id
    }
}

struct Title: Codable {
    let label: String
}

struct ReleaseDate: Codable {
    let attributes: ReleaseDateAttributes
}

struct ReleaseDateAttributes: Codable {
    let label: String
}

struct Rights: Codable {
    let label: String
}

struct Image: Codable {
    let label: String
    let attributes: Attributes
}

struct Attributes: Codable {
    let height: String
}

struct Link: Codable {
    let attributes: LinkAttributes
}

struct LinkAttributes: Codable {
    let href: String
}

struct Id: Codable {
    let attributes: AttributesId
}

struct AttributesId: Codable {
    let imId: String
    
    enum CodingKeys: String, CodingKey {
        case imId = "im:id"
    }
}
