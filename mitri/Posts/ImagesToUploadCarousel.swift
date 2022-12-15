//
//  ImagesToUploadCarousel.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 14/12/2022.
//

import SwiftUI
import PhotosUI

struct ImagesToUploadCarousel: View {
    
    @Binding var selectedPhotoPickerItems: [PhotosPickerItem]
    @Binding var selectedImagesData: [Data]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(selectedImagesData.indices, id: \.self) { idx in
                    let data = selectedImagesData[idx]
                    if let uiImage = UIImage(data: data) {
                        ZStack(alignment: .topLeading) {
                            
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .imageViewHeight()
                                .border(Color(white: 0.75))
                                .clipped()
                                .cornerRadius(4)
                            
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .opacity(0.8)
                                .padding(6)
                                .onTapGesture {
                                    self.selectedPhotoPickerItems.remove(at: idx)
                                }
                        }
                    }
                }
            }
        }
    }
}

struct ImagesToUploadCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ImagesToUploadCarousel(selectedPhotoPickerItems: .constant([PhotosPickerItem]()), selectedImagesData: .constant([Data]()))
    }
}
