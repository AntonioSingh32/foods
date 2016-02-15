//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate,UIScrollViewDelegate{

    var businesses: [Business]!
    var load : Bool! = false
    var filteredbusinness: [Business]!
    
    
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let yelpbar = UISearchBar()
        yelpbar.delegate = self
        
        yelpbar.sizeToFit()
        navigationItem.titleView = yelpbar
        
        if let yelpbar = navigationController?.navigationBar {
        yelpbar.setBackgroundImage(UIImage(named: "foodvector"), forBarMetrics: .Default)
         yelpbar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
        }

        

        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
    
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
        
        
/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
        
*/
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        if(filteredbusinness == nil) {
            filteredbusinness = businesses
        }
       
        if searchText.isEmpty {
            businesses = filteredbusinness
        }
        else {
            businesses = businesses.filter({(dataItem: Business) -> Bool in
               
                if dataItem.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        
        tableView.reloadData()
        
    }

    func loadMoreData() {
        
        let myRequest = NSURLRequest()
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,
            completionHandler: { (data, response, error) in
                
                self.load = false
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                self.tableView.reloadData()
        });
        task.resume()
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!load) {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                
                load = true
                
                self.tableView.reloadData()
                self.load = false
            }
            
        }
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
