//
//  ViewController.swift
//  ScheduleDisplayer
//
//  Created by Fiel Faustino on 12/07/2018.
//  Copyright © 2018 Fiel Faustino. All rights reserved.
//

import UIKit

struct WBResponse: Decodable {
    let results: [TVShow]
    let count: Int
}

struct showImageSet {
    var name: String
    var channelImage: UIImage
    var smallRatingImage: UIImage
    
    init(name: String, channelImage: UIImage, smallRatingImage: UIImage) {
        self.name = name
        self.channelImage = channelImage
        self.smallRatingImage = smallRatingImage
    }
}

class TableViewController: UITableViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var shows = [TVShow]()
    var showImages = [showImageSet]()
    var batch = 0
    var selectedShow = TVShow(name: "", startTime: "", endTime: "", channel: "", rating: "")
    var refreshEnabled = false
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.gray
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refresher
    }()
    
    @objc
    func refreshData() {
        // Refresh enabled only when there is a connection or json failure
        if refreshEnabled {
            fetchResults(batch: batch)
            refreshEnabled = false
        }
        
        // Add delay when using refresh control
        let timeDelay = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: timeDelay) {
            self.refresher.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.refreshControl = refresher
        
        let customCellNib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(customCellNib, forCellReuseIdentifier: "customCell")
        
        navigationItem.title = "My Movies"
        fetchResults(batch: batch)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // fetch results from url
    func fetchResults(batch: Int){
        let urlString = "https://www.whatsbeef.net/wabz/guide.php?start=\(batch * 10)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            DispatchQueue.main.async {
                if let err = err {
                    // Error if there is a connection failure
                    print("Failed to get data from url:", err)
                    
                    self.loadingIndicator.stopAnimating()
                    self.refreshEnabled = true
                    HelperFunctions.showAlert(title: "Error", message: "Connection failure. Pull screen down to refresh.", buttonText: "OK", viewController: self)
                    
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let wbResponse = try decoder.decode(WBResponse.self, from: data)
                    
                    print(wbResponse)
                    
                    self.shows.append(contentsOf: wbResponse.results)
                    
                    var i = 1;
                    for show in self.shows {
                        print("Show \(i): \(show.rating)");
                        i+=1;
                    }
                    
                    // Assign images to the proper show
                    for i in self.batch * 10..<self.shows.count {
                        let name = self.shows[i].name
                        let channelImage = self.shows[i].getChannelImage()
                        let smallRatingImage = HelperFunctions.scaleImagetoHeight(image: self.shows[i].getRatingImage(), desiredHeight: 15)
                        
                        let showImgSet = showImageSet(name: name, channelImage: channelImage, smallRatingImage: smallRatingImage)
                        
                        self.showImages.append(showImgSet)
                    }
                    
                    self.batch += 1
                    
                    self.loadingIndicator.stopAnimating()
                    
                    self.tableView.reloadData()
                    
                } catch let jsonErr {
                    // Error with JSON
                    print("Error serializing json:", jsonErr)
                    
                    self.loadingIndicator.stopAnimating()
                    self.refreshEnabled = true
                    HelperFunctions.showAlert(title: "Error", message: "There was an error fetching the data. Pull screen down to refresh.", buttonText: "OK", viewController: self)
                }
            }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        let show = shows[indexPath.row]
        
        cell.showName.text = show.name
        cell.channelImg.image = showImages[indexPath.row].channelImage
        cell.ratingImg.image = showImages[indexPath.row].smallRatingImage
        
        let showTime = "\(show.startTime) - \(show.endTime)"
        cell.showTime.text = showTime

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElem = shows.count - 1
        
        if indexPath.row == lastElem && shows.count < 28 {
            loadingIndicator.startAnimating()
            
            fetchResults(batch: batch)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedShow = shows[indexPath.row]
        
        self.performSegue(withIdentifier: "showShowVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showShowVC") {
            let destinationVC: ShowViewController = segue.destination as! ShowViewController
            
            destinationVC.show = selectedShow
        }
    }
}
