//
//  AppDelegate.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 13/06/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate {
                            
    var window: UIWindow?
    var locationManager=SUPLocationManager() // a gloabl location manger object
    var appSettings:AppSettings? = nil
    var pbs:PersonalBests? = nil
    
    var localDBPref=1
    var managedObjectURL = NSBundle.mainBundle().URLForResource("WhatSUP1", withExtension: "momd")
    var dataReady=false
    var appReady=false;
    var timer : NSTimer? = nil
    
    var amBusyWithCloud=false

    // used to queue up items for CloudKit..
    var allRecordsToSave:NSMutableArray = NSMutableArray()
    var allRecordsToRemove:NSMutableArray = NSMutableArray()
    var allRecordsToAdd:NSMutableArray = NSMutableArray()
    var ckMap:NSMutableArray=NSMutableArray()
    var entryArrayLock:NSLock = NSLock() // controls access to 'allRecordsToSave'
    var deleteArrayLock:NSLock = NSLock() // controls access to 'allRecordsToDelete'
    var amBusyWoithCloudKit=false
    var ckTimer : NSTimer? = nil

    func getAppSettings()-> AppSettings?{
        if dataReady && appReady{
            if var a=appSettings{
            }else{
                getOrCreateNewAppSettings()
            }
            return appSettings!
        }else{
            return nil
        }
    }
    
    func getPBS()-> PersonalBests?{
        if dataReady && appReady{
            if var p=pbs{
            }else{
                getOrCreateNewPBS()
            }
            return pbs!

        }else{
            // still loading
            return nil
        }
    }
    
   // func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
   // }
    /*- (BOOL)application:(UIApplication *)application
    openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
    annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }*/

    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        
         // check the icloud functionality
        var currentIcloudToken=NSFileManager.defaultManager().ubiquityIdentityToken;
        
        if (currentIcloudToken != nil) {
            // store the token locally
            var newtd=NSKeyedArchiver.archivedDataWithRootObject(currentIcloudToken!);
            NSUserDefaults.standardUserDefaults().setObject(newtd, forKey: "com.apple.WhatsUP.UbiquityIdentityToken")
            NSUserDefaults.standardUserDefaults().synchronize()
        }else{
            NSUserDefaults.standardUserDefaults().removeObjectForKey( "com.apple.WhatsUP.UbiquityIdentityToken")
        }
        
        // is this the first run of the app
        var useLocalDB = NSUserDefaults.standardUserDefaults().objectForKey("com.apple.WhatsUP.useLocalDB") as String?
        
        var realFirstRun = 1
        if var tfirstRun:String = useLocalDB {
            realFirstRun=0;
            if(tfirstRun=="yes"){
                localDBPref=1
            }else{
                localDBPref=0
            }
        }
        
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector :"iCloudAccountAvailabilityChanged",name:NSUbiquityIdentityDidChangeNotification,object:nil)
        
        
        if(realFirstRun==1){
                var alert=UIAlertView(title: "Choose Storage Option", message: "Should documents be stored in iCloud and available on all your devices?", delegate: self, cancelButtonTitle: "Local Only", otherButtonTitles: "Use iCloud")
                alert.show()

        }else{
            notificationCenter.addObserver(self, selector :"storesWillChange:",name:NSPersistentStoreCoordinatorStoresWillChangeNotification,object:self.persistentStoreCoordinator)
            notificationCenter.addObserver(self, selector :"storesDidChange:", name:NSPersistentStoreCoordinatorStoresWillChangeNotification,object:self.persistentStoreCoordinator)
            notificationCenter.addObserver(self, selector :"persistentStoreDidImportUbiquitousContentChanges:",name:NSPersistentStoreDidImportUbiquitousContentChangesNotification,object:self.persistentStoreCoordinator)
      

            self.appReady=true
            self.loadUpPage()

        }
        
        if ckTimer==nil{
            ckTimer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("saveRecordsToTheCloud"), userInfo: nil, repeats: true)
        }

        return true
    }


    func loadUpPage(){
        // load up the global settings object if there is one
        getOrCreateNewPBS()
        getOrCreateNewAppSettings()
        
        self.appReady=true
        self.dataReady=true
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector :"storesWillChange:",name:NSPersistentStoreCoordinatorStoresWillChangeNotification,object:self.persistentStoreCoordinator)
        notificationCenter.addObserver(self, selector :"storesDidChange:", name:NSPersistentStoreCoordinatorStoresWillChangeNotification,object:self.persistentStoreCoordinator)
        notificationCenter.addObserver(self, selector :"persistentStoreDidImportUbiquitousContentChanges:",name:NSPersistentStoreDidImportUbiquitousContentChangesNotification,object:self.persistentStoreCoordinator)
        self.refreshMainPage()
    }
    
    func getOrCreateNewAppSettings()->Bool{
        var error: NSError? = nil
        var fReq: NSFetchRequest! = NSFetchRequest(entityName: "AppSettings")
        var result = managedObjectContext!.executeFetchRequest(fReq, error:&error)
        if(error != nil){
            var av=UIAlertView(title: "Error", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Close")
            av.show()
            return false
        }else{
            var foundcount=0
            if var res=result{
                for resultItem : AnyObject in res {
                    foundcount++
                    if foundcount > 1 {
                        managedObjectContext!.deleteObject(resultItem as NSManagedObject  )
                    }else{
                        appSettings=(resultItem as AppSettings)
                    }
                }
            }
            
            // create a new one!
            if foundcount == 0 {
                appSettings = NSEntityDescription.insertNewObjectForEntityForName("AppSettings", inManagedObjectContext: managedObjectContext!) as? AppSettings
                appSettings!.startdelay=5
                appSettings!.usemagneticnorth=0
                appSettings!.usemiles=0
                appSettings!.autoPostToCloud=1
                if localDBPref==1{
                    appSettings!.useCloudStorage=0
                }else{
                    appSettings!.useCloudStorage=1
                }
                managedObjectContext!.save(&error)
                if(error != nil){
                    var av=UIAlertView(title: "Error", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "Close")
                    av.show()
                    return false
                }
            }
        }
        return true
    }
    
    func getOrCreateNewPBS()->Bool{
        var error: NSError? = nil
        var fReq: NSFetchRequest! = NSFetchRequest(entityName: "PersonalBests")
        var result = managedObjectContext!.executeFetchRequest(fReq, error:&error)
        if(error != nil){
            var av=UIAlertView(title: "Error", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Close")
            av.show()
            return false
        }else{
            var foundcount=0
            if var res=result{
                for resultItem : AnyObject in res {
                    foundcount++
                    if foundcount > 1 {
                        managedObjectContext!.deleteObject(resultItem as NSManagedObject  )
                    }else{
                        pbs=(resultItem as PersonalBests)
                    }
                }
            }
            // create a new one!
            if foundcount == 0 {
                pbs = NSEntityDescription.insertNewObjectForEntityForName("PersonalBests", inManagedObjectContext: managedObjectContext!) as? PersonalBests
                pbs!.longest=nil
                pbs!.farthest=nil
                pbs!.best1k=nil
                pbs!.best5k=nil
                pbs!.best10k=nil
                pbs!.best1m=nil
                pbs!.best5m=nil
                pbs!.best10m=nil
                pbs!.totaldistance = NSNumber.numberWithDouble(0.0)
                
                managedObjectContext!.save(&error)
                if(error != nil){
                    var av=UIAlertView(title: "Error", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "Close")
                    av.show()
                    return false
                }
            }
        }
        return true
    }

    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        // should we use local or cloud data storage
        if buttonIndex==0{
            NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "com.apple.WhatsUP.useLocalDB")
            localDBPref=1
        }else{
             NSUserDefaults.standardUserDefaults().setObject("no", forKey: "com.apple.WhatsUP.useLocalDB")
            localDBPref=0
        }
        NSUserDefaults.standardUserDefaults().synchronize()
        self.loadUpPage()
    }

    func deleteCloudData(){
        if self.localDBPref == 0 { // only do this if we are in the cloud...
            var error:NSError?=nil
            var storeOptions:[NSObject:AnyObject] = [NSPersistentStoreUbiquitousContentNameKey:"WhatsSUPCloudStore"]
            NSPersistentStoreCoordinator.removeUbiquitousContentAndPersistentStoreAtURL(self.managedObjectURL!, options: storeOptions, error: &error)
        }
    }

    func persistentStoreDidImportUbiquitousContentChanges(changeNotification:NSNotification){
        self.managedObjectContext!.performBlock({self.managedObjectContext!.mergeChangesFromContextDidSaveNotification(changeNotification)})
        self.refreshMainPage()

    }
    func iCloudAccountAvailabilityChanged(changeNotification:NSNotification){
        // ++ do something
    }


    func storesWillChange(notification: NSNotification ) {
        var context = self.managedObjectContext!
	
        context.performBlockAndWait{
            var error: NSError? = nil
            var hasChanges=context.hasChanges

            if hasChanges {
                var success = context.save(&error)
            
                if (!success ) {
                // perform error handling
                    NSLog("%@",error!.description)
                }
            }
    
            context.reset()
            dispatch_async(dispatch_get_main_queue(), {
                    self.refreshMainPage()
            })
        }
        NSLog("Stores will Change")
    }

    func refreshMainPage(){
        if var view=getTopMostController() as? UINavigationController{
            if timer != nil {
                timer!.invalidate()
                timer=nil
            }
            var top = view.topViewController
            if let topui = top as? SUPMainMenu {
                topui.refreshData()
            }else if let topui = top as? HistoryList{
                topui.refreshData()
            }

            
        }else{

            
            if timer==nil{
                timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("delayRefresh"), userInfo: nil, repeats: true)
            }
        }
    }

    // this should clean up any posts to the cloud that are not complete yet - error handling
    func checkPostsToCloudAreComplete(){
        
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
                        if supPath.fullypostedtocloud != true && supPath.cloudKitId != nil{
                            var records:NSArray!=supPath.saveToCloudKit()
                            if var recs=records{
                                del.queueRecordsToSaveToTheCloud(recs)
                            }
                        }
                    }
                }
            }else{
                var av = UIAlertView(title: "ERROR", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                av.show()
            }
        }

    }
    func delayRefresh() {
            refreshMainPage()
    }

    func storesDidChange(notification:NSNotification) {
        NSLog("Stores Did Change")
        self.refreshMainPage()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()

    }
    
    
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.eiiconsulting.testcoredata" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let del = UIApplication.sharedApplication().delegate as AppDelegate
        
        let modelURL = NSBundle.mainBundle().URLForResource("WhatSUP1", withExtension: "momd")
        return NSManagedObjectModel(contentsOfURL: modelURL!)
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("WhatSUP1.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."

        let del = UIApplication.sharedApplication().delegate as AppDelegate
        if del.localDBPref==1{

            println("using local database")
            if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
                coordinator = nil

                // Report any error we got.
                let dict = NSMutableDictionary()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                dict[NSUnderlyingErrorKey] = error
                error = NSError.errorWithDomain("YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                // Replace this with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }else{
            println("using cloud database")
            var storeOptions:[NSObject:AnyObject] = [NSPersistentStoreUbiquitousContentNameKey:"WhatsSUPCloudStore"]
            var store=coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: storeOptions, error: &error)
            if  store == nil {
                coordinator = nil
                // Report any error we got.
                let dict = NSMutableDictionary()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                dict[NSUnderlyingErrorKey] = error
                error = NSError.errorWithDomain("YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                // Replace this with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }else{
                del.managedObjectURL=store!.URL
                
            }
        }
              
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    

    func getTopMostController()->UIViewController?{
        if appReady{
            var kw=UIApplication.sharedApplication().keyWindow
            if var tc=kw.rootViewController{
                while((tc.presentedViewController) != nil){
                    tc=tc.presentedViewController!
                }
                return tc;
            }
        }
        return nil
    }
    

    func saveRecordsToTheCloud(){
        if !appReady{
            return // get out quick
        }
        if !dataReady{
            return // get out quick
        }
        if amBusyWoithCloudKit{
            return // get out quick
        }
        amBusyWoithCloudKit=true
        checkPostsToCloudAreComplete()
        
        // lock the records
        entryArrayLock.lock()
        println("Proccessing for cloud")
        println("New Records To Add \(allRecordsToAdd.count)")
        var maxCount=399
        // copy the records tothe all records to save array
        for rec in allRecordsToAdd{
            if !allRecordsToSave.containsObject(rec){
                var isFound=false
                if var mapRec:CKToCDMap = rec as? CKToCDMap {
                    for rec2 in self.allRecordsToSave{
                        if var mapRec2:CKToCDMap = rec2 as? CKToCDMap {
                            if var cdref=mapRec.cdRef{
                                if var cdref2=mapRec2.cdRef{
                                    if cdref.objectID.URIRepresentation() == cdref2.objectID.URIRepresentation() {
                                        isFound=true
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
                if !isFound{
                    allRecordsToSave.addObject(rec)
                }
            }
            if allRecordsToSave.count > maxCount {
                break
            }
        }
        println("New Records To Save \(allRecordsToSave.count)")
        
        
        // remove the items from teh allRecordsToAdd list
        allRecordsToAdd.removeObjectsInArray(allRecordsToSave)
        // let others add to it again
        entryArrayLock.unlock()

        
        deleteArrayLock.lock()
        // clear the removal list
        allRecordsToRemove.removeAllObjects()
        
        // Define two call backs for saving to the cloud
        var tmp:(record:CKRecord!, error:NSError!) -> Void = {(record:CKRecord!, error:NSError!) -> Void in
            // deal with conflicts
            if var err = error{
                NSLog("@Error Saving Batch record to cloud: %@",err.description)
            }else{
                // need to update that record in the database
                for rec in self.allRecordsToRemove{
                    if var mapRec:CKToCDMap = rec as? CKToCDMap {
                        if mapRec.ckRef! == record! {
                            if var prec:SavedSUPPath = mapRec.cdRef as? SavedSUPPath{
                                prec.cloudKitId=mapRec.ckRef!.recordID.description
                                prec.fullypostedtocloud=true
                            }
                        }
                    }
                }
            }
        }
        var tmp2:(savedRecords:[AnyObject]?, deletedRecordIDs:[AnyObject]?, error:NSError?) -> Void = { (savedRecords:[AnyObject]?, deletedRecordIDs:[AnyObject]?, error:NSError?) in
            // deal with conflicts
            // set completionHandler of wrapper operation if it's the case
            if var err = error{
                NSLog("@Error Saving Batch to cloud : %@",err.description)
                // recover
                for rec in self.allRecordsToRemove{
                    if var mapRec:CKToCDMap = rec as? CKToCDMap {
                        if var prec:SavedSUPPath = mapRec.cdRef as? SavedSUPPath{
                            prec.cloudKitId=""
                        }
                    }
                }
                self.deleteArrayLock.lock()
                self.allRecordsToRemove.removeAllObjects()
                self.deleteArrayLock.unlock()
                dispatch_async(dispatch_get_main_queue(), {
                    let del = UIApplication.sharedApplication().delegate as AppDelegate
                    var error:NSError?=nil
                    del.managedObjectContext?.save(&error)
                })
            }else{
                self.deleteArrayLock.lock()
                self.allRecordsToSave.removeObjectsInArray(self.allRecordsToRemove)
                self.allRecordsToRemove.removeAllObjects()
                self.deleteArrayLock.unlock()
                
                dispatch_async(dispatch_get_main_queue(), {
                    let del = UIApplication.sharedApplication().delegate as AppDelegate
                    var error:NSError?=nil
                    del.managedObjectContext?.save(&error)
                })
                println(" !!!!!!!!!!!!!!!!!!!!!!!! SAVED A BATCH TO THE CLOUD !!!!!!!!!!!!!!!!!!  ")
            }
            self.amBusyWoithCloudKit=false
        }
        

        // check if there are any records to save to the cloud
        if allRecordsToSave.count>0{
            // save the records to the cloud 399 at a time...
            
            var freeBufferSize=399
            var posted=false
            
            for rec in allRecordsToSave {
                freeBufferSize = freeBufferSize - 1
                
                if  freeBufferSize>0 {
                    allRecordsToRemove.addObject(rec)
                }else{
                    // save the records
                    var publicDB=CKContainer.defaultContainer().publicCloudDatabase
                    var op=CKModifyRecordsOperation()
                    op.savePolicy=CKRecordSavePolicy.AllKeys
                    // convert the records to simple CKRecords
                    var realVals:NSMutableArray = NSMutableArray()
                    for rec in allRecordsToRemove {
                        // here we need to check what the ckRef is
                        if var ss:ScaleSaver = rec as? ScaleSaver{
                            // oddly enough need to do this asynchronously..
                            addRecordToQueue(ss)
                        }else{
                            realVals.addObject(rec.ckRef!)
                        }
                    }
                    op.recordsToSave=realVals
                    op.perRecordCompletionBlock = tmp
                    op.modifyRecordsCompletionBlock  = tmp2
                    publicDB.addOperation(op)
                    posted=true
                    break // get out of the for loop
                }
            }
            // if we have not posted the last chunk then post it now...
            if !posted {
                // save the records
                var publicDB=CKContainer.defaultContainer().publicCloudDatabase
                var op=CKModifyRecordsOperation()
                op.savePolicy=CKRecordSavePolicy.AllKeys
                // remove the
                // convert the records to simple CKRecords
                var realVals:NSMutableArray = NSMutableArray()
                for rec in allRecordsToRemove {
                    // here we need to check what the ckRef is
                    if var ss:ScaleSaver = rec as? ScaleSaver{
                        // oddly enough need to do this asynchronously..
                        addRecordToQueue(ss)
                    }else{
                        realVals.addObject(rec.ckRef!)
                    }
                    //realVals.addObject(rec.ckRef!)
                }
                op.recordsToSave=realVals
                op.perRecordCompletionBlock = tmp
                self.amBusyWoithCloudKit=false; // should use a semaphore here really.
                op.modifyRecordsCompletionBlock  = tmp2
                publicDB.addOperation(op)
            }

        }else{
            amBusyWoithCloudKit=false
        }
        deleteArrayLock.unlock()

    }

    // adds all the new records to the global array ready to be stored
    func queueRecordsToSaveToTheCloud(newRecs:NSArray){
        // this will lock the thread until someone else releases it
        entryArrayLock.lock()
        for rec in newRecs{
            if !allRecordsToAdd.containsObject(rec){
                allRecordsToAdd.addObject(rec)
            }
        }
        // unlock the array
        entryArrayLock.unlock()
    }
    
    func addRecordToQueue(ss : ScaleSaver){
        var pred=NSPredicate(format:"gridX=%lf and gridY=%lf",ss.scale,ss.gridX,ss.gridY)
        var nsn=NSNumber.numberWithDouble(ss.scale)
        nsn.intValue
        var recordType = "ScaledArea\(nsn.intValue)"
        println("Record type \(recordType)")
        var query=CKQuery(recordType: recordType, predicate:pred)
        var pubDB=CKContainer.defaultContainer().publicCloudDatabase;
        
        pubDB.performQuery( query, inZoneWithID: nil) { (results:[AnyObject]!, error:NSError!) -> Void in
            if var err=error{
                println("Error querying for items at  scale: \(err.description)")
            }else{
                // if there is one then cool
                // if there is not one then create one
                if(results.count>0){
                    // do nothing
                }else{
                    // create a new one
                    //CKRecord * pathRec= [[CKRecord alloc ] initWithRecordType:@"SavedSUPPath"];
                    var scaleRec = CKRecord(recordType: recordType)
                    scaleRec.setObject(ss.gridX, forKey: "gridX")
                    scaleRec.setObject(ss.gridY, forKey: "gridY")
                    scaleRec.setObject(ss.location, forKey: "location")
                    // create the elements to return
                    
                    var ret:CKToCDMap = CKToCDMap()
                    ret.cdRef=nil
                    ret.ckRef=scaleRec
                    var arr = NSMutableArray()
                    arr.addObject(ret)
                    self.queueRecordsToSaveToTheCloud(arr)
                    
                }
            }
        }
    }
    
    /*
    NSPredicate* pred=NSPredicate(@"scale= < %f and gridX=%f and gridY=%f",[self scale],[self gridX],[self gridY]);
    NSNumber * nsn=[NSNumber numberWithDouble:[self scale]];
    
    NSString *s = [NSString stringWithFormat:@"ScaledArea%d",[nsn intValue] ];
    
    CKQuery * query = [[CKQuery alloc] initWithRecordType:s predicate:pred];
    CKDatabase* pubDB=[[CKContainer defaultContainer] publicCloudDatabase];
    [pubDB performQuery:query]
    
    [pubDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
    if (error!=nil){
    NSLog(@"Error fetching records %@", error.description);
    
    }else{
    if(results.count>0){
    // process the records
    for (int i=0;i<results.count;i++){
    if (i==0){
    // only care about the first one
    
    }
    
    }
    }else{
    // create a new one
    }
    }
    }]
    
    }*/

    
}


