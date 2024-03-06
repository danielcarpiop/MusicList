import UIKit

final class FavoritesViewController: ArtistBaseViewController {
    private var completedRequestsCount = 0
    private var favoriteModel: [ViewModel] = []
    
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
        let totalRequests = countryCodes.count
        
        countryCodes.forEach { codes in
            useCase.getList(countryCode: codes) { result in
                switch result {
                case.success(let viewModels):
                    self.favoriteModel.append(contentsOf: viewModels)
                    self.completedRequestsCount += 1
                    
                    if self.completedRequestsCount == totalRequests {
                        self.passDataToBase(viewModels: self.favoriteModel)
                        self.completedRequestsCount = 0
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error fetching artist list: \(error)")
                }
            }
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
