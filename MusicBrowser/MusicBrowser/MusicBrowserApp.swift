import SwiftUI
import UI

@main
struct MusicBrowserApp: App {
    let world = World.production

    var body: some Scene {
        WindowGroup {
            AlbumListView(viewModel: .init(world: world))
        }
    }
}

extension World {
    public static var production: World {
        World(
            urlSession: URLSession.shared,
            jsonDecoder: JSONDecoder()
        )
    }
}
