import XCTest
@testable import API

final class APITests: XCTestCase {
    func testDecodingValidJson() throws {
        let validJsonData = validJson.data(using: .utf8)!
        do {
            let model = try JSONDecoder().decode([Album].self, from: validJsonData)
            XCTAssertEqual(model, expectedAlbumList)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testDecodingInvalidJson() throws {
        let invalidJsonData = invalidJson.data(using: .utf8)!
        do {
            _ = try JSONDecoder().decode([Album].self, from: invalidJsonData)
            XCTFail("This decoding was supposed to fail!")
        } catch {
            XCTAssert(error is DecodingError)
        }
    }

    func testServiceFetchAllAlbums() {
        let musicBrowser = MusicBrowserService(urlSession: URLSessionMock(fakeServiceDataReturned: validJson.data(using: .utf8)!), jsonDecoder: JSONDecoder())
        let waitForTheCallback = expectation(description: "the fetchAllAlbums callback should have been executed")

        musicBrowser.fetchAllAlbums(completionHandler: { result in
            let albums = try! result.get()
            XCTAssertEqual(albums, expectedAlbumList)
            waitForTheCallback.fulfill()
        })

        wait(for: [waitForTheCallback], timeout: 0)
    }

    func testServiceFetchAlbumImage() {
        let musicBrowser = MusicBrowserService(urlSession: URLSessionMock(fakeServiceDataReturned: Data([0x00, 0x01, 0x02, 0x03, 0x05, 0x08, 0x13])), jsonDecoder: JSONDecoder())
        let waitForTheCallback = expectation(description: "the fetchAlbumImage callback should have been executed")
        let fakeURL = URL(string: "https://google.com")!

        musicBrowser.fetchAlbumImage(from: fakeURL, completionHandler: { result in
            let imageData = try! result.get()
            XCTAssertEqual(imageData, Data([0x00, 0x01, 0x02, 0x03, 0x05, 0x08, 0x13]))
            waitForTheCallback.fulfill()
        })

        wait(for: [waitForTheCallback], timeout: 0)
    }
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    func resume() { }
}
//class URLSessionMock: URLSessionProtocol {
//    init() { }
//    func request(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
//        completionHandler(validJson.data(using: .utf8), nil, nil)
//        return URLSessionDataTaskMock()
//    }
//}

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
