import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func fetchAdsList(completion: @escaping(Result<AdsList, Error>) -> Void)
    func fetchAdsById(id: String, completion: @escaping(Result<AdsDetailModel, Error>) -> Void)
    func loadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func fetchAdsList(completion: @escaping (Result<AdsList, Error>) -> Void) {
        guard let url = URL(string: "https://www.avito.st/s/interns-ios/main-page.json") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let adsList = try JSONDecoder().decode(AdsList.self, from: data)
                completion(.success(adsList))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }


    
    func fetchAdsById(id: String, completion: @escaping(Result<AdsDetailModel, Error>) -> Void) {
        guard let url = URL(string: "https://www.avito.st/s/interns-ios/details/\(id).json") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            if let adsDetailModel = try? JSONDecoder().decode(AdsDetailModel.self, from: data){
                completion(.success(adsDetailModel))
            } else {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
    
    func loadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Unable to load image")
                completion(.failure(NetworkError.noData))
                return
            }

            completion(.success(image))
        }.resume()
    }
}

