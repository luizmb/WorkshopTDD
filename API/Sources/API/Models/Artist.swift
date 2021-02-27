import Foundation

public struct Artist: Decodable, Equatable {
    public init(name: String) {
        self.name = name
    }

    public let name: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.name = try container.decode(String.self)
    }
}
