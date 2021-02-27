import Foundation

public struct Album: Decodable, Equatable, Identifiable {
    public init(id: String, album: String, artist: Artist, cover: URL, label: String, tracks: [AlbumTrack], year: String, image: Data? = nil) {
        self.id = id
        self.album = album
        self.artist = artist
        self.cover = cover
        self.label = label
        self.tracks = tracks
        self.year = year
        self.image = image
    }

    public let id: String

    public let album: String
    public let artist: Artist
    public let cover: URL
    public let label: String
    public let tracks: [AlbumTrack]
    public let year: String
    public var image: Data?
}
