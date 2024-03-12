import UIKit
import Combine

class HomeViewController: ArtistBaseViewController {
    private var viewModel = ArtistListViewModel(useCase: ArtistListUseCase(service: ArtistListApi()))
    private var cancellables = Set<AnyCancellable>()
    private let fetchArtistListSubject = PassthroughSubject<Void, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let input = ArtistListInput(fetchArtistList: fetchArtistListSubject.eraseToAnyPublisher())
        viewModel.transform(input: input, filter: { Array(Set($0)) })
            .sink { [weak self] state in
                switch state {
                case .idle:
                    break
                case .loading:
                    break
                case .loaded(let viewModels):
                    self?.artistViewModels = viewModels
                case .failure(let error):
                    print("Error fetching artist list: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArtistListSubject.send(())
    }
}
