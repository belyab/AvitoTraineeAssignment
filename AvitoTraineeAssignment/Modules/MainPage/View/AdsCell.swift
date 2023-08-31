import UIKit

class AdsCell: UICollectionViewCell {
    
    private let networkingService = NetworkService()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel = createLabel(fontSize: 12, weight: .semibold, numberOfLines: 2)
    private let priceLabel = createLabel(fontSize: 12, weight: .black)
    private let locationLabel = createLabel(fontSize: 10)
    private let createdDateLabel = createLabel(fontSize: 10)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        setupConstraints()
    }
    
    private static func createLabel(fontSize: CGFloat, weight: UIFont.Weight = .regular, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = weight == .regular ? .lightGray : .black
        label.numberOfLines = numberOfLines
        return label
    }
    
    private func setupContentView() {
        contentView.backgroundColor = .white
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(createdDateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            createdDateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            createdDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            createdDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            createdDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    public func configureViewModel(withViewModel viewModel: Advertisement) {
        setTitle(viewModel.title)
        setPrice(viewModel.price)
        setLocation(viewModel.location)
        setCreatedDate(viewModel.createdDate)
        loadImage(from: viewModel.imageURL)
    }
    
    private func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func setPrice(_ price: String) {
        priceLabel.text = price
    }
    
    private func setLocation(_ location: String) {
        locationLabel.text = location
    }
    
    private func setCreatedDate(_ createdDate: String) {
        createdDateLabel.text = createdDate
    }
    
    private func loadImage(from imageURL: String) {
        networkingService.loadImage(from: imageURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.imageView.image = image
                case .failure(let error):
                    print("Ошибка загрузки изображения: \(error.localizedDescription)")
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
