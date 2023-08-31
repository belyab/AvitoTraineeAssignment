import Foundation

// MARK: - Protocols
protocol DetailViewProtocol {
    func displayDetail(with ads: AdsDetailModel)
    var state: ScreenState { get set }
}

protocol DetailViewPresenterProtocol {
    init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, adsID: String?)
    func fetchAdsById()
}

// MARK: - DetailPresenter
class DetailPresenter: DetailViewPresenterProtocol {
    
    var view: DetailViewProtocol?
    let networkService: NetworkServiceProtocol!
    let adsID: String?
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, adsID: String?) {
        self.view = view
        self.networkService = networkService
        self.adsID = adsID
    }
    
    func fetchAdsById() {
        view?.state = .loading
        networkService.fetchAdsById(id: adsID!) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let adsDetailModel):
                    self.view?.displayDetail(with: adsDetailModel)
                    self.view?.state = .content
                case .failure(let error):
                    let errorMessage = error.localizedDescription
                    self.view?.state = .error(message: errorMessage)
                }
            }
        }
    }
}
