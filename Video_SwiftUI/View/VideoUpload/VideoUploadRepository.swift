//
//  VideoUploadModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/12/15.
//

//import Foundation
//
//struct VideoUploadRepository {
//    private struct NoURLError: Error {}
//    private struct HttpResponseError: Error {}
//    
//    static func upload(videoData: Data, videoTitle: String, description: String) async throws {
//        guard let url = URL(string: "https://www.google.com/") else {
//            throw NoURLError()
//        }
//        let request = MultipartFormDataRequest(url: url)
//        request.addTextField(named: "video_title", value: videoTitle)
//        request.addTextField(named: "video_description", value: description)
//        let fileName = UUID().uuidString + "_\(Date().timeIntervalSince1970)"
//        request.addDataField(named: fileName ,data: videoData, mimeType: "video/mp4")
//        
//        do {
//            return try await withCheckedThrowingContinuation { continuation in
//                let task = URLSession.shared.dataTask(with: request.asURLRequest()) { data, res, error in
//                    guard data != nil, error == nil, (res as? HTTPURLResponse)?.statusCode == 200  else {
//                        continuation.resume(throwing: HttpResponseError())
//                        return
//                    }
//                    continuation.resume(returning: ())
//                }
//                task.resume()
//            }
//        } catch {
//            throw error
//        }
//        
//    }
//}
//
//
//fileprivate struct MultipartFormDataRequest {
//    private let boundary: String = UUID().uuidString
//    private var httpBody = NSMutableData()
//    let url: URL
//
//    init(url: URL) {
//        self.url = url
//    }
//
//    func addTextField(named name: String, value: String) {
//        httpBody.append(textFormField(named: name, value: value))
//    }
//
//    private func textFormField(named name: String, value: String) -> String {
//        var fieldString = "--\(boundary)\r\n"
//        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
//        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
//        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
//        fieldString += "\r\n"
//        fieldString += "\(value)\r\n"
//
//        return fieldString
//    }
//
//    func addDataField(named name: String, data: Data, mimeType: String) {
//        httpBody.append(dataFormField(named: name, data: data, mimeType: mimeType))
//    }
//
//    private func dataFormField(named name: String,
//                               data: Data,
//                               mimeType: String) -> Data {
//        let fieldData = NSMutableData()
//
//        fieldData.append("--\(boundary)\r\n")
//        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
//        fieldData.append("Content-Type: \(mimeType)\r\n")
//        fieldData.append("\r\n")
//        fieldData.append(data)
//        fieldData.append("\r\n")
//
//        return fieldData as Data
//    }
//    
//    func asURLRequest() -> URLRequest {
//        var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//            httpBody.append("--\(boundary)--")
//            request.httpBody = httpBody as Data
//            return request
//    }
//}
