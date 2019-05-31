//
//  SatislariListele.swift
//  PrekandeSatisUygulamasiV3
//
//  Created by Mac16 on 27.05.2019.
//  Copyright © 2019 yunusileri. All rights reserved.
//

import UIKit
import RealmSwift

class SatislariListele: UITableViewController {
    
    var siparisID = String()
    
    var satislar = [Satislar]()
    override func viewDidLoad() {
        super.viewDidLoad()
        veriCek()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return satislar.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text =  String(satislar[indexPath.row].siparisId)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        siparisID = satislar[indexPath.row].siparisId
        performSegue(withIdentifier: "satisDetayIdentifier", sender: nil)
    }
    
    
    func veriCek(){
        let realm = try! Realm()
        let data = realm.objects(Satislar.self)
        for d in data {
            let satis = Satislar()
            satis.siparisId = d.siparisId
            if find(searchValue: satis.siparisId)!{
                satislar.append(satis)
            }
            
        }
        self.tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "satisDetayIdentifier"{
            let cont = segue.destination  as! SatisDetay
            cont.siparisID = siparisID
        }
    }
    
    func find(searchValue: String) -> Bool?{
        for s in satislar{
            if searchValue == s.siparisId{
                return false
            }
        }
        return true
    }
    
    
    @IBAction func geriClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

class SatisDetay: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var toplamUcretLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var siparisID = String()
    var satislar = [Satislar]()
    var ucret = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        veriCek()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return satislar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SatisDetayCell
        cell?.barkodLabel.text = satislar[indexPath.row].barkod
        cell?.adetLabel.text = String(satislar[indexPath.row].adet)
        cell?.tutarLabel.text = String(satislar[indexPath.row].ucret)
        cell?.urunAdiLabel.text = urunAdi(barkod: satislar[indexPath.row].barkod)
        
        return cell!
    }
    func urunAdi(barkod: String) -> String{
        let realm = try! Realm()
        let data = realm.objects(Urun.self).filter("barkod == %@",barkod)[0]
        return data.urunadi
    }
    func veriCek(){
        let realm = try! Realm()
        let data = realm.objects(Satislar.self).filter("siparisId == %@",siparisID)
        for d in data {
            let satis = Satislar()
            satis.siparisId = d.siparisId
            satis.barkod = d.barkod
            satis.adet = d.adet
            satis.ucret = d.ucret
            ucret += satis.ucret
            satislar.append(satis)
        }
        toplamUcretLabel.text = "Tutar : \(ucret)"
        tableView.reloadData()
    }
    
    @IBAction func geriClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
