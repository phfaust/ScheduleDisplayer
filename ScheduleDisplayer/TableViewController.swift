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
    var shows = [TVShow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customCellNib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(customCellNib, forCellReuseIdentifier: "customCell")
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "My Shows"
        fetchResults()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // fetch results from url
    func fetchResults(){
        let urlString = "https://www.whatsbeef.net/wabz/guide.php?start=1"
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
                    
                    self.tableView.reloadData()
                    
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
        }.resume()
    }
    
    func getRatingImage(rating: String) -> UIImage {
        return UIImage(named: rating)!
    }
    
    func getChannelImage(channel: String) -> UIImage {
        return UIImage(named: channel)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId") as! TableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        let show = shows[indexPath.row]
        
        cell.showName.text = show.name
        cell.channelImg.image = getChannelImage(channel: show.channel)
        cell.ratingImg.image = getRatingImage(rating: show.rating)
        
        let showTime = "\(show.startTime) - \(show.endTime)"
        cell.showTime.text = showTime

        return cell
    }
}
