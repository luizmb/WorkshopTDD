import XCTest
@testable import Introduction

final class IntroductionTests: XCTestCase {
    func testDivideIntegers() {
        let result = divide(6, divisor: 2)
        XCTAssertEqual(result, 3)
    }

    func testDivideResultFraction() {
        let result = divide(9, divisor: 2)
        XCTAssertEqual(result, 4.5)
    }

    func testDivideFractions() {
        let result = divide(6.51, divisor: 2.1)
        XCTAssertEqual(result, 3.1, accuracy: 0.000000001)
    }

    func testGreetings() {
        let greetingsResult = greetings(name: "Luiz")
        XCTAssertEqual(greetingsResult, "Olá, Luiz")
    }

    func testFullGreeting() {
        let fullGreetingsResult = fullGreetings(name: "Luiz")
        XCTAssertEqual(fullGreetingsResult, "Bom dia, Luiz")
    }

    func testFullGreetingsMidnight() {
        let date = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: 2021,
            month: 02,
            day: 27,
            hour: 00,
            minute: 00,
            second: 00,
            nanosecond: 00
        ).date!

        let fullGreetingsResult = fullGreetings(name: "Luiz", date: date, calendar: .current)
        XCTAssertEqual(fullGreetingsResult, "Bom dia, Luiz")
    }

    func testFullGreetingsAlmostLunch() {
        let date = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: 2021,
            month: 02,
            day: 27,
            hour: 11,
            minute: 59,
            second: 59,
            nanosecond: 00
        ).date!

        let fullGreetingsResult = fullGreetings(name: "Luiz", date: date, calendar: .current)
        XCTAssertEqual(fullGreetingsResult, "Bom dia, Luiz")
    }

    func testFullGreetingsLunchTime() {
        let date = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: 2021,
            month: 02,
            day: 27,
            hour: 12,
            minute: 00,
            second: 00,
            nanosecond: 00
        ).date!

        let fullGreetingsResult = fullGreetings(name: "Luiz", date: date, calendar: .current)
        XCTAssertEqual(fullGreetingsResult, "Boa tarde, Luiz")
    }

    func testFullGreetingsAlmost18() {
        let date = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: 2021,
            month: 02,
            day: 27,
            hour: 17,
            minute: 59,
            second: 59,
            nanosecond: 00
        ).date!

        let fullGreetingsResult = fullGreetings(name: "Luiz", date: date, calendar: .current)
        XCTAssertEqual(fullGreetingsResult, "Boa tarde, Luiz")
    }

    func testFullGreetings18() {
        let date = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: 2021,
            month: 02,
            day: 27,
            hour: 18,
            minute: 00,
            second: 00,
            nanosecond: 00
        ).date!

        let fullGreetingsResult = fullGreetings(name: "Luiz", date: date, calendar: .current)
        XCTAssertEqual(fullGreetingsResult, "Boa noite, Luiz")
    }

    func testFullGreetingsAlmostMidnight() {
        let date = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: 2021,
            month: 02,
            day: 27,
            hour: 23,
            minute: 59,
            second: 59,
            nanosecond: 00
        ).date!

        let fullGreetingsResult = fullGreetings(name: "Luiz", date: date, calendar: .current)
        XCTAssertEqual(fullGreetingsResult, "Boa noite, Luiz")
    }
}
