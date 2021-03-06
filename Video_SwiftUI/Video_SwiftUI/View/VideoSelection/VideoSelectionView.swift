//
//  VideoFilingView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI
import AVKit
import Photos

struct VideoSelectionView: View {
    static let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 5, alignment: .center), count: 3)
    enum DisplayMode {
        case library
        case filming
    }
    @StateObject private var viewModel = VideoSelectionViewModel()
    @State var cameraRecordingStatus: RecordingStatus = .ready
    @State var isPushActive = false
    @State var destinationView: AnyView? = nil
    @State var showAlertToSetting = false
    @Binding var isPresented: Bool
    var body: some View {
        ZStack {
            NavigationLink(destination: destinationView, isActive: $isPushActive) {
                EmptyView()
            }
            switch viewModel.displayMode {
            case .library:
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: VideoSelectionView.columns, alignment: .center, spacing: 5) {
                        
                        ForEach(0..<viewModel.phAssetImages.count, id: \.self) { index in
                            Button {
                                Task {
                                    do {
                                        let videoURL = try await viewModel.getVideoURL(selectedIndex: index)
                                        guard let videoURL = videoURL else { return }
                                        self.destinationView = AnyView(VideoEditingView(url: videoURL, sourceType: .library))
                                        self.isPushActive = true
                                    } catch {
                                        
                                    }
                                }
                            } label: {
                                Image(uiImage: viewModel.phAssetImages[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }.padding(EdgeInsets(top: 5, leading: 10, bottom: 89, trailing: 10))
                }
            case .filming:
                CameraView(recordingStatus: $cameraRecordingStatus) { outputFileURL in
                    self.destinationView = AnyView(VideoEditingView(url: outputFileURL, sourceType: .filming))
                    self.isPushActive = true
                    cameraRecordingStatus = .ready
                }
                
            }
            if viewModel.isEditing {
                Color.black.opacity(0.3).frame(minWidth: 300,maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                    .onTapGesture {
                        withAnimation {
                            viewModel.isEditing = false
                        }
                    }
            }
            Button {
                viewModel.displayMode = .library
                withAnimation {
                    viewModel.isEditing = false
                }
            } label: {
                Image(systemName: "photo")
                    .frame(width: 44, height: 44)
                    .foregroundColor(Color.dominantColor)
            }.background(Color.white)
                .cornerRadius(22)
                .offset(x: getEditButtonOriginX(), y: viewModel.isEditing ? getEditButtonOriginY() - 118 : getEditButtonOriginY())
            
            Button {
                viewModel.displayMode = .filming
                withAnimation {
                    viewModel.isEditing = false
                }
            } label: {
                Image(systemName: "camera")
                    .frame(width: 44, height: 44)
                    .foregroundColor(Color.dominantColor)
            }
            .background(Color.white)
            .cornerRadius(22)
            .offset(x: getEditButtonOriginX(), y: viewModel.isEditing ? getEditButtonOriginY() - 59 : getEditButtonOriginY())
            
            
            Button {
                withAnimation {
                    viewModel.isEditing.toggle()
                }
            } label: {
                Image(systemName: viewModel.isEditing ? "xmark" :  "arrow.up.arrow.down")
                    .frame(width: 44, height: 44)
                    .foregroundColor(Color.dominantColor)
            }
            .background(Color.white)
            .cornerRadius(22)
            .shadow(color: Color.black, radius: 22, x: 0, y: 0)
            .offset(x: getEditButtonOriginX(), y: getEditButtonOriginY())
        }
        .alert(isPresented: $showAlertToSetting ) {
            Alert(title: Text("???????????????????????????????????????????????????????????????????????????????????????"),
                  primaryButton: Alert.Button.default(Text("??????"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }),
                  secondaryButton: Alert.Button.cancel({
                self.isPresented = false
            })
                        )
        }
        .onAppear {
            Task {
                let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
                switch status {
                case .authorized, .limited:
                    PHPhotoLibrary.shared().register(viewModel)
                    Task {
                        await viewModel.fetchPHAsset()
                    }
                case .notDetermined:
                    break
                default:
                    DispatchQueue.main.async {
                        self.showAlertToSetting = true
                    }
                }
            }
        }
        .onDisappear {
            PHPhotoLibrary.shared().unregisterChangeObserver(viewModel)
        }
        .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(
                getNavigationTitle()
            )
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.dominantColor)
            })
            )
    }
    
    private func getNavigationTitle() -> Text {
        switch viewModel.displayMode {
        case .library:
            return Text("???????????????")
        case .filming:
            return Text("??????")
        }
    }
    
    private func getEditButtonOriginX() -> CGFloat {
        let safeArea = UIApplication.getSafeArea()
        return (UIScreen.main.bounds.width - safeArea.left - safeArea.right) / 2 - 42
    }
    
    private func getEditButtonOriginY() -> CGFloat {
        let safeArea = UIApplication.getSafeArea()
        return (UIScreen.main.bounds.height - 44 - safeArea.top - safeArea.bottom) / 2 - 42
    }
}

struct VideoSelection_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        VideoSelectionView(isPresented: VideoSelection_Previews.$isPresented)
    }
}
