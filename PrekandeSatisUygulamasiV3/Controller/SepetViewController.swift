//
//  SepetViewController.swift
//  PrekandeSatisUygulamasiV3
//
//  Created by yunusileri on 19.05.2019.
//  Copyright © 2019 yunusileri. All rights reserved.
//

import UIKit
import RealmSwift

class SepetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tutarLabel: UILabel!
    var tutar = 0.0
    var sepet = [Urun]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        veriCek()
    }
    
    func veriCek(){
        let realm = try! Realm()
        let sepets = realm.objects(tempSepet.self)
        for s in sepets{
            let uruns = realm.objects(Urun.self).filter("barkod == %@", s.urunBarkod)
            let urun = Urun()
            urun.barkod = uruns[0].barkod
            urun.stok = s.adet
            urun.fiyat = uruns[0].fiyat
            urun.urunadi = uruns[0].urunadi
            tutar += urun.fiyat * Double(urun.stok)
            sepet.append(urun)
        }
        tutarLabel.text = "Tutar : \(tutar)"
        
    }
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepet.count
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SepetTableViewCell
        let urun = sepet[indexPath.row]
        let adet = urun.stok
        let fiyat = urun.fiyat
        cell?.urun = urun
        
        cell?.urunAdiLabel.text = urun.urunadi
        cell?.fiyatLabel.text = String(fiyat)
        cell?.adetLabel.text = String(adet)
        cell?.adetTextField.text = String(adet)
        let tutar = Double(adet) * fiyat
        cell?.tutarLabel.text = String(tutar)
        cell?.index = indexPath.row
        cell?.delegate = self
        
        return cell!
    }
    @IBAction func SepetiSil(_ sender: Any) {
        sepetiSil()
        
    }
    
    
    func sepetiSil(){
        let realm = try! Realm()
        let sepets = realm.objects(tempSepet.self)
        try! realm.write {
            realm.delete(sepets)
        }
        sepet = [Urun]()
        tableView.reloadData()
    }
    
    
    
    
    @IBAction func SepetiKaydet(_ sender: Any) {
        // (timeIntervalSinceNow: 10800)
        let date = Date.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmmddMMyyyy"
        let dateString = dateFormatter.string(from: date)
     
        let realm = try! Realm()
        for s in sepet{
            let satis = Satislar()
            
            let urun = realm.objects(Urun.self).filter("barkod == %@",s.barkod)
      
            if urun[0].stok > s.stok{
                satis.barkod = s.barkod
                satis.adet = s.stok
                satis.ucret = Double(s.stok) * s.fiyat
                satis.siparisId = dateString
    
                
                try! realm.write {
                    realm.add(satis)
                    urun[0].stok = urun[0].stok - satis.adet
                }
                           sepetiSil()
            }
            
 
            else{
                /// Alert Yazılacak
                UIAlertController.showAlert("Bilgi", message: "Stokta yeterli ürün bulunmamaktadır.", self)
            }
            
        }
    }
    @IBAction func geriClick(_ sender: Any) {
            dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnreloadData(_ sender: Any) {
        tableView.reloadData()
    }
    
}

extension SepetViewController: SepetProtocol{
    func birimUrunSil() {
        sepet = [Urun]()
        veriCek()
        
        tableView.reloadData()
    }
}
extension UIAlertController{
    static public func showAlert(_ title: String, message: String, _ controller: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertAction.Style.default,handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
