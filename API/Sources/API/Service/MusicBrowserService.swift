import Foundation

public class MusicBrowserService {
    let url: URL
    let urlSession: URLSessionProtocol
    let jsonDecoder: JSONDecoder

    public init(urlSession: URLSessionProtocol, jsonDecoder: JSONDecoder, url: URL = URL(string: "https://1979673067.rsc.cdn77.org/music-albums.json")!) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.url = url
    }

    public func fetchAllAlbums(completionHandler: @escaping (Result<[Album], Error>) -> Void) {
        let jsonDecoder = self.jsonDecoder

        let task = urlSession.request(url: url) { data, _, error in
            if let error = error { completionHandler(.failure(error)) }

            guard let data = data else {
                completionHandler(.failure(NSError(domain: "No data, no error. URLSession failed", code: -1, userInfo: nil)))
                return
            }

            do {
                let albums = try jsonDecoder.decode([Album].self, from: data)
                completionHandler(.success(albums))
            } catch {
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }

    public func fetchAlbumImage(from url: URL, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let task = urlSession.request(url: url) { data, _, error in
            if let error = error { completionHandler(.failure(error)) }

            guard let data = data else {
                completionHandler(.failure(NSError(domain: "No data, no error. URLSession failed", code: -1, userInfo: nil)))
                return
            }

            completionHandler(.success(data))
        }
        task.resume()
    }
}
