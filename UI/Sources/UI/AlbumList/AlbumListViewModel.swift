import API
import Combine
import Foundation
import UIKit

public class AlbumListViewModel: ObservableObject {
    @Published public var state: ViewState

    private let musicService: MusicBrowserService

    public init(world: World) {
        self.musicService = MusicBrowserService(urlSession: world.urlSession, jsonDecoder: world.jsonDecoder)
        self.state = .empty
    }

    #if DEBUG
    public init(state: ViewState) {
        self.musicService = MusicBrowserService(urlSession: URLSession.shared, jsonDecoder: JSONDecoder())
        self.state = state
    }

    public init(world: World, state: ViewState) {
        self.musicService = MusicBrowserService(urlSession: world.urlSession, jsonDecoder: world.jsonDecoder)
        self.state = state
    }
    #endif

    public func send(event: ViewEvent) {
        switch event {
        case .onAppear:
            onAppear()
        case let .onAppearPlaceholderImage(albumId):
            onAppearPlaceholderImage(albumId: albumId)
        }
    }

    private func onAppear() {
        musicService
            .fetchAllAlbums { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case let .failure(error):
                        self?.state = ViewState(
                            albums: [],
                            error: "There's an error while fetching albums from the internet. Details: \(error.localizedDescription)"
                        )
                    case let .success(albums):
                        self?.state = ViewState(
                            albums: Self.albumsViewState(from: albums),
                            error: nil
                        )
                    }
                }
            }
    }

    private func onAppearPlaceholderImage(albumId: String) {
        guard let url = state.albums.first(where: { $0.id == albumId })?.imageURL else { return }
        musicService
            .fetchAlbumImage(from: url) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case let .failure(error):
                        self.state = ViewState(albums: self.state.albums, error: error.localizedDescription)

                    case let .success(image):
                        self.state = ViewState(
                            albums: self.state.albums.map {
                                guard $0.id == albumId else { return $0 }
                                return AlbumListViewModel.ViewState.AlbumCellViewState(
                                    id: $0.id,
                                    name: $0.name,
                                    artist: $0.artist,
                                    imageURL: $0.imageURL,
                                    image: UIImage(data: image)
                                )
                            },
                            error: self.state.error
                        )
                    }
                }
            }
    }

    static func albumsViewState(from albums: [Album]) -> [AlbumListViewModel.ViewState.AlbumCellViewState] {
        albums.map { album in
            ViewState.AlbumCellViewState(
                id: album.id,
                name: album.album,
                artist: album.artist.name,
                imageURL: album.cover,
                image: album.image.flatMap(UIImage.init(data:))
            )
        }
    }
}

extension AlbumListViewModel {
    public struct ViewState: Equatable {
        struct AlbumCellViewState: Equatable, Identifiable {
            let id: String
            let name: String
            let artist: String
            let imageURL: URL
            var image: UIImage?
        }

        let albums: [AlbumCellViewState]
        let error: String?

        static var empty: ViewState {
            ViewState(albums: [], error: nil)
        }
    }

    public enum ViewEvent {
        case onAppear
        case onAppearPlaceholderImage(albumId: String)
    }
}
