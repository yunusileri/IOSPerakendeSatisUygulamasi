//
//  UrunSatisTableViewController.swift
//  PrekandeSatisUygulamasiV3
//
//  Created by yunusileri on 18.05.2019.
//  Copyright © 2019 yunusileri. All rights reserved.
//

import UIKit
import RealmSwift

class UrunSatisTableViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var barkodTextField: UITextField!
    
    var barkod = ""
    
    var sepets = [Urun]()
    var urunler = [Urun]()
    var tempurunler = [Urun]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        veriCek()
        barkodTextField.text = barkod
        urunAra()
        // 1. Yöntem
        
        /* NotificationCenter.default.addObserver(self, selector: #selector(handlePopUpClosing), name: .saveBarkod, object: nil)
         */
        
        NotificationCenter.default.addObserver(forName: .saveBarkod, object: nil, queue: OperationQueue.main){ (notification) in
            let barkodNotification = notification.object as! BarkodTarayiciViewController
            self.barkodTextField.text = barkodNotification.barkod
            self.urunAra()
        }
    }
    /*@objc func handlePopUpClosing(notification: Notification){
     let barkodTarayici = notification.object as! BarkodTarayiciViewController
     barkodTextField.text = barkodTarayici.barkod
     urunAra()
     }
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempurunler.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UrunSatisCell
        cell?.UrunAd.text = tempurunler[indexPath.row].urunadi
        cell?.stokLabel.text = String(tempurunler[indexPath.row].stok)
        cell?.fiyatLabel.text = String(tempurunler[indexPath.row].fiyat)
        cell?.index = indexPath.row
        cell?.delegate = self
        return cell!
    }
    
    @IBAction func urunAraBarkodButton(_ sender: Any) {
        urunAra()
        
    }
    
    func urunAra(){
        let tempBarkod = barkodTextField.text
        let urun = tempurunler.filter({$0.barkod == tempBarkod})
        if tempBarkod == ""{
            tempurunler = urunler
        }else{
            tempurunler = urun
        }
        self.tableView.reloadData()
    }
    func veriCek(){
        let realm = try! Realm()
        let data = realm.objects(Urun.self)
        for d in data{
            let urun = Urun()
            urun.barkod = d.barkod
            urun.urunadi = d.urunadi
            urun.stok = d.stok
            urun.fiyat = d.fiyat
            urunler.append(urun)
        }
        tempurunler = urunler
        
    }
    
    
    
    
    
    func sepetEkle(sepet:tempSepet){
        let realm = try! Realm()
        try! realm.write {
            realm.add(sepet)
        }
    }
    
    
    
    
    
    
    @IBAction func geriClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func barkodTaraAction(_ sender: Any) {
        let popUpBarkodTarayici = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "barkodView") as! BarkodTarayiciViewController
        self.addChild(popUpBarkodTarayici)
        popUpBarkodTarayici.view.frame = self.view.frame
        self.view.addSubview(popUpBarkodTarayici.view)
        popUpBarkodTarayici.didMove(toParent: self)
    }
    
    
    
}





extension UrunSatisTableViewController: tableViewProtocol{
    func getIndex(index: Int, adet: Int)  {
        if adet > 0 {
            let urun = tempurunler[index]
            let sepet = tempSepet()
            sepet.urunBarkod = urun.barkod
            sepet.adet = adet
            sepetEkle(sepet: sepet)
        }
        
    }
}

