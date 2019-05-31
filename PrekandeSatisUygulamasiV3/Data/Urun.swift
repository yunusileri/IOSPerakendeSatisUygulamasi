//
//  Urun.swift
//  PrekandeSatisUygulamasiV3
//
//  Created by yunusileri on 18.05.2019.
//  Copyright © 2019 yunusileri. All rights reserved.
//

import Foundation

import RealmSwift

class Urun: Object {
    @objc dynamic var urunadi = ""
    @objc dynamic var barkod = ""
    @objc dynamic var stok = 0
    @objc dynamic var fiyat = 0.0
}
