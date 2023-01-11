////
////  SecondVC.swift
////  Dec-20-FileManager
////
////  Created by Admin on 20/12/22.
////
//
//import UIKit
//
//class SecondVC: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}


//
//  ViewController.swift
//  FileManager
//
//  Created by Bjit on 20/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createText()
    }
    
    private func createText(){
        // Save some text in a .text file
        // 1. get URL for the document dir
        // 2. create URL for subfolder
        // 3. create a subfolder
        // 4. create URL for our text URL
        // 5. convert string text to data
        // 6. create/save our text file
        // 7. Read file contents
        
        
        
        let  fileManager = FileManager.default
        
        // Document directory URL
        guard let documentDirURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return
        }
        
        
        // create URL for subfolder
        let folderURL = documentDirURL.appendingPathComponent("Newfolder").appendingPathComponent("newfolder2").appendingPathComponent("newfolder 3")
        
        // create subfolder
        do{
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }catch{
            print(error)
        }
        
        
        //MARK: Write
        let message = "Hello world"
        let data = message.data(using: .utf8)
        
        
        
        // create URL for text file
        let fileURL = folderURL.appendingPathComponent("test.text")
        
        print(fileURL)
        
        // save text file
        fileManager.createFile(atPath: fileURL.path, contents: data)
        
        
        //MARK: Read
        do {
            let readData = try Data(contentsOf: fileURL)
            let readStr = String(data: readData, encoding: .utf8)
            print(readStr!)
        } catch
        {
            print(error)
        }
        
    }
        
    
}


