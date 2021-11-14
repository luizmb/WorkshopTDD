import API
import Combine
@testable import UI
import SwiftUI
import SnapshotTesting
import XCTest

final class SnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // isRecording = true
    }

    func testAlbumToViewState() {
        let viewStateAlbums = AlbumListViewModel.albumsViewState(from: expectedAlbumList)
        XCTAssertEqual(viewStateAlbums, expectedAlbumListViewState)
    }

    func testAlbumListViewModelOnAppear() {
        let sut = AlbumListViewModel(world: .mock)
        let waitForStateChangesCallback = expectation(description: "State changes callback should have been called")
        waitForStateChangesCallback.expectedFulfillmentCount = 2
        var stateChangesCount = 0

        let cancellable = sut.$state.sink { state in
            switch stateChangesCount {
            case 0:
                XCTAssertEqual(state, AlbumListViewModel.ViewState.empty)
            case 1:
                XCTAssertEqual(state, AlbumListViewModel.ViewState(albums: expectedAlbumListViewState, error: nil))
            default:
                XCTFail("Object Will Change was called more times than expected")
            }
            stateChangesCount += 1
            waitForStateChangesCallback.fulfill()
        }

        sut.send(event: .onAppear)

        wait(for: [waitForStateChangesCallback], timeout: 0.1)
        XCTAssertNotNil(cancellable)
    }

    func testAlbumListViewModelOnAppearPlaceholderImage() {
        let sut = AlbumListViewModel(world: .mock2, state: AlbumListViewModel.ViewState(albums: expectedAlbumListViewState, error: nil))
        let waitForStateChangesCallback = expectation(description: "State changes callback should have been called")
        waitForStateChangesCallback.expectedFulfillmentCount = 2
        var stateChangesCount = 0

        let cancellable = sut.$state.sink { state in
            switch stateChangesCount {
            case 0:
                XCTAssertEqual(state, AlbumListViewModel.ViewState(albums: expectedAlbumListViewState, error: nil))
            case 1:
                XCTAssertNil(state.albums[0].image)
                XCTAssertNil(state.albums[1].image)
                XCTAssertNotNil(state.albums[2].image)
                XCTAssertEqual(state.albums[2].image!.pngData()!, UIImage(data: someImage())!.pngData()!)
            default:
                XCTFail("Object Will Change was called more times than expected")
            }
            stateChangesCount += 1
            waitForStateChangesCallback.fulfill()
        }

        sut.send(event: .onAppearPlaceholderImage(albumId: "981156807"))

        wait(for: [waitForStateChangesCallback], timeout: 0.1)
        XCTAssertNotNil(cancellable)
    }

    func testViewWithThreeAlbums() {
        let vm = AlbumListViewModel(
            world: .mock2,
            state: AlbumListViewModel.ViewState(albums: expectedAlbumListViewState, error: nil)
        )
        let view = AlbumListView(viewModel: vm)
        let hostedView = UIHostingController(rootView: view)
        assertSnapshot(
            matching: hostedView,
            as: .image(on: .iPhoneSe)
        )
    }

    func testViewWithThreeAlbumsWithOneAlbumImage() {
        let vm = AlbumListViewModel(world: .mock2, state: AlbumListViewModel.ViewState(albums: expectedAlbumListViewState, error: nil))
        let view = AlbumListView(viewModel: vm)
        let hostedView = UIHostingController(rootView: view)

        let waitForStateChangesCallback = expectation(description: "State changes callback should have been called")
        waitForStateChangesCallback.expectedFulfillmentCount = 2

        let cancellable = vm.$state.sink { state in
            waitForStateChangesCallback.fulfill()
        }

        vm.send(event: .onAppearPlaceholderImage(albumId: "981156807"))

        wait(for: [waitForStateChangesCallback], timeout: 0.1)

        assertSnapshot(
            matching: hostedView,
            as: .image(on: .iPhoneSe)
        )

        XCTAssertNotNil(cancellable)
    }
}

extension World {
    static var mock: World {
        World(urlSession: URLSessionMock(fakeServiceDataReturned: validJson.data(using: .utf8)!), jsonDecoder: JSONDecoder())
    }

    static var mock2: World {
        World(urlSession: URLSessionMock(fakeServiceDataReturned: someImage()), jsonDecoder: JSONDecoder())
    }
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    func resume() { }
}

class URLSessionMock: URLSessionProtocol {
    let fakeServiceDataReturned: Data
    init(fakeServiceDataReturned: Data) {
        self.fakeServiceDataReturned = fakeServiceDataReturned
    }

    func request(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(fakeServiceDataReturned, nil, nil)
        return URLSessionDataTaskMock()
    }
}

func someImage(_ file: String = #file) -> Data {
    let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
    let fileName = fileUrl.deletingLastPathComponent().appendingPathComponent("128x128bb.jpeg")
    return FileManager.default.contents(atPath: fileName.path)!
}

let expectedAlbumListViewState = [
    AlbumListViewModel.ViewState.AlbumCellViewState(
        id: "1463706038",
        name: "We Are Not Your Kind",
        artist: "Slipknot",
        imageURL: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music123/v4/2b/4d/97/2b4d97a1-d445-c0f9-6f95-f602392ec362/016861741006.jpg/128x128bb.jpeg")!,
        image: nil,
        tracks: [
            .init(trackNumber: "1", trackName: "Insert Coin"),
            .init(trackNumber: "2", trackName: "Unsainted"),
            .init(trackNumber: "3", trackName: "Birth of the Cruel"),
            .init(trackNumber: "4", trackName: "Death Because of Death"),
            .init(trackNumber: "5", trackName: "Nero Forte"),
            .init(trackNumber: "6", trackName: "Critical Darling"),
            .init(trackNumber: "7", trackName: "A Liar's Funeral"),
            .init(trackNumber: "8", trackName: "Red Flag"),
            .init(trackNumber: "9", trackName: "What's Next"),
            .init(trackNumber: "10", trackName: "Spiders"),
            .init(trackNumber: "11", trackName: "Orphan"),
            .init(trackNumber: "12", trackName: "My Pain"),
            .init(trackNumber: "13", trackName: "Not Long for This World"),
            .init(trackNumber: "14", trackName: "Solway Firth")
        ]
    ),
    AlbumListViewModel.ViewState.AlbumCellViewState(
        id: "1440833237",
        name: "Metallica",
        artist: "Metallica",
        imageURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music118/v4/65/30/cd/6530cd17-9970-2af8-58eb-e994c0abf73c/00602547331366.rgb.jpg/128x128bb.jpeg")!,
        image: nil,
        tracks: [
            .init(trackNumber: "1", trackName: "Enter Sandman"),
            .init(trackNumber: "2", trackName: "Sad But True"),
            .init(trackNumber: "3", trackName: "Holier Than Thou"),
            .init(trackNumber: "4", trackName: "The Unforgiven"),
            .init(trackNumber: "5", trackName: "Wherever I May Roam"),
            .init(trackNumber: "6", trackName: "Don't Tread On Me"),
            .init(trackNumber: "7", trackName: "Through the Never"),
            .init(trackNumber: "8", trackName: "Nothing Else Matters"),
            .init(trackNumber: "9", trackName: "Of Wolf and Man"),
            .init(trackNumber: "10", trackName: "The God That Failed"),
            .init(trackNumber: "11", trackName: "My Friend of Misery"),
            .init(trackNumber: "12", trackName: "The Struggle Within")
        ]
    ),
    AlbumListViewModel.ViewState.AlbumCellViewState(
        id: "981156807",
        name: "Rock In Rio (Live)",
        artist: "Iron Maiden",
        imageURL: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music3/v4/ce/63/08/ce63083d-5342-312a-2611-dc9bd6ed72c9/825646128266.jpg//128x128bb.jpeg")!,
        image: nil,
        tracks: [
            .init(trackNumber: "1", trackName: "Intro (Arthur's Farewell) [Live '01]"),
            .init(trackNumber: "2", trackName: "The Wicker Man (Live '01)"),
            .init(trackNumber: "3", trackName: "Ghost of the Navigator (Live '01)"),
            .init(trackNumber: "4", trackName: "Brave New World (Live '01)"),
            .init(trackNumber: "5", trackName: "Wrathchild (Live '01)"),
            .init(trackNumber: "6", trackName: "2 Minutes To Midnight (Live '01)"),
            .init(trackNumber: "7", trackName: "Blood Brothers (Live '01)"),
            .init(trackNumber: "8", trackName: "Sign of the Cross (Live '01)"),
            .init(trackNumber: "9", trackName: "The Mercenary (Live '01)"),
            .init(trackNumber: "10", trackName: "The Trooper (Live '01)"),
            .init(trackNumber: "11", trackName: "Dream of Mirrors (Live '01)"),
            .init(trackNumber: "12", trackName: "The Clansman (Live '01)"),
            .init(trackNumber: "13", trackName: "The Evil That Men Do (Live '01)"),
            .init(trackNumber: "14", trackName: "Fear of the Dark (Live '01)"),
            .init(trackNumber: "15", trackName: "Iron Maiden (Live '01)"),
            .init(trackNumber: "16", trackName: "The Number of the Beast (Live '01)"),
            .init(trackNumber: "17", trackName: "Hallowed Be Thy Name (Live '01)"),
            .init(trackNumber: "18", trackName: "Sanctuary (Live '01)"),
            .init(trackNumber: "19", trackName: "Run To the Hills (Live '01)")
        ]
    )
]

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

let validJson =
"""
[
  {
    "album" : "We Are Not Your Kind",
    "artist" : "Slipknot",
    "cover" : "https://is5-ssl.mzstatic.com/image/thumb/Music123/v4/2b/4d/97/2b4d97a1-d445-c0f9-6f95-f602392ec362/016861741006.jpg/128x128bb.jpeg",
    "id" : "1463706038",
    "label" : "Roadrunner Records",
    "tracks" : [
      "Insert Coin",
      "Unsainted",
      "Birth of the Cruel",
      "Death Because of Death",
      "Nero Forte",
      "Critical Darling",
      "A Liar's Funeral",
      "Red Flag",
      "What's Next",
      "Spiders",
      "Orphan",
      "My Pain",
      "Not Long for This World",
      "Solway Firth"
    ],
    "year" : "2019"
  },
  {
    "album" : "Metallica",
    "artist" : "Metallica",
    "cover" : "https://is1-ssl.mzstatic.com/image/thumb/Music118/v4/65/30/cd/6530cd17-9970-2af8-58eb-e994c0abf73c/00602547331366.rgb.jpg/128x128bb.jpeg",
    "id" : "1440833237",
    "label" : "Virgin EMI",
    "tracks" : [
      "Enter Sandman",
      "Sad But True",
      "Holier Than Thou",
      "The Unforgiven",
      "Wherever I May Roam",
      "Don't Tread On Me",
      "Through the Never",
      "Nothing Else Matters",
      "Of Wolf and Man",
      "The God That Failed",
      "My Friend of Misery",
      "The Struggle Within"
    ],
    "year" : "1991"
  },
  {
    "album" : "Rock In Rio (Live)",
    "artist" : "Iron Maiden",
    "cover" : "https://is5-ssl.mzstatic.com/image/thumb/Music3/v4/ce/63/08/ce63083d-5342-312a-2611-dc9bd6ed72c9/825646128266.jpg//128x128bb.jpeg",
    "id" : "981156807",
    "label" : "Parlophone UK",
    "tracks" : [
      "Intro (Arthur's Farewell) [Live '01]",
      "The Wicker Man (Live '01)",
      "Ghost of the Navigator (Live '01)",
      "Brave New World (Live '01)",
      "Wrathchild (Live '01)",
      "2 Minutes To Midnight (Live '01)",
      "Blood Brothers (Live '01)",
      "Sign of the Cross (Live '01)",
      "The Mercenary (Live '01)",
      "The Trooper (Live '01)",
      "Dream of Mirrors (Live '01)",
      "The Clansman (Live '01)",
      "The Evil That Men Do (Live '01)",
      "Fear of the Dark (Live '01)",
      "Iron Maiden (Live '01)",
      "The Number of the Beast (Live '01)",
      "Hallowed Be Thy Name (Live '01)",
      "Sanctuary (Live '01)",
      "Run To the Hills (Live '01)"
    ],
    "year" : "2002"
  }
]
"""

let invalidJson =
"""
[
  {
    "album" : "We Are Not Your Kind",
  }
]
"""
