import Foundation
import Combine

final class ArtistListUseCase {
    private let service: ArtistListService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ArtistListService) {
        self.service = service
    }
    
    func getList(countryCode: CountryCode) -> AnyPublisher<[ViewModel], Error> {
            return service.getList(countryCode: countryCode)
                .map { model in
                    return mapModelToViewModel(model: model, countryCode: countryCode)
                }
                .eraseToAnyPublisher()
        }
}

private func mapModelToViewModel(model: Model, countryCode: CountryCode) -> [ViewModel] {
    return model.feed.entry.map {
        let fullName = $0.title.label
        let splitFullName = fullName.split(separator: "-").map { $0.trimmingCharacters(in: .whitespaces)}
        var name = ""
        var song = ""
        
        if splitFullName.count == 2 {
            name = splitFullName[1]
            song = splitFullName[0]
        } else {
            name = fullName
            song = ""
        }
        
        return ViewModel(
            fullName: fullName,
            name: name,
            song: song,
            releaseDate: $0.imReleaseDate?.attributes.label ?? "",
            rights: $0.rights.label,
            imageUrl: $0.imImage.filter { $0.attributes.height == "170"}[0].label,
            audioUrl: $0.link.filter { $0.attributes.href.hasSuffix(".m4a") }[0].attributes.href,
            id: $0.id.attributes.imId,
            countryCode: countryCode
        )
    }
}
