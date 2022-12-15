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
                TextField(text: $replyText, prompt: Text("Reply post").promptText()) {
                    Text("Text")
                }
                .autocorrectionDisabled()
            }
            
            if mediaContentSelection.mediaContentsHaveBeenSelected() {
                ImagesToUploadCarousel(selectedPhotoPickerItems: $mediaContentSelection.selectedPhotoPickerItems ,
                                       selectedImagesData: $mediaContentSelection.selectedImagesData)
            }
            
            HStack {
                UploadMediaContentMenu(selectedPhotoPickerItems: $mediaContentSelection.selectedPhotoPickerItems)
                    .onReceive(mediaContentSelection.$selectedPhotoPickerItems) { newValue in
                        Task {
                            mediaContentSelection.selectedImagesData =  await mediaContentSelection.saveDataForSelectedPhotos(newValue)
                        }
                    }
                
                Spacer()
                
                Button {
                    replyToPost()
                } label: {
                    Text("Send")
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(16)
                .font(.subheadline)
                .disabled(replyText.count == 0 && !mediaContentSelection.mediaContentsHaveBeenSelected())
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
