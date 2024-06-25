import UIKit
import Kingfisher

class ArtistDetailIViewController: UIViewController {
    weak var delegate: ArtistDetailDelegate?
    private let viewModel: ViewModel
    private let viewControllerCaller: UIViewController
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
        label.textColor = .purple
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistName: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16)
        label.textColor = .purple
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
    
//    init(viewModel: ViewModel, viewControllerCaller: UIViewController) {
//        self.viewModel = viewModel
//        self.viewControllerCaller = viewControllerCaller
//        let array = UserDefaults.standard.array(forKey: "SongID") as? [String] ?? []
//        self.isFav = array.contains(viewModel.id)
//        super.init(nibName: nil, bundle: nil)
//        let starColor = isFav ? UIImage(resource: .goldenStar) : UIImage(resource: .fullStar)
//        favorites.setImage(starColor, for: .normal)
//        prepare()
//    }
    
    init(viewModel: ViewModel, viewControllerCaller: UIViewController) {
        self.viewModel = viewModel
        self.viewControllerCaller = viewControllerCaller
        self.isFav = false
        super.init(nibName: nil, bundle: nil)
        setupStar()
        prepare()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStar()
    }
    
    func setupStar() {
        let favoritesList: [ViewModel] = LocalStorage.shared.retrieve(forKey: "FavoritesList", as: [ViewModel].self) ?? []
        self.isFav = favoritesList.contains(where: { $0.id == viewModel.id })
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.artistDetailReload(self, viewControllerCaller: viewControllerCaller)
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
        
        artistImage.kf.setImage(with: URL(string: viewModel.imageUrl), placeholder: UIImage(resource: .itunesLogo))
        favorites.addTarget(self, action: #selector(toggleStar), for: .primaryActionTriggered)
        let splitName = viewModel.name.split(separator: "-").map { $0.trimmingCharacters(in: .whitespaces)}
        if splitName.count == 2 {
            songName.text = splitName[0]
            artistName.text = splitName[1]
        } else {
            songName.text = viewModel.name
        }
        releaseDate.text = "Lanzamiento: \(viewModel.releaseDate)"
    }
    
    @objc private func toggleStar() {
        var favorites: [ViewModel] = LocalStorage.shared.retrieve(forKey: "FavoritesList", as: [ViewModel].self) ?? []
        
        if let index = favorites.firstIndex(where: {$0.id == viewModel.id}) {
            favorites.remove(at: index)
            isFav = false
        } else {
            favorites.append(viewModel)
            isFav = true
        }
        
        LocalStorage.shared.set(favorites, forKey: "FavoritesList")
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
