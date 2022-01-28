//
//  WebLinkVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 08/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class WebLinkVC: BaseVC {

    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var progressView: UIProgressView!

    public var linkTitle: (url: String?, title: String)?
    private var progressObserver: NSKeyValueObservation?

    var isPaymentGateway = false
    var paymentSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = /linkTitle?.title
        wkWebView.load(URLRequest.init(url: URL(string: /linkTitle?.url)!))
        if isPaymentGateway {
            wkWebView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        }
        
        btnDownload.isHidden = !(/linkTitle?.url?.contains("pdf"))
        
        progressObserver = wkWebView.observe(\WKWebView.estimatedProgress, options: .new, changeHandler: { [weak self] (wkView, change) in
            let progress = Float(wkView.estimatedProgress)
            self?.progressView.isHidden = progress == 1.0
            self?.progressView.progress = progress
        })
    }
    
    deinit {
        progressObserver = nil
    }
    
    @IBAction func btnDownloadAction(_ sender: UIButton) {
        guard let pdfData = try? Data.init(contentsOf: URL(string: /linkTitle?.url)!) else {
            return
        }
        let activityVC = UIActivityViewController.init(activityItems: [pdfData], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        popVC()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            #if AirDoc
            let webHook = "https://airdoc.royoconsult.com/webhook/paystack"
            if /wkWebView.url?.absoluteString.contains(webHook) {
                AF.request(URL.init(string: /wkWebView.url?.absoluteString)!).response { [weak self] (response) in
                    guard let this = self else { return }
                    self?.wkWebView.removeObserver(this, forKeyPath: "URL")
                    self?.paymentSuccess?()
                }
            }
            #elseif CloudDoc
            let webHook = "https://clouddoc.royoconsult.com/webhook/paystack"
            if /wkWebView.url?.absoluteString.contains(webHook) {
                AF.request(URL.init(string: /wkWebView.url?.absoluteString)!).response { [weak self] (response) in
                    guard let this = self else { return }
                    self?.wkWebView.removeObserver(this, forKeyPath: "URL")
                    self?.paymentSuccess?()
                }
            }
            #elseif HomeDoctorKhalid
            let webHook = "https://calladmin.inhomed.com/al_rajhi_bank/webhook" //Innhomed
            if /wkWebView.url?.absoluteString.contains(webHook) {
                AF.request(URL.init(string: /wkWebView.url?.absoluteString)!).response { [weak self] (response) in
                    guard let this = self else { return }
                    self?.wkWebView.removeObserver(this, forKeyPath: "URL")
                    self?.paymentSuccess?()
                }
            }
            #endif
        }
    }
}
