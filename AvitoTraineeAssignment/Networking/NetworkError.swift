import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .noData:
            return "Данные не найдены"
        case .decodingError:
            return "Ошибка декодирования данных"
        }
    }
}
