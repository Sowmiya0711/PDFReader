//
//  HomeViewController.swift
//  PdfReader
//
//  Created by CSS on 28/01/21.
//  Copyright © 2021 Sowmiya. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var viewAllPDFAsSinglePDF: UIButton!
    @IBOutlet weak var viewAsSinglePDF: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "PDF READER"
    }
    
    @IBAction func onTapViewAllPDFAsSinglePdf(_ sender: Any) {
        let pdfViewController: PDFViewController = PDFViewController.instantiate(appStoryboard: .main)
        pdfViewController.showAsSingleFile = true
        self.navigationController?.pushViewController(pdfViewController,animated: true)
    }
    
    @IBAction func onTapViewAsSinglePdf(_ sender: Any) {
        let pdfTableViewController: PDFTableViewController = PDFTableViewController.instantiate(appStoryboard: .main)
        
        self.navigationController?.pushViewController(pdfTableViewController,animated: true)
    }
}
