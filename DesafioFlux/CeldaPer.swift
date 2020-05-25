//
//  CeldaPer.swift
//  DesafioFlux
//
//  Created by Diego Veron on 23/05/2020.
//  Copyright © 2020 Diego Veron. All rights reserved.
//

import UIKit

class CeldaPer: UITableViewCell {


    @IBOutlet weak var imagenBook: UIImageView!
    
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var popularidad: UILabel!
    @IBOutlet weak var disponibilidad: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
