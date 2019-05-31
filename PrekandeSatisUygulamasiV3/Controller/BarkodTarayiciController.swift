//
//  BarkodTarayiciViewController.swift
//  PrekandeSatisUygulamasiV3
//
//  Created by yunusileri on 18.05.2019.
//  Copyright © 2019 yunusileri. All rights reserved.
//

import UIKit
import AVFoundation

class BarkodTarayiciViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var avCaptureSession: AVCaptureSession?
    var barkod = "1"
    
    @IBOutlet weak var videoPreview: UIView!
    
    
    
    enum error: Error{
        case noCameraAvailable
        case videoInputInitFail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        
        /*NotificationCenter.default.post(name: .saveBarkod, object: self)
         self.removeAnimate()*/
        
         do{
         try scanQRCod()
         }catch{
         print("Barkod Taranamadı.")
         }
        
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    @IBAction func denem(_ sender: Any) {
        self.removeAnimate()
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count > 0 {
            
            let mechineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if mechineReadableCode.type == AVMetadataObject.ObjectType.ean13{
                
                barkod = mechineReadableCode.stringValue!
                avCaptureSession?.stopRunning()
                
                // Barkod Verisini Geri Gönder
                NotificationCenter.default.post(name: .saveBarkod, object: self)
                self.removeAnimate()
                
            }
        }
        
    }
    
    func scanQRCod() throws{
        avCaptureSession = AVCaptureSession()
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Kamera Bulunamadı.")
            throw error.noCameraAvailable
        }
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("Kamera Açılamadı.")
            throw error.videoInputInitFail
        }
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        avCaptureSession?.addInput(avCaptureInput)
        avCaptureSession?.addOutput(avCaptureMetadataOutput)
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13]
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession!)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)
        avCaptureSession?.startRunning()
        
    }
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     /*
     if segue.identifier == "sepetBarkod"{
     let cont = segue.destination as! UrunSatisTableViewController
     cont.barkod = barkod
     }
     */
     }
     
     */
    
    
    
}
