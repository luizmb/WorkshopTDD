import Combine
import Foundation
import SwiftUI

public struct AlbumDetailsView: View {
    @ObservedObject var viewModel: AlbumDetailsViewModel

    public init(viewModel: AlbumDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            if let image = viewModel.state.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
            } else {
                Image(systemName: "music.note")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .border(Color.black)
                    .padding(.horizontal, 8)
            }

            HStack(spacing: 4) {
                Text("Artist:")
                Text(viewModel.state.artistName)
                Spacer()
            }

            HStack(spacing: 4) {
                Text("Album:")
                Text(viewModel.state.albumName)
                Spacer()
            }

            ScrollView {
                ForEach(viewModel.state.tracks) { track in
                    HStack {
                        Text("\(track.trackNumber).")
                        Text(track.trackName)
                        Spacer()
                    }
                }
            }
        }
        .padding()
    }
}
