import API
import Combine
import Foundation
import SwiftUI

public class AlbumDetailsViewModel: ObservableObject {
    @Published public var state: ViewState

    public init(state: ViewState) {
        self.state = state
    }
}

extension AlbumDetailsViewModel {
    public struct TrackRow: Equatable, Identifiable {
        public var id: String {
            trackNumber
        }
        let trackNumber: String
        let trackName: String
    }

    public struct ViewState: Equatable {
        let image: UIImage?
        let artistName: String
        let albumName: String
        let tracks: [TrackRow]

        static var empty: ViewState {
            ViewState(image: nil, artistName: "", albumName: "", tracks: [])
        }
    }

    public enum ViewEvent {
//        case onAppear
//        case onAppearPlaceholderImage(albumId: String)
    }
}
