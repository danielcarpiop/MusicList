import UIKit

class HeaderInfoView: UIView {
    private let itunes: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = UIImage(resource: .itunesLogo)
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .wom
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Listado de los TOP de iTunes"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        addSubview(itunes)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50),
            itunes.centerYAnchor.constraint(equalTo: centerYAnchor),
            itunes.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            itunes.heightAnchor.constraint(equalToConstant: 25),
            itunes.widthAnchor.constraint(equalToConstant: 25),

            titleLabel.leadingAnchor.constraint(equalTo: itunes.trailingAnchor, constant: 5),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        backgroundColor = .white
    }
}
