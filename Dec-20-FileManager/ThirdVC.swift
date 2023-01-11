//
//  ThirdVC.swift
//  Dec-20-FileManager
//
//  Created by Admin on 21/12/22.
//

import UIKit

class ThirdVC: UIViewController {
    
    var delegate: fileInputProtocol?

    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var fileName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func saveBtn(_ sender: Any) {
        if let inpTxt = inputText, let inpfN = fileName {
            delegate?.inputText = inpTxt.text
            delegate?.inputFileName = inpfN.text
            delegate?.createTextFile()
        }
        self.dismiss(animated: true)
    }
    
}
