//
//  ViewController.swift
//  RealmSample
//
//  Created by Prince on 01/10/17.
//  Copyright © 2017 Prince. All rights reserved.
//

import UIKit
import RealmSwift

class BeingHuman{
    
    var name = String()
    var age = Int()
    var race = String()
    
    init(){}
    
    init(test: Human){
        self.name = test.name
        self.age = test.age
        self.race = test.race
    }
}

class ViewController: UIViewController {
    
    var people = [Human]()
    var peopleAge: [Int]?
    var peopleRace: [String]?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        addHuman()
        queryPeople()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addHuman(){
        
        let pratyush = Human()
        pratyush.name = "Bebo"
        pratyush.age = 21
        pratyush.race = "India"
        
        let realm = try? Realm()
        
        try? realm?.write {
            realm?.add(pratyush)
            print("Added \(pratyush.name) to Realm")
            print("Added \(pratyush.age) to Realm")
            print("Added \(pratyush.race) to Realm")

        }
        
        
    }
    
    func queryPeople(){
        
        let realm = try? Realm()

        let allPeople = realm?.objects(Human.self)
        
        allPeople?.forEach({ (person) in
            self.people.append(person)
        })

        let matured = allPeople?.filter("age == 22")
        matured?.forEach({ (people) in
            print("\(people)  matured")
        })
        
        let kid = allPeople?.filter("age < 22")
        kid?.forEach({ (kids) in
            print("\(kids) kid")
        })
        
        let smartPeople = allPeople?.filter("name BEGINSWITH 'P'")
        smartPeople?.forEach({ (people) in
            print("\(people) smartPeople")
        })
        
        let sortName = allPeople?.sorted(byKeyPath: "name", ascending: false)
        
        sortName?.forEach({ (person) in
            print("\(person.name) is \(person.age) years old of race \(person.race)  sorted")
        })
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.lblName.text = people[indexPath.row].name
        cell.lblAge.text = "\(people[indexPath.row].age)"
        cell.lblRace.text = people[indexPath.row].race
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.people.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if textField.text?.characters.count ?? 0 > 0{
                let realm = try? Realm()
                let predicate = NSPredicate.init(format: "name CONTAINS [c] %@", textField.text ?? "")
                let filteredPeople = realm?.objects(Human.self).filter(predicate)
                filteredPeople?.forEach({ (each) in
                    self.people += [each]
                    self.tableView.reloadData()
                })
            }
            else{
                
                self.queryPeople()
                self.tableView.reloadData()

            }
        }
        
        return true
    }
}
