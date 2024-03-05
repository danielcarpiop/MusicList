import UIKit

class ViewController: UIViewController {
    private let tableView = UITableView()
    var artistViewModels: [ViewModel] = []
    private let useCase = ArtistListUseCase(service: ArtistListApi())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchArtistList()
    }
    
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArtistGlobalInfoCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.separatorColor = UIColor.wom
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchArtistList() {
        let countryCodes: [CountryCode] = [.SE, .US, .CL]
        countryCodes.forEach { codes in
            useCase.getList(countryCode: codes) { result in
                switch result {
                case.success(let viewModels):
                    self.artistViewModels.append(contentsOf: viewModels)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("Error fetching artist list: \(error)")
                }
            }
        }
    }
    
    private func navigateToDetail(viewModel: ViewModel) {
        navigationController?.present(ArtistDetailIViewController(viewModel: viewModel), animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ArtistGlobalInfoCell else {
            fatalError("Unable to dequeue ArtistGlobalInfoCell")
        }
        let viewModel = artistViewModels[indexPath.row]
        cell.configure(title: viewModel.name, subtitle: viewModel.releaseDate, imgURL: viewModel.imageUrl)
        
        let button = UIButton(type: .detailDisclosure)
        button.tintColor = UIColor.wom
        button.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        cell.accessoryView = button
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedViewModel = artistViewModels[indexPath.row]
        let detailViewController = ArtistDetailIViewController(viewModel: selectedViewModel)
        detailViewController.modalPresentationStyle = .overFullScreen
        detailViewController.modalTransitionStyle = .crossDissolve
        navigationController?.present(detailViewController, animated: false)
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
    }
}
