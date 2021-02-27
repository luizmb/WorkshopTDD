import Foundation

public struct AlbumTrack: Decodable, Equatable {
    public init(trackName: String) {
        self.trackName = trackName
    }

    public let trackName: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.trackName = try container.decode(String.self)
    }
}
