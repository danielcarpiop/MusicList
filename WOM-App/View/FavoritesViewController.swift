import UIKit
import Combine

class FavoritesViewController: ArtistBaseViewController {
    private var viewModel = ArtistListViewModel(useCase: ArtistListUseCase(service: ArtistListApi()))
    private var cancellables = Set<AnyCancellable>()
    private let fetchArtistListSubject = PassthroughSubject<Void, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDefaultsChange), name: UserDefaults.didChangeNotification, object: nil)
        
        let input = ArtistListInput(fetchArtistList: fetchArtistListSubject.eraseToAnyPublisher())
        viewModel.transform(input: input, filter: { viewModels in
            let favoriteIDs = UserDefaults.standard.array(forKey: "SongID") as? [String] ?? []
            let viewFilteredViewModels = viewModels.filter { favoriteIDs.contains($0.id) }
            return Array(Set(viewFilteredViewModels))
        })
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
    
    @objc private func handleUserDefaultsChange() {
        fetchArtistListSubject.send(())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
