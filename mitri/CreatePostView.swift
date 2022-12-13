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
    
    @State private var selectedPhotoPickerItems = [PhotosPickerItem]()
    @State private var selectedImagesData = [Data]()
    
    private var verticalDivider: some View = Divider().padding(.vertical, 8)
    
    var body: some View {
        VStack {
            TextField( text: $text, prompt: Text("Say something").promptText()) {
                Text("Text")
            }
            .onSubmit {
                newPost()
            }
            .autocorrectionDisabled()
            
            if selectedImagesData.count > 0 {
                TabView {
                    ForEach(selectedImagesData.indices, id: \.self) { idx in
                        if let uiImage = UIImage(data: selectedImagesData[idx]) {
                            ZStack(alignment: .topLeading) {
                                
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .imageViewHeight(imagesCount: selectedImagesData.count)
                                    .border(Color(white: 0.75))
                                    .clipped()
                                    .cornerRadius(4)
                                
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .opacity(0.8)
                                    .padding(6)
                                    .onTapGesture {
                                        self.selectedImagesData.remove(at: idx)
                                        self.selectedPhotoPickerItems.remove(at: idx)
                                    }
                                
                            }
                            .padding(.horizontal, 8)
                            .tag(idx)
                        }
                    }
                }
                .tabViewStyle(.page)
                .imageViewHeight(imagesCount: selectedImagesData.count)
                .aspectRatio(contentMode: .fill)
                .padding(.top, 16)
            }
            
            Spacer()
            verticalDivider
            HStack {
                PhotosPicker(selection: $selectedPhotoPickerItems, maxSelectionCount: 10, matching: .images) {
                    Image(systemName: "photo")
                }.onChange(of: selectedPhotoPickerItems) { newValues in
                    Task {
                        await saveDataForSelectedPhotos(newValues)
                    }
                }
            }
            .padding(.horizontal, 8)
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
                .disabled(text.count == 0 && selectedImagesData.count == 0)
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
    
    func saveDataForSelectedPhotos(_ photoPickerItems: [PhotosPickerItem]) async {
        var parsedImagesData = [Data]()
        for item in photoPickerItems {
            if let imageData = try? await item.loadTransferable(type: Data.self) {
                parsedImagesData.append(imageData)
            }
        }
        self.selectedImagesData = parsedImagesData
    }
    
    func newPost() {
        var uploads = [UploadableMediaContent]()
        if text.count > 0 {
            uploads.append(UploadableMediaContent(name: "text", data: Data(text.utf8)))
        }
        
        for index in selectedPhotoPickerItems.indices {
            let photoPickerItem = selectedPhotoPickerItems[index]
            let imageData = selectedImagesData[index]
            
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
