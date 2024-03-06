import UIKit

class HomeViewController: ArtistBaseViewController {
    private var completedRequestsCount = 0
    private var homeModel: [ViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDefaultsChange), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchArtistList()
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
                        self.completedRequestsCount = 0
                    }
                    
                case .failure(let error):
                    print("Error fetching artist list: \(error)")
                }
            }
        }
    }
    
    private func passDataToBase(viewModels: [ViewModel]) {
        artistViewModels = Array(Set(homeModel))
    }
}
