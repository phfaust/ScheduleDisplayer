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

struct TVShow: Decodable {
    let name: String
    let startTime: String
    let endTime: String
    let channel: String
    let rating: String
}

class TableViewController: UITableViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var shows = [TVShow]()
    var batch = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customCellNib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(customCellNib, forCellReuseIdentifier: "customCell")
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "My Movies"
        fetchResults(batch: batch)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // fetch results from url
    func fetchResults(batch: Int){
        let urlString = "https://www.whatsbeef.net/wabz/guide.php?start=\(batch * 10)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let wbResponse = try decoder.decode(WBResponse.self, from: data)
                    
                    print(wbResponse)
                    
                    self.shows.append(contentsOf: wbResponse.results)
                    
                    var i = 1;
                    for show in self.shows {
                        print("Show \(i): \(show)");
                        i+=1;
                    }
                    
                    self.loadingIndicator.stopAnimating()
                    
                    self.tableView.reloadData()
                    
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
        }.resume()
        
        self.batch += 1
    }
    
    func getRatingImage(rating: String) -> UIImage {
        guard let ratingImg = UIImage(named: rating) else { return UIImage(named: "NR")! }
        return ratingImg
    }
    
    func getChannelImage(channel: String) -> UIImage {
        return UIImage(named: channel)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        let show = shows[indexPath.row]
        
        cell.showName.text = show.name
        cell.channelImg.image = getChannelImage(channel: show.channel)
        cell.ratingImg.image = getRatingImage(rating: show.rating)
        
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
}
