//
//  CustomPHPickerViewController.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/10.
//

import SwiftUI
import PhotosUI

public typealias PHPickerViewCompletionHandler = ( ([PHPickerResult]) -> Void)
struct CustomPHPickerViewController: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration
    let completionHandler: PHPickerViewCompletionHandler?
    
    init(completion: PHPickerViewCompletionHandler? = nil) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .videos
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .current
        self.configuration = configuration
        self.completionHandler = completion
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomPHPickerViewController>) -> PHPickerViewController {
        let viewController = PHPickerViewController(configuration: configuration)
            viewController.delegate = context.coordinator
            return viewController
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<CustomPHPickerViewController>) {
        
    }
    
    public class Coordinator : PHPickerViewControllerDelegate {
        let parent: CustomPHPickerViewController
        
        init(_ parent: CustomPHPickerViewController) {
            self.parent = parent
        }
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true) { [weak self] in
                self?.parent.completionHandler?(results)
            }
        }
    }
}

struct CustomPHPickerViewController_Previews: PreviewProvider {
    static var previews: some View {
        CustomPHPickerViewController()
    }
}
