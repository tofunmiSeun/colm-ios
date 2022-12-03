//
//  CreatePostView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 02/12/2022.
//

import SwiftUI

struct CreatePostView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var text = ""
    
    private var prompt = Text("Say something").font(.title2)
    
    var body: some View {
        VStack {
            TextField( text: $text, prompt: prompt) {
                Text("Text")
            }
            .onSubmit {
                newPost()
            }
            .autocorrectionDisabled()
            Spacer()
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
                .disabled(text.count == 0)
                .buttonStyle(.borderedProminent)
                .cornerRadius(16)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.mode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
    
    func newPost() {
        Api.post(uri: "/post?profileId=\(loggedInUser.profileId)", body: ["content": text]) { data in
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
