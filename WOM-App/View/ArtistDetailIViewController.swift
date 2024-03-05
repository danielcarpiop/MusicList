import UIKit
import Kingfisher

class ArtistDetailIViewController: UIViewController {
    private let viewModel: ViewModel
    
    private let viewContainer: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let artistImage = UIImageView(frame: .zero)
    
    private let songName: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistName: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDate: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rights: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sample = UIButton(frame: .zero)
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    private func prepare() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.addSubview(viewContainer)
        
        NSLayoutConstraint.activate([
            viewContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            viewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            artistImage.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            artistImage.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            artistImage.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            
            songName.topAnchor.constraint(equalTo: artistImage.bottomAnchor, constant: 6),
            songName.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 10),
            songName.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10),
            
            artistName.topAnchor.constraint(equalTo: songName.bottomAnchor, constant: 6),
            artistName.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 10),
            artistName.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10),
            
            releaseDate.topAnchor.constraint(equalTo: artistName.bottomAnchor, constant: 6),
            releaseDate.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 10),
            releaseDate.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10),
            
            rights.topAnchor.constraint(equalTo: releaseDate.bottomAnchor, constant: 6),
            rights.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 10),
            rights.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10),
            
            sample.topAnchor.constraint(equalTo: rights.bottomAnchor, constant: 15),
            sample.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
            sample.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor)
        ])
        
        artistImage.kf.setImage(with: URL(string: viewModel.imageUrl), placeholder: UIImage(resource: .womLogo))
    }
}
