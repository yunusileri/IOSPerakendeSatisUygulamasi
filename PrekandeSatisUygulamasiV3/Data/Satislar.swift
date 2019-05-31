//
//  Satislar.swift
//  PrekandeSatisUygulamasiV3
//
//  Created by Mac16 on 21.05.2019.
//  Copyright © 2019 yunusileri. All rights reserved.
//

import Foundation
import RealmSwift

class Satislar: Object {
    
    @objc dynamic var siparisId = ""
    
    @objc dynamic var barkod = ""
    
    @objc dynamic var adet = 0
    
    @objc dynamic var ucret = 0.0
    
    
    // @objc dynamic var tarih = Date()
    /*
     urun Barkod
     Adet
     Toplam Fiyat
     sipariş İD
     tarih
     
     */
}
