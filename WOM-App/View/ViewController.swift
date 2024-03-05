import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        view.backgroundColor = .purple
        ArtistListApi().getList(countryCode: .CL) { response in
            print(response)
        }
        
        
        
    }

    private func prepare() {
        
    }
}

