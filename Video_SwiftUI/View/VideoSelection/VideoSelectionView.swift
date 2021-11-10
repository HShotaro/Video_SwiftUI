//
//  VideoFilingView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI

struct VideoSelectionView: View {
    static let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 5, alignment: .center), count: 3)
    enum DisplayMode {
    case library
    case filming
    }
    @StateObject private var viewModel = VideoSelectionViewModel()
    @Binding var isPresented: Bool
    var body: some View {
        ZStack {
            switch viewModel.displayMode {
            case .library:
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: VideoSelectionView.columns, alignment: .center, spacing: 5) {
                        ForEach(mocks, id: \.self.id) { mock in
                            Button {
                                viewModel.selectedItemID = mock.id
                                viewModel.showConfirmDialogOfSelectedPicture = true
                            } label: {
                                Color.yellow.aspectRatio(1.0, contentMode: .fit)
                            }
                        }
                    }.padding(EdgeInsets(top: 5, leading: 5, bottom: 89, trailing: 5))
                        .alert(isPresented: $viewModel.showConfirmDialogOfSelectedPicture) {
                            Alert(title: Text("この動画をアップロードしますか？"),
                                  message: nil,
                                  primaryButton: Alert.Button.default(Text("はい"), action: {
                                // TODO 動画をアップロードする処理
                            }), secondaryButton: Alert.Button.cancel()
                            )
                        }
                }
            case .filming:
                EmptyView()
            
            }
            if viewModel.isEditing {
                Color.black.opacity(0.3).frame(width: .infinity, height: .infinity)
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
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.dominantColor)
            })
            )
    }
    
    func getEditButtonOriginX() -> CGFloat {
        let safeArea = UIApplication.getSafeArea()
        return (UIScreen.main.bounds.width - safeArea.left - safeArea.right) / 2 - 42
    }
    
    func getEditButtonOriginY() -> CGFloat {
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
