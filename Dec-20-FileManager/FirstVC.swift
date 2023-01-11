//
//  ViewController.swift
//  Dec-20-FileManager
//
//  Created by Admin on 20/12/22.
//

import UIKit

protocol fileInputProtocol {
    var inputText: String! { get set }
    var inputFileName: String! { get set }
//    var textFileURL: URL! { get set }
    func createTextFile()
}

class FirstVC: UIViewController, fileInputProtocol {
    
    var left_right_padding: CGFloat = 20
    var inter_cell_spacing: CGFloat = 20
    
    // getting from third
    var inputText: String!
    var inputFileName: String!
//    var numberOfFiles: Int!
//    var textFileURL: URL!
    var value: String = ""
    
    var contents: [String] = []
    var descriptions: [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        reloadTextFiles()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let collectionViewNib = UINib(nibName: Constants.customCVCell, bundle: nil)
        collectionView.register(collectionViewNib, forCellWithReuseIdentifier: Constants.customCVCell)
    }
    
    func reloadTextFiles() {
        let fileManager = FileManager.default
        
        // get documentURL
        guard let documentFolderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        // create subFolder URL
        let subFolderURL = documentFolderURL.appendingPathComponent("New_Folder")
        print(subFolderURL.path)
        // /Users/admin/Library/Developer/CoreSimulator/Devices/872A9E58-1C30-45B6-8951-9243C0EC9505/data/Containers/Data/Application/FEA6FA5F-BC7E-43BA-84D2-B50A38E1940D/Documents/New_Folder
        
//        /Users/admin/Library/Developer/CoreSimulator/Devices/872A9E58-1C30-45B6-8951-9243C0EC9505/data/Containers/Data/Application/2C38EB6C-B7BD-4C4D-B5CB-41597CABA1F0/Documents/New_Folder
        
        // read
        do {
            contents = try fileManager.contentsOfDirectory(atPath: subFolderURL.path)
            contents = contents.sorted()
            for desc in contents {
                let newFileURL = subFolderURL.appendingPathComponent(desc)
                print(newFileURL)
                let insideText = readTextFile(fileURL: newFileURL)
                print(insideText)
                descriptions.append(insideText)
            }
        }
        catch {
            
        }
        collectionView.reloadData()
    }
    
    func createTextFile() {
        let fileManager = FileManager.default
        
        // get documentURL
        guard let documentFolderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        // create subFolder URL
        let subFolderURL = documentFolderURL.appendingPathComponent("New_Folder")
        //print(subFolderURL.path)
        // /Users/admin/Library/Developer/CoreSimulator/Devices/872A9E58-1C30-45B6-8951-9243C0EC9505/data/Containers/Data/Application/FEA6FA5F-BC7E-43BA-84D2-B50A38E1940D/Documents/New_Folder
        
        // create subFolder
        do {
            try fileManager.createDirectory(at: subFolderURL, withIntermediateDirectories: true)
        }
        catch {
            print("\(error) happens!")
        }
        
        // create text string and convert to data
//        let message = "This is new data added"
        let messageData = inputText!.data(using: .utf8)
        
        // create text file URL
        let textFileURL = subFolderURL.appendingPathComponent("\(inputFileName!).txt")
        print(textFileURL)
        
        // create text file
        fileManager.createFile(atPath: textFileURL.path, contents: messageData)
        
//        numberOfFiles = try? fileManager.contentsOfDirectory(atPath: subFolderURL.path).count
        
        
        // read
        do {
            contents = try fileManager.contentsOfDirectory(atPath: subFolderURL.path)
            contents = contents.sorted()
            let insideText = readTextFile(fileURL: textFileURL)
            descriptions.append(insideText)
        }
        catch {
            
        }
        collectionView.reloadData()
        print(contents)
        
        //self.textFileURL = textFileURL
    }
    
    func readTextFile(fileURL: URL) -> String {
        do {
            print(fileURL.path)
            if fileURL.path.hasSuffix(".txt") {
                let readData = try Data(contentsOf: fileURL)
                let readString = String(data: readData, encoding: .utf8) ?? ""
                return readString
            }
            else {
                return ""
            }
        }
        catch {
            //print("\(error) happens while reading data")
            return ""
        }
    }
    
    @IBAction func addFileBtn(_ sender: Any) {
        performSegue(withIdentifier: Constants.gotoThird, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constants.gotoThird) {
            if let third = segue.destination as? ThirdVC {
                third.delegate = self
            }
        }
        else if(segue.identifier == Constants.gotoFourth) {
            if let four = segue.destination as? FourthVC {
                four.loadViewIfNeeded()
                //print(value)
                four.showMessage.text = value
            }
        }
    }
}


extension FirstVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        value = descriptions[indexPath.row]
        performSegue(withIdentifier: Constants.gotoFourth, sender: self)
    }
}


extension FirstVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.customCVCell, for: indexPath) as! customCVCell
                
        item.showLabel.text = contents[indexPath.row]
        
        return item
    }
}

extension FirstVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let num_of_cell: CGFloat = 3
        let available_space = (collectionView.bounds.width)-(left_right_padding*2)-(inter_cell_spacing*(num_of_cell-1))
        
        let img_dimension = available_space/num_of_cell
        
        return CGSize(width: img_dimension, height: img_dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
    }
}
