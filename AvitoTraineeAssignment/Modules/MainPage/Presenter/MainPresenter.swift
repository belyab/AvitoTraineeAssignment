import Foundation

// MARK: - Protocols
protocol MainViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
    func showDetails(forAdsID id: String)
    var state: ScreenState { get set }
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol)
    var adsList: AdsList? { get }
    func fetchAdsList()
    func didSelectAds(withID id: String)
}

// MARK: - MainPresenter
class MainPresenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol!
    var adsList: AdsList?
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        fetchAdsList()
    }
    
    func fetchAdsList() {
        view?.state = .loading
         networkService.fetchAdsList { [weak self] result in
             guard let self = self else {return}
             DispatchQueue.main.async {
                 switch result {
                 case .success(let adsList):
                     self.adsList = adsList
                     self.view?.state = .content
                     self.view?.success()
                 case .failure(let error):
                     let errorMessage = error.localizedDescription
                     self.view?.state = .error(message: errorMessage)
                 }
             }
         }
     }
    
    func didSelectAds(withID id: String) {
          view?.showDetails(forAdsID: id)
      }
}
