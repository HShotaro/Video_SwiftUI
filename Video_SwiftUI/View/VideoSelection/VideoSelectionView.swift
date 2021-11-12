//
//  VideoFilingView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI
import AVKit

struct VideoSelectionView: View {
    static let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 5, alignment: .center), count: 1)
    enum DisplayMode {
    case library
    case filming
    }
    @StateObject private var viewModel = VideoSelectionViewModel()
    @State var cameraRecordingStatus: RecordingStatus = .ready
    @State var isPushActive = false
    @State var destinationView: AnyView? = nil
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
                        ForEach(viewModel.photoPickerModels, id: \.id) { photoPickerModel in
                            Button {
                                if let url = photoPickerModel.url {
                                    self.destinationView = AnyView(VideoEditingView(url: url))
                                    self.isPushActive = true
                                }
                            } label: {
                                switch photoPickerModel.mediaType {
                                case .video:
                                    if let url = photoPickerModel.url {
                                        VideoPlayer(player: AVPlayer(url: url))
                                            .frame(minHeight: 220)
                                    } else {
                                        EmptyView()
                                    }
                                case .livePhoto, .photo:
                                    EmptyView()
                                }
                            }
                        }
                    }.padding(EdgeInsets(top: 5, leading: 5, bottom: 89, trailing: 5))
                }
            case .filming:
                CameraView(recordingStatus: $cameraRecordingStatus) { outputFileURL in
                    self.destinationView = AnyView(VideoEditingView(url: outputFileURL))
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
        }.navigationBarTitleDisplayMode(.inline)
            .navigationTitle(
                getNavigationTitle()
            )
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.dominantColor)
            }), trailing:
                Button(action: {
                    self.viewModel.isPHPhotoPickerViewPresented = true
                }, label: {
                    switch viewModel.displayMode {
                    case .library:
                        Image(systemName: "photo")
                        .foregroundColor(Color.dominantColor)
                    case .filming:
                        EmptyView()
                    }
            })
            )
            .sheet(isPresented: $viewModel.isPHPhotoPickerViewPresented, content: {
                CustomPHPickerViewController { results in
                    viewModel.getPHPickerResults(results: results)
                }
            })
    }
    
    private func getNavigationTitle() -> Text {
        switch viewModel.displayMode {
        case .library:
            return Text("ライブラリ")
        case .filming:
            return Text("撮影")
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
