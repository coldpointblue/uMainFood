//  ----------------------------------------------------
//
//  AsyncImageView.swift
//  Version 1.0
//
//  Unique ID:  26831DE3-A5AE-4A0B-8C9C-F5599EDB735F
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-23.
//  
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  Image view that loads as needed   */
//  ----------------------------------------------------


import SwiftUI

struct AsyncImageView: View {
    @StateObject private var loader = LazyImageLoader()
    let urlString: String
    var placeholder: UIImage
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else if loader.isError {
                Image(uiImage: placeholder)
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loader.loadImageIfNeeded(from: urlString)
        }
    }
}
