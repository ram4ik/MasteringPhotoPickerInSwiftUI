//
//  ContentView.swift
//  MasteringPhotoPickerInSwiftUI
//
//  Created by test on 7/18/24.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var photos: [Image] = []
    
    var body: some View {
        VStack {
            PhotosPicker("Select a photo",
                         selection: $selectedItems,
                         maxSelectionCount: 3,
                         selectionBehavior: .continuousAndOrdered,
                         matching: .images)
                .photosPickerStyle(.inline)
                .frame(height: 300)
            
            Spacer()
            
            if photos.count > 0 {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(0..<photos.count, id: \.self) { idx in
                            photos[idx]
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 20))
                                .frame(width: 300, height: 300)
                                .shadow(radius: 5)
                        }
                    }
                }
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
        .onChange(of: selectedItems ) { _, newValues in
            photos.removeAll()
            
            newValues.forEach { selectedItem in
                Task {
                    if let loadedImageData  = try? await selectedItem.loadTransferable(type: Data.self), let uiImage = UIImage(data: loadedImageData) {
                        photos.append(Image(uiImage: uiImage))
                    } else {
                        print("Failed to load image")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
