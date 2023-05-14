//
//  UploadMediaContentMenu.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 13/12/2022.
//

import SwiftUI
import PhotosUI

struct UploadMediaContentMenu: View {
    
    @Binding var selectedPhotoPickerItems: [PhotosPickerItem]
    
    var body: some View {
        HStack(spacing: 6) {
            PhotosPicker(selection: $selectedPhotoPickerItems, maxSelectionCount: 5, matching: .images) {
                Image(systemName: "photo")
            }.onChange(of: selectedPhotoPickerItems) { newValues in
                self.selectedPhotoPickerItems = newValues
            }
        }
    }
}

struct UploadMediaContentMenu_Previews: PreviewProvider {
    static var previews: some View {
        UploadMediaContentMenu(selectedPhotoPickerItems: .constant([PhotosPickerItem]()))
    }
}
