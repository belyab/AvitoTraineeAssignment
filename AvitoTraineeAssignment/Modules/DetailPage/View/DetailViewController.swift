import UIKit

class DetailViewController: UIViewController, DetailViewProtocol {
    var presenter: DetailViewPresenterProtocol?
    private let networkingService = NetworkService()
    var adsId: String?
    var state: ScreenState = .loading {
        didSet {
            setState(state)
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    private let titleLabel = createLabel(fontSize: 18, weight: .semibold)
    private let priceLabel = createLabel(fontSize: 18, weight: .black)
    private let locationLabel = createLabel(fontSize: 14, weight: .regular)
    private let createdDateLabel = createLabel(fontSize: 14, weight: .regular)
    private let descriptionLabel = createLabel(fontSize: 14, weight: .regular)
    private let emailLabel = createLabel(fontSize: 14, weight: .regular)
    private let phoneNumberLabel = createLabel(fontSize: 14, weight: .regular)
    private let addressLabel = createLabel(fontSize: 14, weight: .regular)
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    let loadingView = UIActivityIndicatorView(style: .medium)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupContentView()
        setupConstraints()
        presenter?.fetchAdsById()
    }
    
    private static func createLabel(fontSize: CGFloat, weight: UIFont.Weight = .regular, numberOfLines: Int = 0) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = weight == .regular ? .lightGray : .black
        label.numberOfLines = numberOfLines
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }
    
    private func setState(_ state: ScreenState) {
        switch state {
        case .loading:
            blurView.isHidden = false
            loadingView.isHidden = false
            loadingView.startAnimating()
        case .content:
            blurView.isHidden = true
            loadingView.isHidden = true
            loadingView.stopAnimating()
        case .error(let message):
            blurView.isHidden = false
            loadingView.isHidden = true
            showError(message: message)
        }
    }
    
    func displayDetail(with ads: AdsDetailModel) {
        titleLabel.text = ads.title
        priceLabel.text = ads.price
        locationLabel.text = ads.location
        createdDateLabel.text = ads.createdDate
        descriptionLabel.text = ads.description
        emailLabel.text = ads.email
        phoneNumberLabel.text = ads.phoneNumber
        addressLabel.text = ads.address
        networkingService.loadImage(from: ads.imageURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.imageView.image = image
                case .failure(let error):
                    self?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupContentView() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(locationLabel)
        view.addSubview(createdDateLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(emailLabel)
        view.addSubview(phoneNumberLabel)
        view.addSubview(addressLabel)
        view.addSubview(blurView)
        view.addSubview(loadingView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height/3),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            createdDateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 6),
            createdDateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            createdDateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: createdDateLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            emailLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            phoneNumberLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 6),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addressLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 6),
            addressLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addressLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
}
