import UIKit

class TabBarController: UITabBarController {
    private let useCase = ArtistListUseCase(service: ArtistListApi())
    var artistViewModels: [ViewModel] = []
    private let homeViewController = HomeViewController()
    private let favoritesViewController = FavoritesViewController()
    private var completedRequestsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArtistList()
        prepareTabBar()
    }
    
    private func fetchArtistList() {
        let countryCodes: [CountryCode] = [.SE, .US, .CL]
        let totalRequests = countryCodes.count
        
        countryCodes.forEach { codes in
            useCase.getList(countryCode: codes) { result in
                switch result {
                case.success(let viewModels):
                    self.artistViewModels.append(contentsOf: viewModels)
                    self.completedRequestsCount += 1
                    
                    if self.completedRequestsCount == totalRequests {
                        self.passDataToChildViewControllers(artistViewModels: self.artistViewModels)
                    }
            
                case .failure(let error):
                    print("Error fetching artist list: \(error)")
                }
            }
        }
    }
    
    private func passDataToChildViewControllers(artistViewModels: [ViewModel]) {
        let filteredModel = artistViewModels.filter { viewModel in
            artistViewModels.firstIndex(where: { $0.id == viewModel.id }) == artistViewModels.firstIndex(of: viewModel)
        }
        homeViewController.artistViewModels = filteredModel
        
        if let favoriteIDs = UserDefaults.standard.array(forKey: "SongID") as? [String] {
            favoritesViewController.artistViewModels = filteredModel.filter { favoriteIDs.contains($0.id) }
        }
    }
    
    private func prepareTabBar() {
        self.tabBar.tintColor = .wom
        
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: resizeImage(image: UIImage(resource: .emptyHome).withRenderingMode(.alwaysOriginal), targetSize: CGSize(width: 25, height: 25)), selectedImage: resizeImage(image: UIImage(resource: .fullHome).withRenderingMode(.alwaysOriginal), targetSize: CGSize(width: 25, height: 25)))
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: resizeImage(image: UIImage(resource: .emptyStar).withRenderingMode(.alwaysOriginal), targetSize: CGSize(width: 25, height: 25)), selectedImage: resizeImage(image: UIImage(resource: .fullStar).withRenderingMode(.alwaysOriginal), targetSize: CGSize(width: 25, height: 25)))
        
        viewControllers = [homeViewController, favoritesViewController]
    }
    
    func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage {
           guard let image = image else { return UIImage() }
           let size = image.size
           let widthRatio  = targetSize.width  / size.width
           let heightRatio = targetSize.height / size.height
           let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
           let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
           UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
           image.draw(in: rect)
           let newImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return newImage ?? UIImage()
       }
}



protocol RefreshControl: AnyObject {
    func update()
}

