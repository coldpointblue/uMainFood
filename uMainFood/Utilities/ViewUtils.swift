//  ----------------------------------------------------
//
//  ViewUtils.swift
//  Version 1.0
//
//  Unique ID:  ED44EB65-7F49-47F1-AAC2-0AB5904565A0
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-19.
//
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  Utilities to enhance views   */
//  ----------------------------------------------------


import SwiftUI

// Extension to round the top corners of a view
extension View {
    func roundTopCorners() -> some View {
        let radius: CGFloat = 20
        
        return clipShape(
            .rect(
                topLeadingRadius: radius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: radius
            )
        )
    }
}

// Color constants
extension Color {
    static let grayDarkerShade = Color.gray.opacity(0.2)
    static let grayLightShadeColor = Color(red: 248/255, green: 248/255, blue: 248/255)
    static let grayPlaceholderShadeColor = Color(red: 161/255, green: 161/255, blue: 161/255)
    
    static let darkText = Color("RCDarkText")
    static let lightText = Color("RCLightText")
    static let subtitle = Color("RCSubtitle")
    static let background = Color("RCBackground")
    static let selected = Color("RCSelected")
    static let positive = Color("RCPositive")
    static let negative = Color("RCNegative")
}

// Reusable card background style
extension View {
    func cardBackgroundStyle() -> some View {
        self.modifier(BackgroundStyleModifier())
    }
}

private struct BackgroundStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .shadow(color: .grayDarkerShade, radius: 2, x: 0, y: 5)
            .padding(.horizontal, 1)
    }
}

// MARK: - Time Formatting
struct TimeIntoWordsFormatter {
    static func format(minutes: Int) -> String {
        switch max(0, minutes) {
        case 0:
            return localizedStringForKey("here_now")
        case 1:
            return localizedStringForKey("single_minute_format")
        case 2..<60:
            return localizedPluralKey("minutes_format", count: minutes)
        default:
            return formatHoursAndMinutes(from: minutes)
        }
    }
    
    /// Formats a given duration greater than 59 minutes into a human-readable string representing hours and, optionally, minutes.
    ///
    /// Calculates hours and minutes from the total duration provided in minutes. It then formats
    /// these into a localized string for display. If the duration includes only hours (with zero minutes),
    /// only the hour part is returned. If there are additional minutes, they are included in the formatted output.
    ///
    /// - Parameter minutesCounted: The duration in minutes to be formatted.
    /// - Returns: A string formatted to include hours and, if applicable, minutes. The output is localized
    ///            and adheres to the current locale's conventions for representing time durations.
    ///
    /// Example output:
    /// - For 61 minutes, the output could be "1 hour 1 minute" assuming the locale formats it this way.
    /// - For 120 minutes, the output would be "2 hours".
    private static func formatHoursAndMinutes(from minutesCounted: Int) -> String {
        let minutes = max(0, minutesCounted)
        let hours = minutes / 60
        let remainderMinutes = minutes % 60
        
        let hourString = hours == 1 ?
        localizedStringForKey("single_hour_format") :
        localizedPluralKey("hours_format", count: hours)
        
        guard remainderMinutes > 0 else { return hourString }
        
        let minuteString = remainderMinutes == 1 ?
        localizedStringForKey("single_minute_format") :
        localizedPluralKey("minutes_format", count: remainderMinutes)
        
        return "\(hourString) \(minuteString)"
    }
    
    private static func localizedPluralKey(_ key: String, count: Int) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, count)
    }
    
    private static func localizedStringForKey(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}

extension View {
    func userAlert(item: Binding<UserNotification?>) -> some View {
        self.alert(item: item) { notification in
            Alert(
                title: Text(notification.title),
                message: Text(notification.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
