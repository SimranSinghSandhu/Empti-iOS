//
//  ShopCollectionViewController.swift
//  Test
//
//  Created by Simran Singh Sandhu on 05/01/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class ShopCollectionViewController: UICollectionViewController {

    var shopDetail: ShopModal?
    let cellId = "col_cell_id"
    let imageBaseURLString: String = "https://empti.org/empti/public/images/containers/"
    
    var bearerToken: String? {
        didSet {
            
            NetworkManager.shared.getShopDetails(token: bearerToken!) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let shopDetails):
                    self.shopDetail = shopDetails
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }   
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return shopDetail?.data.containerDetail.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomColViewCell
        
        guard let containerDetails = shopDetail?.data.containerDetail[indexPath.row] else {return cell}
        
        guard let url = URL(string: "\(imageBaseURLString + containerDetails.photo)") else {return cell}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let error = err {
                print(error)
            }
            
            guard let data = data else {return}
            
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: data)
            }
        }.resume()
        
        
        
        cell.storeName.text = containerDetails.name
        cell.availableCount.text = "Available\n" + "\(containerDetails.available_container)"
        cell.totalCount.text = "Total\n" + "\(containerDetails.total_container)"
    
        return cell
    }

}

class CustomColViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var availableCount: UILabel!
    @IBOutlet weak var totalCount: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
