//
//  ViewController.swift
//  project1
//
//  Created by Madiapps on 16/07/2022.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var viewCount = [String:Int]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        loadData()
    }
    
    func loadData() {
        DispatchQueue.global(qos: .userInitiated).async {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            if let savedData = self.defaults.object(forKey: "view") as? [String:Int] {
                for item in items {
                    if item.description.hasPrefix("nssl") {
                        self.pictures.append(item)
                    }
                }
                self.viewCount = savedData
            } else {
                for item in items {
                    if item.description.hasPrefix("nssl") {
                        self.pictures.append(item)
                        self.viewCount[item] = 0
                    }
                }
            }
            self.pictures.sort()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func save() {
        defaults.set(viewCount, forKey: "view")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        guard let palatino = UIFont(name: "Palatino", size: 24) else {
            fatalError("Font not loaded")
        }
        cell.textLabel?.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: palatino)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Nombre de vues: \(viewCount[pictures[indexPath.row]]!) fois"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.subTitleOnNavBar = "\(indexPath.row)/\(pictures.count)"
            
            viewCount[pictures[indexPath.row]]! += 1
            save()
            tableView.reloadData()
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

