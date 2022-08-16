//
//  SearchViewController.swift
//  InstaClone
//
//  Created by Iksang Yoo on 2022/08/15.
//

import UIKit
import Kingfisher
import AVFoundation
import Firebase

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    let db = Database.database().reference().child("searchHistory")
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        db.observeSingleEvent(of: .value) { snapshot in
//            guard let searchHistory = snapshot.value as? [String: String] else { return  }
//            let searchTerms = searchHistory.map { (key, value) -> String in
//                return value
//            }
//            print("---> print \(searchTerms), \(snapshot.value)")
//        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    // 몇개 넘어오니?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    // 어떻게 표현할거니?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.item]
        let url = URL(string: movie.thumbnailPath)!
        cell.movieThumbnail.kf.setImage(with: url)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // movie
        // player vc
        // player vc + movie
        // presenting player vc
        
        let movie = movies[indexPath.item]
        let url = URL(string: movie.previewURL)!
        let item = AVPlayerItem(url: url)
        print(indexPath.item)
//        print(movie)
        let sb = UIStoryboard(name: "Player", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
        vc.modalPresentationStyle = .fullScreen

        vc.player.replaceCurrentItem(with: item)
        present(vc, animated: false, completion: nil)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 8
        let itemSpacing: CGFloat = 10
        let width = (collectionView.bounds.width - margin * 2 - itemSpacing * 2) / 3
        let height = width * 10/7
        return CGSize(width: width, height: height)
    }
}

class ResultCell: UICollectionViewCell {
    @IBOutlet weak var movieThumbnail: UIImageView!
}




extension SearchViewController: UISearchBarDelegate {
    
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 키보드가 올라와 있을때, 내려가게 처리
        dismissKeyboard()
        // 검색어가 있는지
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        
        SearchAPI.search(searchTerm) { movies in
            // - [x] collectionView로 표현하기
            print("--> 몇개 넘어왔어?? \(movies.count), 첫번째꺼 제목: \(movies.first?.title)")
            DispatchQueue.main.async {
                self.movies = movies
                self.resultCollectionView.reloadData()
                let timestamp = Date().timeIntervalSince1970.rounded()
                let term = searchTerm
                self.db.childByAutoId().setValue(["term": term, "timestamp": timestamp])
            }
        }
        print("--> 검색어: \(searchTerm)")
    }
}

