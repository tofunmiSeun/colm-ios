//
//  MediaContentSelection.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 14/12/2022.
//

import Foundation
import SwiftUI
import PhotosUI

class MediaContentSelection: ObservableObject {
    @Published var selectedPhotoPickerItems = [PhotosPickerItem]()
    @Published var selectedImagesData = [Data]()
    
    func saveDataForSelectedPhotos(_ photoPickerItems: [PhotosPickerItem]) async -> [Data] {
        var parsedImagesData = [Data]()
        for item in photoPickerItems {
            if let imageData = try? await item.loadTransferable(type: Data.self) {
                parsedImagesData.append(imageData)
            }
        }
        return parsedImagesData
    }
    
    func mediaContentsHaveBeenSelected() -> Bool {
        return self.selectedImagesData.count > 0 &&
        self.selectedPhotoPickerItems.count > 0;
    }
    
    func clear() {
        selectedPhotoPickerItems = [PhotosPickerItem]()
        selectedImagesData = [Data]()
    }
}
