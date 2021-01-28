//
//  PDFTableViewController.swift
//  PdfReader
//
//  Created by CSS on 28/01/21.
//  Copyright © 2021 Sowmiya. All rights reserved.
//

import UIKit

class PDFTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var pdfTableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Register the table view cell class and its reuse id
        pdfTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        navigationItem.title = "PDF READER"
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath as IndexPath) as UITableViewCell?)!
        cell.textLabel?.text = "\(indexPath.row + 1).pdf"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pdfViewController: PDFViewController = PDFViewController.instantiate(appStoryboard: .main)
        pdfViewController.fileName = "\(indexPath.row + 1)"
        pdfViewController.showAsSingleFile = false
        self.navigationController?.pushViewController(pdfViewController,animated: true)
    }

}
