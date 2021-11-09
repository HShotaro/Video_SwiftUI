//
//  VideoFilmingViewModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/09.
//

import Foundation
import Combine

class VideoSelectionViewModel: ObservableObject {
    @Published var isEditing: Bool = false
    @Published var displayMode: VideoSelectionView.DisplayMode = .library
    @Published var showConfirmDialogOfSelectedPicture = false
    @Published var selectedItemID: Int? = nil
}
