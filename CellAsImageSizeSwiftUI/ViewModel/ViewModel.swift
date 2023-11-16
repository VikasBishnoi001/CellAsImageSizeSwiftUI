//
//  ViewModel.swift
//  CellAsImageSizeSwiftUI
//
//  Created by Leewayhertz on 15/11/23.
//

import Foundation

import SwiftUI

class ViewModel: ObservableObject {
    @Published var myData: [String] = []
    let url = "https://dog.ceo/api/breed/hound/images"
     
    func fetchData() {
            if let url = URL(string: url) {
                let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                    guard let self = self, let data = data, error == nil else {
                        print("Error Occurred While Accessing Data")
                        return
                    }
                    do {
                        let decodedData = try JSONDecoder().decode(DogData.self, from: data)
                        self.myData = decodedData.message
                    } catch {
                        print("Error While Decoding JSON into Swift Structure \(error)")
                    }
                }
                task.resume()
            } else {
                print("Invalid URL")
            }
        }

}
