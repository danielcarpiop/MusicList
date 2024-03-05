import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        view.backgroundColor = .purple
        ArtistListUseCase(service: ArtistListApi()).getList(countryCode: .CL) { viewModels in
            print(viewModels)
        }
    }
    
    private func prepare() {
        
    }
}

