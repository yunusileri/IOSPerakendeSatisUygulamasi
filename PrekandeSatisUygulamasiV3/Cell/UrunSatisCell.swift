//
//  UrunSatisCell.swift
//  PrekandeSatisUygulamasiV3
//
//  Created by yunusileri on 18.05.2019.
//  Copyright © 2019 yunusileri. All rights reserved.
//

import UIKit

protocol tableViewProtocol {
    func getIndex(index: Int, adet: Int)
}

class UrunSatisCell: UITableViewCell{
    
    @IBOutlet weak var UrunAd: UILabel!
    @IBOutlet weak var fiyatLabel: UILabel!
    @IBOutlet weak var stokLabel: UILabel!
    @IBOutlet weak var adetTextField: UITextField!
    
    var index: Int = 0
    var delegate: tableViewProtocol?
    
    @IBAction func SepeteEkleClick(_ sender: Any) {
        var adet = 0
        
        let adetText = NSString(string: adetTextField.text!)
        
        if adetText != ""{
            adet = Int(adetText.intValue)
        }
        delegate?.getIndex(index: index, adet: adet)
        adetTextField.text = ""
    }
    
    @IBAction func adetArttir(_ sender: Any) {
        var adet = 0
        let adetText = NSString(string: adetTextField.text!)
        if adetText != ""{
            adet = Int(adetText.intValue)
        }
        adet += 1
        adetTextField.text = String(adet)
    }
    @IBAction func adetAzalt(_ sender: Any) {
        var adet = 0
        let adetText = NSString(string: adetTextField.text!)
        if adetText != "" {
            adet = Int(adetText.intValue)
            if adet > 0 {
                adet -= 1
                adetTextField.text = String(adet)
            }
        }
    }
    
}
