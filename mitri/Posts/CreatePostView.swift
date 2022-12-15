//
//  CreatePostView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 02/12/2022.
//

import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var text = ""
    @ObservedObject var mediaContentSelection = MediaContentSelection()
    
    private var verticalDivider: some View = Divider().padding(.vertical, 8)
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField( text: $text, prompt: Text("Say something").promptText()) {
                Text("Text")
            }
            .autocorrectionDisabled()
            
            if mediaContentSelection.mediaContentsHaveBeenSelected() {
                ImagesToUploadCarousel(selectedPhotoPickerItems: $mediaContentSelection.selectedPhotoPickerItems ,
                                       selectedImagesData: $mediaContentSelection.selectedImagesData)
            }
            
            Spacer()
            verticalDivider
            UploadMediaContentMenu(selectedPhotoPickerItems: $mediaContentSelection.selectedPhotoPickerItems)
                .onReceive(mediaContentSelection.$selectedPhotoPickerItems) { newValue in
                    Task {
                        mediaContentSelection.selectedImagesData =  await mediaContentSelection.saveDataForSelectedPhotos(newValue)
                    }
                }
        }
        .padding()
        .navigationTitle("Create post")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    newPost()
                } label: {
                    Text("Post")
                }
                .disabled(text.count == 0 && !mediaContentSelection.mediaContentsHaveBeenSelected())
                .buttonStyle(.borderedProminent)
                .cornerRadius(16)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.mode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark").foregroundColor(.primary)
                }
            }
        }
    }
    
    func newPost() {
        let uploads = PostUtils.createPostPayload(text: text, mediaContentSelection: mediaContentSelection)
        
        Api.upload(uri: "/post/create?profileId=\(loggedInUser.profileId)",
                   uploads: uploads) { data in
            DispatchQueue.main.async {
                self.mode.wrappedValue.dismiss()
            }
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreatePostView()
        }
    }
}
