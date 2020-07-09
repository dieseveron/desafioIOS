//
//  BookGridController.swift
//  DesafioFlux
//
//  Created by Diego Veron on 09/07/2020.
//  Copyright © 2020 Diego Veron. All rights reserved.
//

import UIKit
import Alamofire

struct BookGrid: Codable {
    let id : Int
    let nombre : String
    let autor : String
    let disponibilidad : Bool
    let popularidad : Int
    let imagen : String
}
class BookGridController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var grilla: UICollectionView!
    var books = [BookGrid]()
    var filterBooks = [BookGrid]()
    var bookFilter : Bool = true
    var allBook : Bool = true
    var orden : Bool = true
    let urlApi = "https://qodyhvpf8b.execute-api.us-east-1.amazonaws.com/test/books"
    
    func getBooks(){
        guard let api = URL(string: "https://qodyhvpf8b.execute-api.us-east-1.amazonaws.com/test/books") else { return }
        let url = URLRequest(url: api)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            do{
                self.books = try JSONDecoder().decode([BookGrid].self, from: data!)
                DispatchQueue.main.async {
                    self.orderByPopularityDesc()
                }
            }catch let error as NSError{
                print("Error request api", error.localizedDescription)
            }
        }.resume()
    }
    func orderByPopularityDesc(){
        if allBook == true {
          let booksSortDes = self.books.sorted { (b1: BookGrid , b2: BookGrid ) -> Bool in
              b1.popularidad > b2.popularidad
          }
          self.books = booksSortDes
        }else{
          let booksSortDes = self.filterBooks.sorted { (b1: BookGrid , b2: BookGrid ) -> Bool in
              b1.popularidad > b2.popularidad
          }
          self.filterBooks = booksSortDes
        }
        self.grilla.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
          return books.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellGrid = grilla.dequeueReusableCell(withReuseIdentifier: "cellGrid", for: indexPath) as! CellCollection
        let book : BookGrid
        if allBook == true {
         book = books[indexPath.row]
        }else{
            book = filterBooks[indexPath.row]
        }
        
        //cellGrid.nombre.text = book.nombre
        //cellGrid.autor.text = book.autor
               
        /*if book.disponibilidad {
          cellGrid.disponibilidad.text = "Disponible"
        }else{
          cellGrid.disponibilidad.text = "No Disponible"
        }*/
               
        let urlBook: String? = book.imagen
        if urlBook != nil && urlBook != "" {
          let photoUrl = URL(string: urlBook!)
          cellGrid.imagen.loadImage(url: photoUrl!)
        }
        return cellGrid
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getBooks()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cerrar(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    func scaleDown(image: UIImage, withSize: CGSize) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(withSize, false, scale)
        image.draw(in: CGRect(x: 0, y: 0, width: withSize.width, height: withSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    

};extension UIImageView {
    func loadImage(url: URL) {
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
