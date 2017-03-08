//
//  ViewController.swift
//  JOSNSwiftDemo
//
//  Created by Shinkangsan on 12/5/16.
//  Copyright © 2016 Sheldon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    final let urlString = "http://microblogging.wingnity.com/JSONParsingTutorial/jsonActors"
    
    @IBOutlet weak var tableView: UITableView!
    
    var actors = [Actor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: 使用 downloadJsonWithURL 來下載Json資料
        
        self.downloadJsonWithURL()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    func downloadJsonWithURL() {
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
  
                
                if let _actors = jsonObj!.value(forKey: "actors") as? NSArray {
                    for _actor in _actors{
                        if let actorDict = _actor as? NSDictionary {
                            let actor = Actor()
                            if let name = actorDict.value(forKey: "name") {
                                actor.name = name as! String
                            }
                            if let dob = actorDict.value(forKey: "dob") {
                                actor.dob = dob as! String
                            }
                            if let imgURL = actorDict.value(forKey: "image") {
                                actor.imgURL = imgURL as! String
                            }
                            if let descript = actorDict.value(forKey: "description") {
                                actor.descript = descript as! String
                            }
                            self.actors.append(actor)
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        }).resume()
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.nameLabel.text = actors[indexPath.row].name
        cell.dobLabel.text = actors[indexPath.row].dob
    
        
        let imgURL = NSURL(string: actors[indexPath.row].imgURL)
        
        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as? URL)!)
            cell.imgView.image = UIImage(data: data as! Data)
        }
        
        return cell
    }
    
    ///for showing next detailed screen with the downloaded info
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.imageString = actors[indexPath.row].imgURL
        vc.nameString = actors[indexPath.row].name
        vc.dobString = actors[indexPath.row].dob
        vc.descriptString = actors[indexPath.row].descript
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

