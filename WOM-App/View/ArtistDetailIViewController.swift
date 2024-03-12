import UIKit
import Kingfisher

class ArtistDetailIViewController: UIViewController {
    private let viewModel: ViewModel
    private var isFav: Bool {
        didSet {
            let starColor = isFav ? UIImage(resource: .goldenStar) : UIImage(resource: .fullStar)
            favorites.setImage(starColor, for: .normal)
        }
    }
    
    private let viewContainer: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.07)
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let artistImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.borderWidth = 1
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    private let favorites: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let songName: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .wom
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistName: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16)
        label.textColor = .wom
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDate: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rights: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sample = UIButton(frame: .zero)
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        let array = UserDefaults.standard.array(forKey: "SongID") as? [String] ?? []
        self.isFav = array.contains(viewModel.id)
        super.init(nibName: nil, bundle: nil)
        let starColor = isFav ? UIImage(resource: .goldenStar) : UIImage(resource: .fullStar)
        favorites.setImage(starColor, for: .normal)
        prepare()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let array = UserDefaults.standard.array(forKey: "SongID") as? [String] ?? []
        self.isFav = array.contains(viewModel.id)
        let starColor = isFav ? UIImage(resource: .goldenStar) : UIImage(resource: .fullStar)
        favorites.setImage(starColor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func prepare() {
        view.addSubview(blurView)
        blurView.contentView.addSubview(viewContainer)
        blurView.contentView.addSubview(favorites)
        viewContainer.addSubview(artistImage)
        viewContainer.addSubview(songName)
        viewContainer.addSubview(artistName)
        viewContainer.addSubview(releaseDate)
        viewContainer.addSubview(rights)
        viewContainer.addSubview(sample)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            viewContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            viewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),

            
            artistImage.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 20),
            artistImage.heightAnchor.constraint(equalToConstant: 170),
            artistImage.widthAnchor.constraint(equalToConstant: 170),
            artistImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            favorites.topAnchor.constraint(equalTo: artistImage.bottomAnchor, constant: 5),
            favorites.centerXAnchor.constraint(equalTo: artistImage.centerXAnchor),
            favorites.heightAnchor.constraint(equalToConstant: 22),
            favorites.widthAnchor.constraint(equalToConstant: 22),

            songName.topAnchor.constraint(equalTo: favorites.bottomAnchor, constant: 15),
            songName.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 10),
            songName.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10),
            
            artistName.topAnchor.constraint(equalTo: songName.bottomAnchor, constant: 15),
            artistName.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 10),
            artistName.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10),
            
            releaseDate.topAnchor.constraint(equalTo: artistName.bottomAnchor, constant: 15),
            releaseDate.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 10),
            releaseDate.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10),
            releaseDate.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10)
        ])
        
        artistImage.kf.setImage(with: URL(string: viewModel.imageUrl), placeholder: UIImage(resource: .womLogo))
        favorites.addTarget(self, action: #selector(toggleStar), for: .primaryActionTriggered)
        songName.text = viewModel.song
        artistName.text = viewModel.name
        releaseDate.text = "Lanzamiento: \(viewModel.releaseDate)"
    }
    
    @objc private func toggleStar() {
        var array = UserDefaults.standard.array(forKey: "SongID") as? [String] ?? []
        if let index = array.firstIndex(of: viewModel.id) {
            array.remove(at: index)
            isFav = false
        } else {
            array.append(viewModel.id)
            isFav = true
        }
        UserDefaults.standard.set(array, forKey: "SongID")
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
}

extension ArtistDetailIViewController {
    @objc private func handleDismiss(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !viewContainer.frame.contains(location) {
            dismiss(animated: true, completion: nil)
        }
    }
}
