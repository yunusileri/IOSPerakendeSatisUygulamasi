//
//  SepetTableViewCell.swift
//  PrekandeSatisUygulamasiV3
//
//  Created by yunusileri on 19.05.2019.
//  Copyright © 2019 yunusileri. All rights reserved.
//

import UIKit
import RealmSwift

protocol SepetProtocol {
    func birimUrunSil()
}

class SepetTableViewCell: UITableViewCell, UITextFieldDelegate{
    
    @IBOutlet weak var adetTextField: UITextField!
    @IBOutlet weak var fiyatLabel: UILabel!
    @IBOutlet weak var urunAdiLabel: UILabel!
    @IBOutlet weak var tutarLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    var urun:Urun?
    
    var delegate: SepetProtocol?
    
    var index: Int = 0
    var eskiAdets = 0
    @IBAction func btnArttir(_ sender: Any) {
        var eskiAdet = 0
        let adetText = NSString(string: adetTextField.text!)
        if adetText != ""{
            eskiAdet = Int(adetText.intValue)
        }
        let yeniAdet = eskiAdet + 1
        
        adetTextField.text = String(yeniAdet)
        adetLabel.text = String(yeniAdet)
        
        let tutar = Double(yeniAdet) * (urun?.fiyat)!
        tutarLabel.text = String(tutar)
        adetGuncelle(eskiAdet: eskiAdet, yeniAdet: yeniAdet)
        
        
        
    }
    
    
    @IBAction func adetTextFieldBegin(_ sender: Any) {
        if adetTextField.text != ""{
            eskiAdets = Int(adetTextField.text!)!
        }
    }
    
    
    
    @IBAction func adetTextFieldEdit(_ sender: Any) {
        if adetTextField.text != ""{
            let adetText = NSString(string: adetTextField.text!)
            let yeniAdets =  Int(adetText.intValue)
            let tutar = Double(yeniAdets) * (urun?.fiyat)!
            adetGuncelle(eskiAdet: eskiAdets, yeniAdet: yeniAdets )
            tutarLabel.text = String(tutar)
        }else{
            let yeniAdets = 0
            adetGuncelle(eskiAdet: eskiAdets, yeniAdet: yeniAdets )
            tutarLabel.text = String(0)
        }
        
        
        
    }
    
    @IBAction func btnAzalt(_ sender: Any) {
        var eskiAdet = 0
        let adetText = NSString(string: adetTextField.text!)
        if adetText != "" {
            eskiAdet = Int(adetText.intValue)
            if eskiAdet > 0 {
                let yeniAdet = eskiAdet - 1
                adetTextField.text = String(yeniAdet)
                adetLabel.text = String(yeniAdet)
                let tutar = Double(yeniAdet) * (urun?.fiyat)!
                tutarLabel.text = String(tutar)
                adetGuncelle(eskiAdet: eskiAdet, yeniAdet: yeniAdet)
                
            }
        }
    }
    
    func adetGuncelle(eskiAdet: Int, yeniAdet: Int){
        let realm = try! Realm()
        var tempsepet = realm.objects(tempSepet.self).filter("urunBarkod == %@", (urun?.barkod)!)
        tempsepet = tempsepet.filter("adet == %@", eskiAdet)
        try! realm.write {
            tempsepet[0].adet = yeniAdet
        }
    }
    
    @IBAction func urunSil(_ sender: Any) {
        let realm = try! Realm()
        var deleteUrun = realm.objects(tempSepet.self).filter("urunBarkod == %@", (urun?.barkod)!)
        let eskiAdet = Int(adetLabel.text!)
        deleteUrun = deleteUrun.filter("adet == %@", eskiAdet as Any)
        try! realm.write {
            realm.delete(deleteUrun[0])
        }
        delegate?.birimUrunSil()
    }
    
    
    
    
    
    
}

