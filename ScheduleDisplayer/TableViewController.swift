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

class TableViewController: UITableViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var shows = [TVShow]()
    var batch = 0
    var selectedShow = TVShow(name: "", startTime: "", endTime: "", channel: "", rating: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
                    
                    self.loadingIndicator.stopAnimating()
                    
                    self.tableView.reloadData()
                    
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
        }.resume()
        
        self.batch += 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        let show = shows[indexPath.row]
        
        cell.showName.text = show.name
        cell.channelImg.image = show.getChannelImage()
        cell.ratingImg.image = HelperFunctions.scaleImagetoHeight(image: show.getRatingImage(), desiredHeight: 15)
        
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
