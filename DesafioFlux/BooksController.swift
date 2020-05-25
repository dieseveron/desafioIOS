//
//  BooksController.swift
//  DesafioFlux
//
//  Created by Diego Veron on 23/05/2020.
//  Copyright © 2020 Diego Veron. All rights reserved.
//

import UIKit
import Alamofire

struct Book: Codable {
    let id : Int
    let nombre : String
    let autor : String
    let disponibilidad : Bool
    let popularidad : Int
    let imagen : String
}

class BooksController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tabla: UITableView!
    var books = [Book]()
    var filterBooks = [Book]()
    var bookFilter : Bool = true
    var allBook : Bool = true
    var orden : Bool = true
    let urlApi = "https://qodyhvpf8b.execute-api.us-east-1.amazonaws.com/test/books"
    override func viewDidLoad() {
        super.viewDidLoad()
        getBooks()
        
    }
    @IBAction func allBooks(_ sender: UIButton) {
        allBook = true
        self.tabla.reloadData()
    }
    
    @IBAction func setOrder(_ sender: UIButton) {
        if (orden == true){
          orderByPopularityAsc()
          sender.setTitle("Orden Desc", for: .normal)
          orden = false
        }else{
          orderByPopularityDesc()
          sender.setTitle("Orden Asc", for: .normal)
          orden = true
        }
    }
    
    
    func orderByPopularityDesc(){
        if allBook == true {
          let booksSortDes = self.books.sorted { (b1: Book , b2: Book ) -> Bool in
              b1.popularidad > b2.popularidad
          }
          self.books = booksSortDes
        }else{
          let booksSortDes = self.filterBooks.sorted { (b1: Book , b2: Book ) -> Bool in
              b1.popularidad > b2.popularidad
          }
          self.filterBooks = booksSortDes
        }
        self.tabla.reloadData()
    }
    
    func orderByPopularityAsc(){
        if allBook == true {
          let booksSortDes = self.books.sorted { (b1: Book , b2: Book ) -> Bool in
              b1.popularidad < b2.popularidad
          }
          self.books = booksSortDes
        }else{
          let booksSortDes = self.filterBooks.sorted { (b1: Book , b2: Book ) -> Bool in
              b1.popularidad < b2.popularidad
          }
          self.filterBooks = booksSortDes
        }
        self.tabla.reloadData()
    }
   
    
    func getBooks(){
        guard let api = URL(string: "https://qodyhvpf8b.execute-api.us-east-1.amazonaws.com/test/books") else { return }
        let url = URLRequest(url: api)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            do{
                self.books = try JSONDecoder().decode([Book].self, from: data!)
                DispatchQueue.main.async {
                    self.orderByPopularityDesc()
                }
            }catch let error as NSError{
                print("Error request api", error.localizedDescription)
            }
        }.resume()
    }
    
    @IBAction func cerrar(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allBook == true {
          return books.count
        }else{
          return filterBooks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CeldaPer
        
        let book : Book
        if allBook == true {
          book = books[indexPath.row]
        }else{
            book = filterBooks[indexPath.row]
        }
        
        
        cell.nombre.text = book.nombre
        cell.autor.text = book.autor
        
        if book.disponibilidad {
            cell.disponibilidad.text = "Disponible"
        }else{
            cell.disponibilidad.text = "No Disponible"
        }
        
        let urlBook: String? = book.imagen
        if urlBook != nil && urlBook != "" {
          let photoUrl = URL(string: urlBook!)
          cell.imagenBook.load(url: photoUrl!)
        }
        
        return cell
    }
    
    
    @IBAction func filterContein(_ sender: UIButton) {
        if self.bookFilter == true {
            sender.setTitle("No disponible", for: .normal)
            fitroBook(param: true)
        }else{
            sender.setTitle("Disponible", for: .normal)
            fitroBook(param: false)
        }
    }
    
    func fitroBook(param: Bool){
        self.bookFilter = !param
        self.filterBooks = books.filter{ book in
            return(book.disponibilidad == param)
        }
        self.allBook = false
        DispatchQueue.main.async {
            self.tabla.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookDetail"{
            if allBook == true {
              if let id = tabla.indexPathForSelectedRow {
                  let book = books[id.row]
                  let destino = segue.destination as! BookDetailController
                  destino.book = book
              }
            }else{
              if let id = tabla.indexPathForSelectedRow {
                  let book = filterBooks[id.row]
                  let destino = segue.destination as! BookDetailController
                  destino.book = book
              }
            }
            
            
                
            
        }
    }
    

};extension UIImageView {
    func load(url: URL) {
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
