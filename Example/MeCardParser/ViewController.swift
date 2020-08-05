// Copyright (c) 2020 Kishore Prakash <kishore.balasa@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  ViewController.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 07/31/2020.
//  Copyright (c) 2020 Kishore Prakash. All rights reserved.
//

import UIKit
import MeCardParser
import Contacts
import ContactsUI

class ViewController: UIViewController {

    var contactController: UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case is ScannerVC:
            let vc = segue.destination as! ScannerVC
            vc.delegate = self
        default:
            break
        }
    }
    
    func show(contact: CNContact) {
        let contactView = CNContactViewController(forUnknownContact: contact)
        contactView.contactStore = CNContactStore()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(destroyContactController))
        contactView.navigationItem.leftBarButtonItem = cancelButton
        
        contactController = UINavigationController(rootViewController: contactView)
        
        if let contactController = contactController {
            present(contactController, animated: true, completion: nil)
        }
    }
    
    @objc private func destroyContactController() {
        resignFirstResponder()
        contactController?.dismiss(animated: true, completion: nil)
    }

}

extension ViewController: ScannerVCDelegate {
    func scanSuccessful(code: String) {
        print("Scanned Data: \(code)")
        
        guard let contact = Parser.parserMeCard(data: code) else {
            print("Error while Parsing")
            return
        }
        
        show(contact: contact)
    }
    
    func scanFailed(error: String) {
        print("Failed with error: \(error)")
    }
}

