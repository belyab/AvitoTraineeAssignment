import UIKit

class MainViewController: UIViewController, MainViewProtocol {
    
    var presenter: MainViewPresenterProtocol?
    var state: ScreenState = .loading {
        didSet {
            setState(state)
        }
    }
    let loadingView = UIActivityIndicatorView(style: .medium)
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(AdsCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        collectionView.dataSource = self
        collectionView.delegate = self
        setupConstraints()
    }
    
    private func setState(_ state: ScreenState) {
        switch state {
        case .loading:
            collectionView.isHidden = true
            loadingView.isHidden = false
            loadingView.startAnimating()
        case .content:
            collectionView.isHidden = false
            loadingView.isHidden = true
            loadingView.stopAnimating()
        case .error(let message):
            collectionView.isHidden = true
            loadingView.isHidden = true
            loadingView.stopAnimating()
            showError(message: message)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showDetails(forAdsID id: String) {
        let detailsVC = DetailViewController()
        detailsVC.adsId = id
        detailsVC.presenter = DetailPresenter(view: detailsVC, networkService: NetworkService(), adsID: id)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func success() {
        collectionView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.adsList?.advertisements.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AdsCell
        let advertisement = presenter?.adsList?.advertisements[indexPath.row]
        cell.configureViewModel(withViewModel: advertisement!)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2-30, height: 400)
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ads = presenter?.adsList?.advertisements[indexPath.item]
        let adsId = ads?.id
        presenter?.didSelectAds(withID: adsId!)
    }
}


