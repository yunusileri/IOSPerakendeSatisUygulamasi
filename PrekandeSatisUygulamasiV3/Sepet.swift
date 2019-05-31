//
//  Sepet.swift
//  PrekandeSatisUygulamasiV3
//
//  Created by yunusileri on 19.05.2019.
//  Copyright © 2019 yunusileri. All rights reserved.
//

import Foundation
import RealmSwift

class Sepet: Object {
    @objc dynamic var barkod = ""
    @objc dynamic var adet = 0
    @objc dynamic var birimFiyat = 0.0
    @objc dynamic var id = 0
}
