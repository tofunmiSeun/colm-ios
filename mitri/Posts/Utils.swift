//
//  Utils.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 13/12/2022.
//

import SwiftUI
import PhotosUI


struct PostUtils {
    static func createPostPayload(text: String, mediaContentSelection: MediaContentSelection) -> [UploadableMediaContent]  {
        
        let photoPickerItems = mediaContentSelection.selectedPhotoPickerItems
        let imageDataCollection = mediaContentSelection.selectedImagesData
        
        var uploads = [UploadableMediaContent]()
        
        if text.count > 0 {
            uploads.append(UploadableMediaContent(name: "text", data: Data(text.utf8)))
        }
        
        for index in photoPickerItems.indices {
            let photoPickerItem = photoPickerItems[index]
            let imageData = imageDataCollection[index]
            
            var mediaContent = UploadableMediaContent(name: "files", data: imageData)
            if photoPickerItem.supportedContentTypes.count > 0 {
                let imageInfo = photoPickerItem.supportedContentTypes[0]
                mediaContent.fileName = imageInfo.identifier
                if let mimeType = imageInfo.preferredMIMEType {
                    mediaContent.mimeType = mimeType
                }
            }
            
            uploads.append(mediaContent)
        }
        
        return uploads
    }
}
