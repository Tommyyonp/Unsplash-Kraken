//
//  HomePageViewController.swift
//  Unsplash
//
//  Created by Tommy Yon Prakoso on 24/08/22.
//

import UIKit

class HomePageViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noResultLabel: UILabel!

    // MARK: - Variables
    var keyword = "Nature"
    var totalPage = 0
    var currentPage = 1
    var key = Constant.AccessKey
    var baseUrl = Constant.baseURL
    var photoDatas = [PhotosResult]()
    var currentResult: PhotosResult?
    var isNoResult = false {
        didSet {
            if isNoResult {
                noResultLabel.text = "No result found"
                noResultLabel.isHidden = false
            } else {
                noResultLabel.isHidden = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPhotos()
    }
}

extension HomePageViewController {
    private func setupUI(){
        self.title = "Unsplash Kraken"
        navigationController?.navigationBar.prefersLargeTitles = true
        if let layout = collectionView?.collectionViewLayout as? CustomLayout {
          layout.delegate = self
        }

        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        navigationItem.searchController = search

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }


    private func fetchPhotos() {
        let query = keyword.replacingOccurrences(of: "", with: "%10")
        let urlString = baseUrl + "client_id=\(key)&query=\(query)&page=\(currentPage)"

        isNoResult = false

        guard let url = URL(string: urlString) else {
            print("Bad URL")
            return
        }
        let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in

                guard let data = data, error == nil else {
                    print("No Data")
                    return
                }

                guard let decoded = try? JSONDecoder().decode(PhotosResponse.self, from: data) else {
                    print(String(data: data, encoding: .utf8) ?? "No Data")
                    return
            }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let newPhotoDatas = decoded.results
                    let oldPhotoDatas = self.photoDatas
                    self.photoDatas = oldPhotoDatas + newPhotoDatas
                    self.totalPage = decoded.totalPages
                    self.currentPage += 1
                    self.collectionView.reloadData()
                    if self.photoDatas.isEmpty {
                        self.isNoResult = true
                    }
                }
        }.resume()
    }
}


// MARK: - CollectionView
extension HomePageViewController : UICollectionViewDelegate,
                                   UICollectionViewDataSource,
                                   UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photoDatas.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) ->UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                      for: indexPath) as? PhotoCollectionViewCell
        let urlString = photoDatas[indexPath.row].urls.regular
        cell?.imageView.downloadImage(from: urlString)
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        currentResult = photoDatas[indexPath.row]
        let vc = DetailViewController()
        guard let result = currentResult else { return }
        vc.result = result
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == (photoDatas.count - 2) {
            currentPage += 1
        if currentPage <= totalPage {
            fetchPhotos()
            }
        }
    }
}

// MARK: - Custom Layout
extension HomePageViewController: CustomLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView,
                                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
          var height = photoDatas[indexPath.item].height / 10
          if height >= 500 {
              height -= 300
          }
          let imageHeight = CGFloat(height)
          return imageHeight
  }
}

//MARK: - SearchBar
extension HomePageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        keyword = text
        photoDatas.removeAll()
        currentPage = 1
        fetchPhotos()
    }
}

