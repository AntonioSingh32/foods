//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate{

    var businesses: [Business]!
    var search : Bool!
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
        // When there is no text, filteredBusinesses is the same as the original businesses data
        if(filteredbusinness == nil) {
            filteredbusinness = businesses
        }
        // The user has entered text into the search box
        // Use the filter method to iterate over all items in the businesses data
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        if searchText.isEmpty {
            businesses = filteredbusinness
        }
        else {
            businesses = businesses.filter({(dataItem: Business) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if dataItem.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        
        tableView.reloadData()
        
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
