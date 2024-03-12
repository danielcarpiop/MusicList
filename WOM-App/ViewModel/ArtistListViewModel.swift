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

    func transform(input: ArtistListInput, filter: @escaping ([ViewModel]) -> [ViewModel]) -> ArtistListOutput {
        let countryCodes: [CountryCode] = [.SE, .US, .CL]

        return input.fetchArtistList
            .flatMap { _ in
                Publishers.MergeMany(countryCodes.map { countryCode in
                    self.useCase.getList(countryCode: countryCode)
                })
                .collect()
                .map { responses in
                    responses.flatMap { $0 }
                }
                .map(filter)
                .map(ArtistListState.loaded)
                .catch { Just(ArtistListState.failure($0)) }
                .prepend(ArtistListState.loading)
            }
            .eraseToAnyPublisher()
    }
}
