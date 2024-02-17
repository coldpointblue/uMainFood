//  ----------------------------------------------------
//
//  RestaurantCard.swift
//  Version 1.0
//
//  Unique ID:  968BD13F-A39A-4F94-BC9A-6EA3410EDA99
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-17.
//
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  Renders the Restaurant Card overview info   */
//  ----------------------------------------------------


import SwiftUI

// Constants for simpler updates
struct AppConstants {
    static let picSize = CGSize(width: 375, height: 220)
    static let grayLightShadeColor = Color(red: 248/255, green: 248/255, blue: 248/255)
    static let overViewPadding: CGFloat = 8
    static let grayPlaceholderShadeColor = Color(red: 161/255, green: 161/255, blue: 161/255)
    static let grayDarkerShade = Color.gray.opacity(0.2)
    static let grayTagShadeColor = Color.gray.opacity(0.7706)
}

struct RestaurantCard: View {
    var body: some View {
        ZStack {
            Color(AppConstants.grayLightShadeColor)
            VStack(spacing: 0) {
                FoodImageView(imageName: "wanted_image_name")
                    .roundTopCorners()
                Overview(rating: 5, deliveryTimeInMinutes: 121, activeTags: ["Tag", "Tag", "Tag"], title: "Title")
            }
            .frame(width: AppConstants.picSize.width)
            .aspectRatio(AppConstants.picSize.width / AppConstants.picSize.height, contentMode: .fit)
        }
    }
}

// Image view with conditional loading
private struct FoodImageView: View {
    let imageName: String
    @State private var showErrorImage = false
    
    var body: some View {
        Group {
            if let image = UIImage(named: imageName), !showErrorImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(AppConstants.picSize, contentMode: .fill)
                    .clipped()
            } else {
                placeholderImage
            }
        }
        .onAppear {
            if UIImage(named: imageName) == nil {
                showErrorImage = true
            }
        }
        .frame(width: AppConstants.picSize.width, height: AppConstants.picSize.height)
    }
    
    private var placeholderImage: some View {
        ZStack {
            Color.red.opacity(0.09)
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .padding(40)
                .foregroundColor(AppConstants.grayPlaceholderShadeColor)
                .frame(width: AppConstants.picSize.width, height: AppConstants.picSize.height)
                .font(.system(size: 100))
        }
    }
}

// Overview view with dynamic display
private struct Overview: View {
    let rating: Double
    let deliveryTimeInMinutes: Int
    let activeTags: [String]
    let title: String
    
    // Default parameter values
    init(rating: Double = 5.0,
         deliveryTimeInMinutes: Int = 30,
         activeTags: [String] = ["Tag", "Tag", "Tag"],
         title: String = "Title") {
        self.rating = rating
        self.deliveryTimeInMinutes = deliveryTimeInMinutes
        self.activeTags = activeTags
        self.title = title
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .shadow(color: AppConstants.grayDarkerShade, radius: 2, x: 0, y: 5)
                .padding(.horizontal, 1)
            
            content
                .padding(.horizontal, AppConstants.overViewPadding)
        }
    }
    
    private var content: some View {
        VStack {
            HeadlineView(title: title, rating: rating)
            TagsView(activeTags: activeTags)
            DeliveryEstimateView(minutes: deliveryTimeInMinutes)
        }
    }
}

// MARK: - Reusable Components
struct HeadlineView: View {
    let title: String
    let rating: Double
    
    var body: some View {
        HStack {
            Text(title).font(.title)
            Spacer()
            RatingView(rating: rating)
        }
    }
}

struct RatingView: View {
    let rating: Double
    
    var body: some View {
        HStack {
            Text("★").foregroundColor(.yellow)
            Text(String(format: "%.1f", max(0, min(rating, 5.0))))
                .bold()
                .padding(.trailing)
        }
    }
}

struct TagsView: View {
    let activeTags: [String]
    
    var body: some View {
        HStack {
            Text(activeTags.joined(separator: " • "))
                .foregroundColor(AppConstants.grayTagShadeColor)
                .font(.subheadline)
                .fontWeight(.heavy)
            Spacer()
        }
    }
}

// Extension to round the top corners of a view
struct DeliveryEstimateView: View {
    let minutes: Int
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .scaleEffect(x: -1, y: 1)
                .foregroundColor(.red)
            Text(TimeFormatter.format(minutes: minutes))
            Spacer()
        }
        .font(.footnote)
    }
}

// MARK: - Time Formatting
private struct TimeFormatter {
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

// Extension to round the top corners of a view
extension View {
    func roundTopCorners() -> some View {
        clipShape(
            .rect(
                topLeadingRadius: 20,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 20
            )
        )
    }
}

struct CustomAppView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCard()
    }
}

