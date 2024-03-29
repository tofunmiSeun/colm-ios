//
//  PostReplyView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 13/12/2022.
//

import SwiftUI
import PhotosUI

struct PostReplyView: View {
    let postId: String
    let profileId: String
    var refreshReplies: () -> Void
    
    @State private var replyText = ""
    @ObservedObject var mediaContentSelection = MediaContentSelection()
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                UploadMediaContentMenu(selectedPhotoPickerItems: $mediaContentSelection.selectedPhotoPickerItems)
                    .onReceive(mediaContentSelection.$selectedPhotoPickerItems) { newValue in
                        Task {
                            mediaContentSelection.selectedImagesData =  await mediaContentSelection.saveDataForSelectedPhotos(newValue)
                        }
                    }
                
                TextField(text: $replyText) {
                    Text("Reply post")
                }
                .appTextFieldStyle()
                
                Button {
                    replyToPost()
                } label: {
                    Text("Send")
                }
                .appButtonStyle()
                .disabled(replyText.count == 0 && !mediaContentSelection.mediaContentsHaveBeenSelected())
            }
            
            if mediaContentSelection.mediaContentsHaveBeenSelected() {
                ImagesToUploadCarousel(selectedPhotoPickerItems: $mediaContentSelection.selectedPhotoPickerItems ,
                                       selectedImagesData: $mediaContentSelection.selectedImagesData)
            }
        }
    }
    
    func replyToPost() {
        let uploads = PostUtils.createPostPayload(text: replyText, mediaContentSelection: mediaContentSelection)
        let uri = "/post/\(postId)/reply?profileId=\(profileId)"
        Api.upload(uri: uri, uploads: uploads) { data in
            DispatchQueue.main.async {
                replyText = ""
                mediaContentSelection.clear()
                refreshReplies()
            }
        }
    }
}

struct PostReplyView_Previews: PreviewProvider {
    static var previews: some View {
        PostReplyView(postId: "aaa", profileId: "id_1ee", refreshReplies: {return})
    }
}
