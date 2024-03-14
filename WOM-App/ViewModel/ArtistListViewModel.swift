import Combine

enum ArtistListState {
    case idle
    case loading
    case loaded([ViewModel])
    case failure(Error)
}

struct ArtistListInput {
    let fetchArtistList: AnyPublisher<Void, Never>
}

typealias ArtistListOutput = AnyPublisher<ArtistListState, Never>

final class ArtistListViewModel {
    private let useCase: ArtistListUseCase
    private var cancellables = Set<AnyCancellable>()

    init(useCase: ArtistListUseCase) {
        self.useCase = useCase
    }

    func transform(input: ArtistListInput) -> ArtistListOutput {
        let countryCodes: [CountryCode] = [.SE, .US, .CL]

        return input.fetchArtistList
            .flatMap { _ in
                Publishers.MergeMany(countryCodes.map { countryCode in
                    self.useCase.getList(countryCode: countryCode)
                })
                .collect()
                .map { responses in
                    let flatResponses = responses.flatMap { $0 }
                    let uniqueArtists = Array(Set(flatResponses.map { $0.fullName }))
                    let compareArtist = uniqueArtists.map { name in
                        flatResponses.first { $0.fullName == name }!
                    }
                    return compareArtist
                }
                .map(ArtistListState.loaded)
                .catch { Just(ArtistListState.failure($0)) }
                .prepend(ArtistListState.loading)
            }
            .eraseToAnyPublisher()
    }
}
