import UIKit

final class FavoritesViewController: ArtistBaseViewController {
    private var completedRequestsCount = 0
    private var favoriteModel: [ViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDefaultsChange), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async {
            self.fetchArtistList()
        }
    }
    
    @objc private func handleUserDefaultsChange() {
        DispatchQueue.global().async {
            self.fetchArtistList()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
                    }
                    
                case .failure(let error):
                    print("Error fetching artist list: \(error)")
                }
            }
        }
    }
    
    private func passDataToBase(viewModels: [ViewModel]) {
        let filteredModel = favoriteModel.filter { viewModel in
            favoriteModel.firstIndex(where: { $0.id == viewModel.id }) == favoriteModel.firstIndex(of: viewModel)
        }
        if let favoriteIDs = UserDefaults.standard.array(forKey: "SongID") as? [String] {
            artistViewModels = filteredModel.filter { favoriteIDs.contains($0.id) }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
