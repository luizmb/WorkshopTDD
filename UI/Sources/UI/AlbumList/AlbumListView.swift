import API
import Combine
import SwiftUI

public struct AlbumListView: View {
    @ObservedObject var viewModel: AlbumListViewModel

    public init(viewModel: AlbumListViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            List(viewModel.state.albums) { album in
                AlbumCell(album: album) { event in
                    viewModel.send(event: event)
                }
            }
            .navigationBarTitle(Text("Music Browser"))
            .onAppear {
                viewModel.send(event: .onAppear)
            }
        }
    }
}

struct AlbumCell: View {
    let album: AlbumListViewModel.ViewState.AlbumCellViewState
    let onEvent: (AlbumListViewModel.ViewEvent) -> Void

    var body: some View {
        HStack {
            albumImage()
                .font(.largeTitle)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.sRGB, red: 0.85, green: 0.85, blue: 0.92, opacity: 0.7),
                            Color(.sRGB, red: 0.9, green: 0.95, blue: 0.95, opacity: 0.8),
                            Color(.sRGB, red: 0.85, green: 0.9, blue: 0.96, opacity: 0.4)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .frame(width: 100, height: 100, alignment: .center)
                )
                .frame(width: 100, height: 100, alignment: .center)

            VStack(alignment: .leading) {
                Text(album.name)
                Text(album.artist)
            }

            Spacer()
        }
    }

    @ViewBuilder
    func albumImage() -> some View {
        if let image = album.image {
            Image(uiImage: image)
                .resizable()
        } else {
            Image(systemName: "music.note").onAppear {
                onEvent(.onAppearPlaceholderImage(albumId: album.id) )
            }
        }
    }
}

#if DEBUG
struct AlbumListViewPreviews: PreviewProvider {
    static var previews: some View {
        AlbumListView(
            viewModel: AlbumListViewModel(
                state: .init(
                    albums: AlbumListViewModel.albumsViewState(from: expectedAlbumList),
                    error: nil
                )
            )
        )
    }
}

let expectedAlbumList = [
    Album(
        id: "1463706038",
        album: "We Are Not Your Kind",
        artist: Artist(name: "Slipknot"),
        cover: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music123/v4/2b/4d/97/2b4d97a1-d445-c0f9-6f95-f602392ec362/016861741006.jpg/128x128bb.jpeg")!,
        label: "Roadrunner Records",
        tracks: [
          AlbumTrack(trackName: "Insert Coin"),
          AlbumTrack(trackName: "Unsainted"),
          AlbumTrack(trackName: "Birth of the Cruel"),
          AlbumTrack(trackName: "Death Because of Death"),
          AlbumTrack(trackName: "Nero Forte"),
          AlbumTrack(trackName: "Critical Darling"),
          AlbumTrack(trackName: "A Liar's Funeral"),
          AlbumTrack(trackName: "Red Flag"),
          AlbumTrack(trackName: "What's Next"),
          AlbumTrack(trackName: "Spiders"),
          AlbumTrack(trackName: "Orphan"),
          AlbumTrack(trackName: "My Pain"),
          AlbumTrack(trackName: "Not Long for This World"),
          AlbumTrack(trackName: "Solway Firth")
        ],
        year: "2019"
    ),
    Album(
        id: "1440833237",
        album: "Metallica",
        artist: Artist(name: "Metallica"),
        cover: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music118/v4/65/30/cd/6530cd17-9970-2af8-58eb-e994c0abf73c/00602547331366.rgb.jpg/128x128bb.jpeg")!,
        label: "Virgin EMI",
        tracks: [
          AlbumTrack(trackName: "Enter Sandman"),
          AlbumTrack(trackName: "Sad But True"),
          AlbumTrack(trackName: "Holier Than Thou"),
          AlbumTrack(trackName: "The Unforgiven"),
          AlbumTrack(trackName: "Wherever I May Roam"),
          AlbumTrack(trackName: "Don't Tread On Me"),
          AlbumTrack(trackName: "Through the Never"),
          AlbumTrack(trackName: "Nothing Else Matters"),
          AlbumTrack(trackName: "Of Wolf and Man"),
          AlbumTrack(trackName: "The God That Failed"),
          AlbumTrack(trackName: "My Friend of Misery"),
          AlbumTrack(trackName: "The Struggle Within"),
        ],
        year: "1991"

    ),
    Album(
        id: "981156807",
        album: "Rock In Rio (Live)",
        artist: Artist(name: "Iron Maiden"),
        cover: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music3/v4/ce/63/08/ce63083d-5342-312a-2611-dc9bd6ed72c9/825646128266.jpg//128x128bb.jpeg")!,
        label: "Parlophone UK",
        tracks: [
          AlbumTrack(trackName: "Intro (Arthur's Farewell) [Live '01]"),
          AlbumTrack(trackName: "The Wicker Man (Live '01)"),
          AlbumTrack(trackName: "Ghost of the Navigator (Live '01)"),
          AlbumTrack(trackName: "Brave New World (Live '01)"),
          AlbumTrack(trackName: "Wrathchild (Live '01)"),
          AlbumTrack(trackName: "2 Minutes To Midnight (Live '01)"),
          AlbumTrack(trackName: "Blood Brothers (Live '01)"),
          AlbumTrack(trackName: "Sign of the Cross (Live '01)"),
          AlbumTrack(trackName: "The Mercenary (Live '01)"),
          AlbumTrack(trackName: "The Trooper (Live '01)"),
          AlbumTrack(trackName: "Dream of Mirrors (Live '01)"),
          AlbumTrack(trackName: "The Clansman (Live '01)"),
          AlbumTrack(trackName: "The Evil That Men Do (Live '01)"),
          AlbumTrack(trackName: "Fear of the Dark (Live '01)"),
          AlbumTrack(trackName: "Iron Maiden (Live '01)"),
          AlbumTrack(trackName: "The Number of the Beast (Live '01)"),
          AlbumTrack(trackName: "Hallowed Be Thy Name (Live '01)"),
          AlbumTrack(trackName: "Sanctuary (Live '01)"),
          AlbumTrack(trackName: "Run To the Hills (Live '01)")
        ],
        year: "2002"
    )
]
#endif
