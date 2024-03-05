import UIKit

class TabBarController: UITabBarController {
    private let useCase = ArtistListUseCase(service: ArtistListApi())
    var artistViewModels: [ViewModel] = []
    private let homeViewController = HomeViewController()
    private let favoritesViewController = FavoritesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTabBar()
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

