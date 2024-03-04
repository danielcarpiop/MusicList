import UIKit

struct Model {
    let feed: Feed
}

struct Feed {
    let author: Author
    let entry: Entry
    let updated, rights, title, icon: Icon
    let link: [IMCollectionLink]
    let id: Icon
}

struct Author {
    let name, uri: Icon
}

struct Icon {
    let label: String
}

struct Entry {
    let imName: Icon
    let imImage: [IMImage]
    let imCollection: IMCollection
    let imPrice: IMPrice
    let imContentType: IMCollectionIMContentType
    let rights, title: Icon
    let link: [EntryLink]
    let id: ID
    let imArtist: IMArtist
    let category: Category
    let imReleaseDate: IMReleaseDate
}

struct Category {
    let attributes: CategoryAttributes
}

struct CategoryAttributes {
    let imID, term: String
    let scheme: String
    let label: String
}

struct ID {
    let label: String
    let attributes: IDAttributes
}

struct IDAttributes {
    let imID: String
}

struct IMArtist {
    let label: String
    let attributes: IMArtistAttributes
}

struct IMArtistAttributes {
    let href: String
}

struct IMCollection {
    let imName: Icon
    let link: IMCollectionLink
    let imContentType: IMCollectionIMContentType
}

struct IMCollectionIMContentType {
    let imContentType: IMContentTypeIMContentType
    let attributes: IMContentTypeAttributes
}

struct IMContentTypeAttributes {
    let term, label: String
}

struct IMContentTypeIMContentType {
    let attributes: IMContentTypeAttributes
}

struct IMCollectionLink {
    let attributes: PurpleAttributes
}

struct PurpleAttributes {
    let rel: String
    let type: String?
    let href: String
}

struct IMImage {
    let label: String
    let attributes: IMImageAttributes
}

struct IMImageAttributes {
    let height: String
}

struct IMPrice {
    let label: String
    let attributes: IMPriceAttributes
}

struct IMPriceAttributes {
    let amount, currency: String
}

struct IMReleaseDate {
    let label: Date
    let attributes: Icon
}

struct EntryLink {
    let attributes: FluffyAttributes
    let imDuration: Icon?
}

struct FluffyAttributes {
    let rel, type: String
    let href: String
    let title, imAssetType: String?
}
