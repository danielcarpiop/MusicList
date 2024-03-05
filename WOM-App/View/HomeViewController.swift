import UIKit

class HomeViewController: ArtistBaseViewController {
    private var completedRequestsCount = 0
    private var homeModel: [ViewModel] = [] {
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
        fetchArtistList()
    }
    
    private func fetchArtistList() {
        let countryCodes: [CountryCode] = [.SE, .US, .CL]
        let totalRequests = countryCodes.count
        
        countryCodes.forEach { codes in
            useCase.getList(countryCode: codes) { result in
                switch result {
                case.success(let viewModels):
                    self.homeModel.append(contentsOf: viewModels)
                    self.completedRequestsCount += 1
                    
                    if self.completedRequestsCount == totalRequests {
                        self.passDataToBase(viewModels: self.homeModel)
                    }
                    
                case .failure(let error):
                    print("Error fetching artist list: \(error)")
                }
            }
        }
    }
    
    private func passDataToBase(viewModels: [ViewModel]) {
        let filteredModel = homeModel.filter { viewModel in
            homeModel.firstIndex(where: { $0.id == viewModel.id }) == homeModel.firstIndex(of: viewModel)
        }
        artistViewModels = filteredModel
    }
}
