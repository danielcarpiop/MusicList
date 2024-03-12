import UIKit
import Combine

final class FavoritesViewController: ArtistBaseViewController {
    private var favoriteModel: [ViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDefaultsChange), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchArtistList()
    }
    
    @objc private func handleUserDefaultsChange() {
        self.fetchArtistList()
    }
    
    private func fetchArtistList() {
        let countryCodes: [CountryCode] = [.SE, .US, .CL]
        
        let group = DispatchGroup()
        
        countryCodes.forEach { countryCode in
            group.enter()
            
            useCase.getList(countryCode: countryCode)
                .sink (receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching artist list: \(error)")
                    }
                    group.leave()
                    
                }, receiveValue: { [weak self] viewModels in
                    self?.favoriteModel.append(contentsOf: viewModels)
                })
                .store(in: &cancellables)
        }
    }
    
    private func passDataToBase(viewModels: [ViewModel]) {
        let filteredModel = Set(favoriteModel)
        if let favoriteIDs = UserDefaults.standard.array(forKey: "SongID") as? [String] {
            artistViewModels = filteredModel.filter { favoriteIDs.contains($0.id) }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
