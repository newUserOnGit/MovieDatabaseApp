
import UIKit
import Foundation

enum NetworkError: Error {
    case httpError(statusCode: Int)
    case decodingError
    case notFound
    case noData
    case encodingError
    case unauthorized
}

protocol NetworkConnectionProtocol {
    func fetchMovies() async throws -> [Movie]
}


class NetworkUtils {
    static let GET: String = "GET"
    
    static func ensureStatusCodeIs200(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpError(statusCode: -1)
        }
        // swiftlint:disable force_unwrapping
        print("network request \(response.url!.absoluteString) status code \((response as? HTTPURLResponse)!.statusCode)")
        // swiftlint:enable force_unwrapping
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 404 {
                throw NetworkError.notFound
            } else if httpResponse.statusCode == 401 {
                throw NetworkError.unauthorized
            } else {
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }
        }
    }
}

final class NetworkConnection: NetworkConnectionProtocol {
    func fetchMovies() async throws -> [Movie] {
        do {
            return try await NetworkService.request(type: .getMovies, responseType: GetMoviesResponse.self).movies.map { movie in
                return Movie(_id: 0, title: "",  overview: "", release_date: "", genres: [], poster_path: "")
            }
        } catch {
            throw error
        }
    }
}

enum NetworkService {
    static let baseURL = URL(string: "https://movies-api14.p.rapidapi.com")
    
    case getMovies
}

extension NetworkService {
    var path: String {
        switch self {
        case .getMovies:
            return "/movies"
        }
    }
    
    var method: String {
        switch self {
        case .getMovies:
            return NetworkUtils.GET
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getMovies:
            return [
                "X-RapidAPI-Key": "819aa70ab7msh9797d673db0ba6fp1831e1jsn3b0917147b91",
                "X-RapidAPI-Host": "movies-api14.p.rapidapi.com"
            ]
        }
    }
    
    var body: Data? {
        return nil
    }
    
    static func request<T: Decodable> (type: NetworkService, responseType: T.Type) async throws -> T {
        let urlRequest = buildRequest(type: type)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            try NetworkUtils.ensureStatusCodeIs200(response: response)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    static func request(type: NetworkService) async throws {
        let urlRequest = buildRequest(type: type)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: urlRequest)
            try NetworkUtils.ensureStatusCodeIs200(response: response)
        } catch {
            throw error
        }
    }
    
    private static func buildRequest(type: NetworkService) -> URLRequest {
        guard let resourceURL = baseURL?.appendingPathComponent(type.path) else {
            fatalError("Failed to convert baseURL to a URL")
        }
        
        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.httpMethod = type.method
        
        if let headers = type.headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = type.body {
            urlRequest.httpBody = body
        }
        
        return urlRequest
    }
}

struct GetMoviesResponse: Codable {
    let movies: [Movie]
}

struct Movie: Codable {
    var _id: Int
    var title: String
    var overview: String
    var release_date: String
    var genres: [String]
    var poster_path: String
    var posterUIImage: UIImage?
    var genre: String?
    var isFavorite: Bool?
    
    struct Genres: Codable {
        var name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case _id, title, overview, release_date, poster_path, genres
    }
}
