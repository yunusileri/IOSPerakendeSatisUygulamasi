//
//  UrunEkleViewController.swift
//  PrekandeSatisUygulamasiV3
//
//  Created by yunusileri on 18.05.2019.
//  Copyright © 2019 yunusileri. All rights reserved.
//

import UIKit
import RealmSwift



class UrunEkleViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var stokTextField: UITextField!
    @IBOutlet weak var fiyatTextField: UITextField!
    @IBOutlet weak var barkodTextField: UITextField!
    @IBOutlet weak var urunAdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDelegate()
        NotificationCenter.default.addObserver(forName: .saveBarkod, object: nil, queue: OperationQueue.main){ (notification) in
            let barkodNotification = notification.object as! BarkodTarayiciViewController
            self.barkodTextField.text = barkodNotification.barkod
            
        }
        
    }
    
    @IBAction func barkodTaraAction(_ sender: Any) {
        let popUpBarkodTarayici = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "barkodView") as! BarkodTarayiciViewController
        self.addChild(popUpBarkodTarayici)
        popUpBarkodTarayici.view.frame = self.view.frame
        self.view.addSubview(popUpBarkodTarayici.view)
        popUpBarkodTarayici.didMove(toParent: self)
    }
    
    
    
    @IBAction func ekle(_ sender: Any) {
        var urunadi = ""
        var barkod = ""
        var fiyat = 0.0
        var stok = 0
        
        if urunAdTextField.text! != ""{
            urunadi = urunAdTextField.text!
        }
        if barkodTextField.text! != ""{
            barkod = barkodTextField.text!
        }
        if stokTextField.text! != ""{
            stok = Int(stokTextField.text!)!
        }
        if fiyatTextField.text! != ""{
            fiyat = Double(fiyatTextField.text!)!
        }
        
        
        
        if urunadi != "" && barkod != "" && fiyat != 0.0 && stok != 0 {
            let realm = try! Realm()
            let urun = Urun()
            urun.urunadi = urunadi
            urun.barkod = barkod
            urun.stok = stok
            urun.fiyat = fiyat
            try! realm.write {
                realm.add(urun)
                
            }
            
        }
        temizle()
          UIAlertController.showAlert("Bilgi", message: "Ürün Eklendi.", self)
        
    }
    
    func textFieldDelegate(){
        stokTextField.delegate = self
        fiyatTextField.delegate = self
        barkodTextField.delegate = self
        stokTextField.keyboardType = .numberPad
        fiyatTextField.keyboardType = .numberPad
        barkodTextField.keyboardType = .numberPad
        
    }
    
    func temizle () {
        stokTextField.text = ""
        fiyatTextField.text = ""
        barkodTextField.text = ""
        urunAdTextField.text = ""
    }
    @IBAction func geri(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
