//
//  ContentView.swift
//  CellAsImageSizeSwiftUI
//
//  Created by Leewayhertz on 15/11/23.
//

import SwiftUI

struct URLImage: View {
    let urlString: String
    @State var data: Data?
    @State var imageSize: CGSize = .zero
    
    var body: some View {
        if let data = data, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: imageSize.width, height: imageSize.height)
        } else {
            Image("placHolder.svg")
                .background(Color.gray)
                .onAppear {
                    fetchImage()
                }
        }
    }
    
    private func fetchImage() {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                return
            }
            
            self.data = data
            if let contentType = httpResponse.allHeaderFields["Content-Type"] as? String,
               let imageData = UIImage(data: data),
               contentType.hasPrefix("image"),
               let image = imageData.cgImage {
                imageSize = CGSize(width: image.width, height: image.height)
                print(" Image Size is ::------->>>\(imageSize)")
            }
        }
        task.resume()
    }
}


struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(viewModel.myData, id: \.self) { imageUrl in
                URLImage(urlString: imageUrl)
            }
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
