//
//  BookDetailController.swift
//  DesafioFlux
//
//  Created by Diego Veron on 24/05/2020.
//  Copyright © 2020 Diego Veron. All rights reserved.
//

import UIKit

class BookDetailController: UIViewController {
    
    var book : Book!
    
    @IBOutlet weak var imageBook: UIImageView!
    
    @IBOutlet weak var nombre: UILabel!
    
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var popularidad: UILabel!
    
    @IBOutlet weak var disponibilidad: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBookDetail()
    }
    @IBAction func backList(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    func loadBookDetail(){
        nombre.text = book.nombre
        autor.text = book.autor
        if book.disponibilidad {
            disponibilidad.text = "Disponible"
        }else{
            disponibilidad.text = "No Disponible"
        }
        popularidad.text = "\(book.popularidad)"
        let urlBook: String? = book.imagen
        if urlBook != nil && urlBook != "" {
          let photoUrl = URL(string: urlBook!)
          imageBook.load(url: photoUrl!)
        }
    }

};extension UIImageView {
    func loadBook(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
