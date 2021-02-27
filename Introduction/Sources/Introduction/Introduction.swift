import Foundation

func divide(_ number: Double, divisor: Double) -> Double {
    number / divisor
}

func greetings(name: String) -> String {
    "Olá, \(name)"
}

func fullGreetings(name: String) -> String {
    let now = Date()
    let hour = Calendar.current.component(.hour, from: now)
    switch hour {
    case 0..<12: return "Bom dia, \(name)"
    case 12..<18: return "Boa tarde, \(name)"
    default: return "Boa noite, \(name)"
    }
}

func fullGreetings(name: String, date: Date, calendar: Calendar) -> String {
    let hour = calendar.component(.hour, from: date)
    switch hour {
    case 0..<12: return "Bom dia, \(name)"
    case 12..<18: return "Boa tarde, \(name)"
    default: return "Boa noite, \(name)"
    }
}

// Side-effects:
// - Date
// - Random Numbers
// - Access to internet
// - Access to disk / User Defaults / database
// - Anything async
// - device sensors, radios (NFC, Bluetooth, device orientation)
// - Notifications (APNS, local, NotificationCenter)
// - most singletons (URLSession.shared, FileManager.default, UserDefaults.standard, NotificationCenter.default)
// - Resources (images, audio, video, text files)
// - Crashes, errors
