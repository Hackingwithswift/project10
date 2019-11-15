//
//  ViewController.swift
//  Project10
//
//  Created by vmulugu on 11/13/19.
//  Copyright © 2019 vmulugu. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Hacking with Swift"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
      //Fetchig the Defaiultd values from data base;
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people")as? Data{
            if let decodedPeople = try?
                NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople)as? [Person]{
                people = decodedPeople
                
                print("the decoded array from NSUserdefaults is: \(people)")
            }
        }
        
        
        
        VNsUserDefaults()

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return people.count
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonalCell else {
            // we failed to get a PersonCell – bail out!
            fatalError("Unable to dequeue PersonCell.")
        }
        let person = people[indexPath.item]
        cell.name.text = person.name
        print("the name is \(person.name)")
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        // if we're still here it means we got a PersonCell, so we can return it
        return cell
    }
    
    @objc func addNewPerson(){
        
        let picker =   UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        

        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage]as? UIImage else {
            return}
        
        let imageName = UUID().uuidString
        let imagepath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try?jpegData.write(to: imagepath)
        }
        
        let person = Person(name: "Unknow", image: imageName)
        people.append(person)
        self.save()
        collectionView.reloadData()
        
        
        
        dismiss(animated: true)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.save()
            self?.collectionView.reloadData()
        })
        
        present(ac, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let nbCol = 2

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(nbCol - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(nbCol))
        return CGSize(width: size, height: size)
    }
    
    func VNsUserDefaults() {
        
        print("Called the NSuser Defaults")
        let defaults = UserDefaults.standard

        defaults.set(25, forKey: "age")
        defaults.set(true, forKey: "UseTouchID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        
        defaults.set("veera", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")

        let array = ["Hello", "World"]
        defaults.set(array, forKey: "SavedArray")
        
        let dict = ["Name":"veera", "Country": "US"]
        defaults.set(dict, forKey: "SaveDict")
        
        
        
        let fetchDict = UserDefaults.standard.dictionary(forKey: "SaveDict")
        print(fetchDict ?? (Any).self)
        let fetchArray = UserDefaults.standard.array(forKey: "SavedArray")
        print("The arrary is : \(String(describing: fetchArray))")
        
        
        
    }
    func save() {
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false){
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "people")
            
        }
         
    }
    
    
}

