//
//  ContentView.swift
//  MasteringPhotoPickerInSwiftUI
//
//  Created by test on 7/18/24.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var photo: Image?
    
    var body: some View {
        VStack {
            PhotosPicker("Select a photo", selection: $selectedItem, matching: .images)
                .photosPickerStyle(.compact)
                .frame(height: 300)
            
            Spacer()
            
            if let photo {
                photo
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 20))
                    .frame(width: 300, height: 300)
                    .shadow(radius: 5)
            } else {
                ContentUnavailableView("Get started by selecting a photo from above",  systemImage: "photo")
                    .frame(height: 300)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.gray, lineWidth: 2)
                            .shadow(radius: 5)
                    )
                    .frame(width: 300, height: 300)
            }
        }
        .onChange(of: selectedItem) { _, _ in
            Task {
                if let loadedImageData  = try? await selectedItem?.loadTransferable(type: Data.self), let uiImage = UIImage(data: loadedImageData) {
                    photo = Image(uiImage: uiImage)
                } else {
                    print("Failed to load image")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
