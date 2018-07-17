//
//  ShowViewController.swift
//  ScheduleDisplayer
//
//  Created by Fiel Faustino on 16/07/2018.
//  Copyright © 2018 Fiel Faustino. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var showTime: UILabel!
    @IBOutlet weak var showSummary: UITextView!
    @IBOutlet weak var showSummaryHeightConstraint: NSLayoutConstraint!
    
    var show = TVShow(name: "", startTime: "", endTime: "", channel: "", rating: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        
        showSummary.isScrollEnabled = false
        showSummary.isEditable = false
        showSummary.isSelectable = false
        
        formatDisplay()
        assignData()
        getShowDescription()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formatDisplay() {
        showImage.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        ratingImage.contentMode = .left
        
        if (show.name == "World News Australia" || show.name == "Ten Late News")
        {
            showImage.contentMode = .scaleAspectFit
        }
        else {
            showImage.contentMode = .scaleAspectFill
            showImage.clipsToBounds = true;
        }
    }
    
    func assignData() {
        navigationItem.title = show.name
        channelName.text = show.getChannelName()
        let showTime = "\(show.startTime) - \(show.endTime)"
        self.showTime.text = showTime
        
        ratingImage.image = HelperFunctions.scaleImagetoHeight(image: show.getRatingImage(), desiredHeight: 18)    
        showImage.image = show.getShowImage()
    }
    
    func getShowDescription() {
        var showDescription = ""
        guard let url = Bundle.main.url(forResource: "ShowDescriptions", withExtension: "json") else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            
                        DispatchQueue.main.async {
            guard let data = data else { return }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data) as! [String: AnyObject]
                
                showDescription = result[self.show.name] as! String
                print(result[self.show.name])
                
                
                // Update summary text field size for longer texts
                self.showSummary.text = showDescription
                
                let newSize = self.showSummary.sizeThatFits(CGSize(width: self.showSummary.frame.width, height: CGFloat.greatestFiniteMagnitude))
                
                var newFrame = self.showSummary.frame
                newFrame.size = CGSize(width: max(newSize.width, self.showSummary.frame.width), height: newSize.height)
                
                self.showSummary.frame = newFrame
                //
                
                // Update scroll view size and constraints
                let heightDiff = newSize.height - self.showSummary.frame.height
                
                self.showSummaryHeightConstraint.constant = newSize.height
                self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height + heightDiff)
                //
                
            }
            catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
                        }
            }.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
