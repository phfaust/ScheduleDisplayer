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

class ViewController: UIViewController {
    var shows = [TVShow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            }.resume()
    }
}
