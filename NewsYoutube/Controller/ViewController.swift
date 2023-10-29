//
//  ViewController.swift
//  NewsYoutube
//
//  Created by anca dev on 20/10/23.
//

import UIKit
import SkeletonView

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionviewCategory: UICollectionView!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var labelJudul: UILabel!
    @IBOutlet weak var tableBerita: UITableView!
    
    let url = "http://localhost:3000/cnn/"
    let newsCategory = ["Nasional", "Internasional", "Ekonomi", "Olahraga", "Teknologi", "Hiburan"]
    let userDef = UserDefaults.standard
    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionviewCategory.delegate = self
        collectionviewCategory.dataSource = self
        collectionviewCategory.register(UINib(nibName: "Categorycollection", bundle: nil), forCellWithReuseIdentifier: "cellCategory")
        
        tableBerita.delegate = self
        tableBerita.dataSource = self
        tableBerita.register(UINib(nibName: "Beritacell", bundle: nil), forCellReuseIdentifier: "cellBerita")
        
        userDef.set(0, forKey: "categoryIndex")
        
        getApi(url: "\(url)nasional")
        
        imageThumbnail.isSkeletonable = true
        imageThumbnail.showAnimatedGradientSkeleton()
        
        labelJudul.isSkeletonable = true
        labelJudul.showAnimatedGradientSkeleton()
    }
    
    // func api berita indonesia
    
    func getApi(url: String) {
        if let urlStr = URL(string: url) {
            var urlReq = URLRequest(url: urlStr)
            urlReq.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONDecoder().decode(ListNews.self, from: data) as ListNews
                        
                        for index in json.data.posts {
                            self.news.append(News(title: index.title, thumbnail: index.thumbnail))
                        }
                        
                        DispatchQueue.main.async {
                            self.getImageload(url: self.news[0].thumbnail, completion: { image, error in
                                self.labelJudul.hideSkeleton()
                                self.imageThumbnail.hideSkeleton()
                                
                                self.imageThumbnail.image = image
                                self.imageThumbnail.contentMode = .scaleAspectFill
                                self.labelJudul.text = self.news[0].title
                            })
                            
                            self.tableBerita.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            
            dataTask.resume()
        }
    }
    
    func getImageload(url: String, completion: @escaping(UIImage?, Error?) -> Void) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { (data, respon, error) in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    if let imageRes = UIImage(data: data) {
                        completion(imageRes, nil)
                    }
                }
            }
            
            task.resume()
        }
    }

}

// Extension collection view

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionviewCategory.dequeueReusableCell(withReuseIdentifier: "cellCategory", for: indexPath) as! Categorycollection
        
        if userDef.integer(forKey: "categoryIndex") == indexPath.row {
            cell.labelCategory.textColor = .black
            cell.border.backgroundColor = .black
        } else {
            cell.labelCategory.textColor = .systemGray2
            cell.border.backgroundColor = .systemGray2
        }
        
        cell.labelCategory.text = newsCategory[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageThumbnail.showAnimatedSkeleton()
        self.labelJudul.showAnimatedGradientSkeleton()
        
        self.news = [News]()
        self.imageThumbnail.image = UIImage(named: "")
        self.labelJudul.text = ""
        
        userDef.set(indexPath.row, forKey: "categoryIndex")
        
        getApi(url: "\(url + self.newsCategory[indexPath.row].lowercased())")
        
        tableBerita.reloadData()
        collectionView.reloadData()
    }
}


// Extension table view

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.news.count > 0 {
            return self.news.count - 1
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBerita", for: indexPath) as! Beritacell
        cell.imageThumbnail.isSkeletonable = true
        cell.imageThumbnail.showAnimatedGradientSkeleton()
        cell.labelJudul.isSkeletonable = true
        cell.labelJudul.showAnimatedGradientSkeleton()
        
        if self.news.count > 0 {
            getImageload(url: self.news[indexPath.row + 1].thumbnail, completion: { image, error in
                cell.imageThumbnail.hideSkeleton()
                cell.labelJudul.hideSkeleton()
                
                cell.imageThumbnail.image = image
                cell.imageThumbnail.contentMode = .scaleAspectFill
                cell.labelJudul.text = self.news[indexPath.row + 1].title
            })
        }
        
        return cell
    }
}
