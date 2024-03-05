import Foundation

final class ArtistListUseCase {
    private let service: ArtistListService
    
    init(service: ArtistListService) {
        self.service = service
    }
    
    func getList(countryCode: CountryCode, completion: @escaping (Result<[ViewModel], Error>) -> Void) {
        service.getList(countryCode: countryCode) { result in
            switch result {
            case .success(let model):
                let viewModels = mapModelToViewModel(model: model)
                completion(.success(viewModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private func mapModelToViewModel(model: Model) -> [ViewModel] {
    return model.feed.entry.map {
        return ViewModel(
            name: $0.title.label,
            releaseDate: $0.imReleaseDate.attributes.label,
            rights: $0.rights.label,
            imageUrl: $0.imImage.filter { $0.attributes.height == "170"}[0].label,
            audioUrl: $0.link.filter { $0.attributes.href.hasSuffix(".m4a") }[0].attributes.href
        )
    }
}
