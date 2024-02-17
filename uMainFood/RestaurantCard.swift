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
}

struct RestaurantCard: View {
    var body: some View {
        ZStack {
            Color(AppConstants.grayLightShadeColor)
            VStack(spacing: 0) {
                FoodImageView(imageName: "wanted_image_name")
                    .roundTopCorners()
                Overview(rating: 5.0)
            }
            .frame(width: AppConstants.picSize.width)
            .aspectRatio(AppConstants.picSize.width / AppConstants.picSize.height, contentMode: .fit)
        }
    }
}

// Image view with conditional loading
struct FoodImageView: View {
    let imageName: String
    
    var body: some View {
        Group {
            if let image = UIImage(named: imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(AppConstants.picSize, contentMode: .fill)
                    .clipped()
            } else {
                placeholderImage
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

// Overview view with dynamic rating display
struct Overview: View {
    let rating: Double
    private let grayDarkerShade = Color.gray.opacity(0.2)
    private let grayLightShadeColor = Color.gray.opacity(0.7706)
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .shadow(color: grayDarkerShade, radius: 2, x: 0, y: 5)
                .padding(.horizontal, 1)
            
            content
                .padding(.horizontal, AppConstants.overViewPadding)
        }
    }
    
    private var content: some View {
        VStack {
            headline
            tags
            deliveryEstimate
        }
    }
    
    private var headline: some View {
        HStack {
            Text("Title")
                .font(.title)
            Spacer()
            ratingView
        }
    }
    
    private var tags: some View {
        HStack {
            Text("Tag • Tag • Tag")
                .foregroundColor(grayLightShadeColor)
                .font(.subheadline)
                .fontWeight(.heavy)
            Spacer()
        }
    }
    
    private var deliveryEstimate: some View {
        HStack {
            Image(systemName: "clock")
                .scaleEffect(x: -1, y: 1)
                .foregroundColor(.red)
            Text("30 mins")
            Spacer()
        }
        .font(.footnote)
    }
    
    private var ratingView: some View {
        Group {
            Text("★").foregroundColor(.yellow)
            Text(String(format: "%.1f", max(0, min(rating, 5.0))))
                .bold()
                .padding(.trailing)
        }
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
