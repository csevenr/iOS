//
//  SUPRouteSetUp.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 23/06/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation

import UIKit
import CoreLocation
import MapKit


class HistoryList: UITableViewController, MKMapViewDelegate , UITableViewDelegate, UITableViewDataSource{
    
    
    var temp:[SavedSUPPath]=Array<SavedSUPPath>()
    var pathId: NSManagedObjectID?
    var showall = false
    var myLoc:CLLocation?
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0;
        count = temp.count
        return count;

    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var celldata : SavedSUPPath = temp[indexPath.row]
        var dateFormater : NSDateFormatter = NSDateFormatter()
        dateFormater.dateFormat = "dd MMM yyyy HH:mm:SSz"
        cell.textLabel!.text = dateFormater.stringFromDate(celldata.date)
        cell.backgroundColor = UIColor(red: 171/255, green: 217/255, blue: 233/255, alpha: 10.0)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

            var object:SavedSUPPath = temp[Int(indexPath.item)]
            
            println("You selected cell #\(object.objectID.description)")
            pathId=object.objectID
            performSegueWithIdentifier("showHistoryDetail", sender: self)
    }
    
    
    override func viewDidLoad() {
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        let currentPath=del.locationManager.currentPath
        
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(red: 171/255, green: 217/255, blue: 233/255, alpha: 10.0)

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.refreshData()

    }
    
    func refreshData(){
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        if del.dataReady{
            var error: NSError? = nil
            var fReq: NSFetchRequest = NSFetchRequest(entityName: "SavedSUPPath")
            var sorter: NSSortDescriptor = NSSortDescriptor(key: "date" , ascending: false)
            fReq.sortDescriptors = [sorter]
            
            var result = del.managedObjectContext!.executeFetchRequest(fReq, error:&error)
            if error == nil {
                if var res = result {
                    for resultItem : AnyObject in res {
                        var supPath = resultItem as SavedSUPPath
                        temp.append(supPath)
                        
                        
                        NSLog("Fetched Member for \(supPath.date.description) ")
    /*                    if var coordArray = supPath.getOrderedPath(){
                            for tmp in coordArray {
                                var coord:SavedPathLocations = tmp as SavedPathLocations
                                
                                var lat: Double = coord.lat.doubleValue
                                var lon: Double = coord.lon.doubleValue
                            }
                        }*/
                    }
                }
            }else{
                var av = UIAlertView(title: "ERROR", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                av.show()
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

        
        if(segue.identifier == "showHistoryDetail"){
            let histDet = segue.destinationViewController as SUPHistoryDetail
            histDet.pathId=pathId
        }
        NSLog("Prep for segue \(segue.destinationViewController.name)")
    }
    
   /* - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
    }
    */
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
   /* - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    //remove the deleted object from your data source.
    //If your data source is an NSMutableArray, do this
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [tableView reloadData]; // tell table to refresh now
    }
    }*/
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var celldata : SavedSUPPath = temp[indexPath.row]
        let del = UIApplication.sharedApplication().delegate as AppDelegate

        if var p = del.getPBS(){
            del.pbs!.removePathFromRecords(celldata)
        }
        
        del.managedObjectContext!.deleteObject(celldata)
        var error:NSError? = nil
        del.managedObjectContext!.save(&error)
        if error != nil{
            var av=UIAlertView(title: "Error", message: "Could not delete path", delegate: nil, cancelButtonTitle: "Close")
            av.show()
        }
        self.refreshData()
        tableView.reloadData()
        
        return

    }
    
}

