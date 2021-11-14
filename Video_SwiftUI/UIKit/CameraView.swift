//
//  CameraView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/12.
//

import SwiftUI
import AVFoundation

enum RecordingStatus: String {
    case ready
    case start
    case stop
}

public protocol CameraViewDelegate: AnyObject {
    func didFinishRecording(outputFileURL: URL)
}

public class UICameraView: UIView {
    private var videoDevice: AVCaptureDevice?
    private var fileOutput: AVCaptureMovieFileOutput?
    private var captureSession: AVCaptureSession?
    private var videoLayer: AVCaptureVideoPreviewLayer?
    public weak var delegate: CameraViewDelegate?
    var isShooting = false {
        didSet {
            if isShooting {
                let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))
                let image = UIImage(systemName: "stop.fill", withConfiguration: imageConfig)
                captureButton.setImage(image, for: .normal)
            } else {
                let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))
                let image = UIImage(systemName: "camera", withConfiguration: imageConfig)
                captureButton.setImage(image, for: .normal)
            }
        }
    }
    
    static let buttonWidth: CGFloat = 70
    private let captureButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))
        let image = UIImage(systemName: "camera", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = UICameraView.buttonWidth / 2
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.masksToBounds = true
        return button
    }()
    
    private let reverseButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.up.arrow.down")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.masksToBounds = true
        return button
    }()
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCaptureSession(position: .back)
        setUpVideoPreviewLayer()
        addSubview(captureButton)
        captureButton.addTarget(self, action: #selector(tapCaptureButton(_:)), for: .touchUpInside)
        addSubview(reverseButton)
        reverseButton.addTarget(self, action: #selector(tapReverseButton(_:)), for: .touchUpInside)
    }
    
    private func setUpCaptureSession(position: AVCaptureDevice.Position) {
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
        captureSession = AVCaptureSession()
        videoDevice = defaultCamera(position: position)
        let audioDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.audio)

        // video input setting
        let videoInput: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: videoDevice!)
        captureSession?.addInput(videoInput)

        // audio input setting
        let audioInput = try! AVCaptureDeviceInput(device: audioDevice!)
        captureSession?.addInput(audioInput)

        // max duration setting
        fileOutput = AVCaptureMovieFileOutput()
        fileOutput?.maxRecordedDuration = CMTimeMake(value: 60, timescale: 1)

        captureSession?.addOutput(fileOutput!)

        // video quality setting
        captureSession?.beginConfiguration()
        if captureSession?.canSetSessionPreset(.hd4K3840x2160) == true {
            captureSession?.sessionPreset = .hd4K3840x2160
        } else if captureSession?.canSetSessionPreset(.high) == true {
            captureSession?.sessionPreset = .high
        }
        captureSession?.commitConfiguration()

        captureSession?.startRunning()
    }
    
    private func setUpVideoPreviewLayer() {
        // video preview layer
        guard let captureSession = captureSession else { return }
        if let l = layer.sublayers?.filter({ layer in
            layer == videoLayer
        }).first {
            l.removeFromSuperlayer()
        }
        
        videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.insertSublayer(videoLayer!, at: 0)
    }
    
    @objc private func tapCaptureButton(_ sender: UIButton) {
        if isShooting {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    @objc private func tapReverseButton(_ sender: UIButton) {
        guard !isShooting else {
            return
        }
        let currentPosition = (captureSession?.inputs.first as? AVCaptureDeviceInput)?.device.position ?? .back
        setUpCaptureSession(position: currentPosition == .back ? .front : .back)
        setUpVideoPreviewLayer()
    }
    
    public override func layoutSubviews() {
        captureButton.frame = CGRect(x: (self.frame.width - UICameraView.buttonWidth) / 2, y: self.frame.height - UICameraView.buttonWidth - 20, width: UICameraView.buttonWidth, height: UICameraView.buttonWidth)
        reverseButton.frame = CGRect(x: self.frame.width - 44 - 20, y: 20, width: 44, height: 44)
        videoLayer?.frame = bounds
    }
    
    func startRecording() {
        let tempDirectory: URL = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileURL: URL = tempDirectory.appendingPathComponent("mytemp1.mov")
        fileOutput?.startRecording(to: fileURL, recordingDelegate: self)
        isShooting = true
    }
    
    func stopRecording() {
        // stop recording
        fileOutput?.stopRecording()
        isShooting = false
    }
    
    private func defaultCamera(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: position) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position) {
            return device
        } else {
            return nil
        }
    }
}

extension UICameraView: AVCaptureFileOutputRecordingDelegate {
    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        delegate?.didFinishRecording(outputFileURL: outputFileURL)
    }
}
    
struct CameraView: UIViewRepresentable {
    @Binding var recordingStatus: RecordingStatus
    let didFinishRecording: (_ outputFileURL: URL) -> Void
    
    final public class Coordinator: NSObject, CameraViewDelegate {
        private let cameraView: CameraView
        private let didFinishRecording: (_ outputFileURL: URL) -> Void
        init(_ cameraView: CameraView, didFinishRecording: @escaping (_ outputFileURL:URL) -> Void) {
            self.cameraView = cameraView
            self.didFinishRecording = didFinishRecording
        }
        
        func didFinishRecording(outputFileURL: URL) {
            didFinishRecording(outputFileURL)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, didFinishRecording: didFinishRecording)
    }
    
    func makeUIView(context: Context) -> UICameraView {
        let uiCameraView = UICameraView()
        uiCameraView.delegate = context.coordinator
        return uiCameraView
    }
    
    func updateUIView(_ uiView: UICameraView, context: Context) {
        switch recordingStatus {
        case .ready:
            return
        case .start:
            uiView.startRecording()
        case .stop:
            uiView.stopRecording()
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    @State static var recodingStatus: RecordingStatus = .ready
    static var previews: some View {
        CameraView(recordingStatus: CameraView_Previews.$recodingStatus, didFinishRecording: { url in })
    }
}
