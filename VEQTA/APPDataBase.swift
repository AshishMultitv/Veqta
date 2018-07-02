//
//  APPDataBase.swift
//  VEQTA
//
//  Created by Cybermac002 on 14/09/17.
//  Copyright © 2017 Multitv. All rights reserved.
//

import UIKit
import CoreData

class APPDataBase: NSObject {
    
    
    //MARK:- Save Download video id
    static func saveIapfalierdata(orderid:String,userid:String,transid:String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "IAP",in: managedContext)!
            let person = NSManagedObject(entity: entity,insertInto: managedContext)
            person.setValue(orderid, forKeyPath: "orderid")
            person.setValue(userid, forKeyPath: "userid")
            person.setValue(transid, forKeyPath: "transid")
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
  //MARK:- GET Download video id
    static func getIAPfaildatabase(userid:String) -> NSDictionary
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var sportsDatabasedictnew = NSDictionary()
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "IAP")
            do {
                let predicate = NSPredicate(format: "(userid = %@)", userid)
                fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                if (manageobject.count>0)
                {
                    let person = manageobject[0]
                    print("contentListArray>>>",person)
                    let Orderid = person.value(forKeyPath: "orderid") as! String
                    let Userid = person.value(forKeyPath: "userid") as! String
                    let Transid = person.value(forKeyPath: "transid") as! String
                    print(Orderid)
                    print(Userid)
                    print(Transid)
                    let dict = ["orderid":Orderid, "userid":Userid,  "transid":Transid]
                   sportsDatabasedictnew = dict as NSDictionary
                    print(sportsDatabasedictnew)
                      return sportsDatabasedictnew
                }
                else
                {
                }
            }
            catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return sportsDatabasedictnew
        
        
    }
  //MARK:- DELETE Download video id
    static func deleteIAPfailddata(userid:String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IAP")
            let predicate = NSPredicate(format: "(userid = %@)", userid)
             let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate])
            fetchRequest.predicate = predicateCompound;
            fetchRequest.returnsObjectsAsFaults = false
            do
            {
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
            } catch let error as NSError {
                print("Deteleting in  error : \(error) \(error.userInfo)")
            }
            
        } else
        {
            // Fallback on earlier versions
        }
        
    }

}
