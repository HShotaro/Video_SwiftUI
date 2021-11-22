//
//  Error+handle.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/19.
//

import Foundation
import UIKit

extension Error {
    func toAlert(retryHandler: (() -> Void)? = nil) -> UIAlertController? {
        var message: String?
        switch self {
        case let urlError as URLError:
            switch urlError.code {
            case .notConnectedToInternet:
                message = "インターネットに接続できません。通信環境をご確認の上再度お試し下さい"
            case .timedOut:
                message = "データの取得にかかる時間が長すぎます"
            case .badURL:
                message = "不正なURLからのリクエストが行われました。"
            default:
                message = "ネットワークに関するエラーです"
            }
        default:
            message = "原因不明のエラーです"
        }
        
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        if let retryHandler = retryHandler {
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let defaultAction = UIAlertAction(title: "リトライ", style: .default) { _ in
                retryHandler()
            }
            alert.addAction(defaultAction)
        } else {
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
        }
        return alert
    }
}
