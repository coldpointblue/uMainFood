/*  Goal explanation:  Image view that loads as needed   */


import SwiftUI

struct AsyncImageView: View {
    @StateObject private var loader = LazyImageLoader(networkService: NetworkService.shared)
    
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
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loader.loadImageIfNeeded(from: urlString)
        }
    }
}
