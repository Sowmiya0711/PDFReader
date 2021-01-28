//
//  ViewController.swift
//  PdfReader
//
//  Created by CSS on 27/01/21.
//  Copyright © 2021 Sowmiya. All rights reserved.
//

import UIKit
import PDFKit
import MessageUI

enum MenuState{
    case select
    case mail
    case message
    case highLight
}


public enum ActionStyle {
/// Brings up a print modal allowing user to print current PDF
    case print
       
/// Brings up an activity sheet to share or open PDF in another app
    case activitySheet
}

class PDFViewController: UIViewController,MFMessageComposeViewControllerDelegate {

    @IBOutlet var pdfView: PDFView!
    
    private var actionStyle = ActionStyle.activitySheet
    private var actionButton: UIBarButtonItem?
    var showAsSingleFile = false
    var fileName = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "PDF READER"
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        setupUI()
    }

    //MARK: Setup UI
    private func setupUI() {
        CustomPDFView.pdfView = pdfView
            
         if showAsSingleFile {
         if let doc = document("1") {
         for i in 2..<21 {
             doc.addPages(from: document(String(i))!)
             }
             CustomPDFView.pdfDocument = doc
         }
         } else {
             CustomPDFView.pdfDocument = document(fileName)
         }
         
         //MARK: Change single and double page according to orientation
         if  UIDevice.current.orientation != UIDeviceOrientation.portrait { CustomPDFView.coverPage = true
         } else {
                        CustomPDFView.showBreaks = false
         }
         
         for direction in [UISwipeGestureRecognizer.Direction.up, .down, .left, .right] {
             let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
             swipeGesture.direction = direction
             pdfView.addGestureRecognizer(swipeGesture)
         }
        
         actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonPressed))
         self.navigationItem.rightBarButtonItem = actionButton
         
         let mailItem = UIMenuItem(title: "Mail", action: #selector(mail))
         let messageItem = UIMenuItem(title: "Message",action: #selector(message))
         let highLightItem = UIMenuItem(title: "HighLight",action: #selector(highLight))
         UIMenuController.shared.menuItems = [mailItem,messageItem,highLightItem]
    }
    
    //MARK: Change single and double page according to orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
           if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            CustomPDFView.showBreaks = true
            CustomPDFView.coverPage = false
           } else {
            CustomPDFView.coverPage = true
            CustomPDFView.showBreaks = false
           }
       }
    
    //MARK: Go to next or previous page based on swipe direction
    @objc func swipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left || sender.direction == .up {
            CustomPDFView.goToNextPage()
        } else if sender.direction == .right || sender.direction == .down {
            CustomPDFView.goToPreviousPage()
        }
    }

    //MARK: Getting pdf document from app storage
    private func document(_ name: String) -> PDFDocument? {
        guard let documentURL = Bundle.main.url(forResource: name, withExtension: "pdf") else { return nil }
        return PDFDocument(url: documentURL)
    }
    
    //MARK: Handling menuItems
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
    {
        if action == #selector(mail(_:)) || action == #selector(message(_:)) || action == #selector(highLight(_:)){
          return true
        }
        return false
    }

    @objc func mail(_ sender: Any?) {
        sendMail()
    }
    
    @objc func message(_ sender: Any?) {
        sendMessage()
    }
    
    @objc func highLight(_ sender: Any?) {
        onTapHighLight()
    }
    
    
    //MARK: On tap of share rightbarbutton
    @objc func actionButtonPressed() {
        switch actionStyle {
        case .print:
            print()
        case .activitySheet:
            presentActivitySheet()
        }
    }
    
    //MARK: Presents activity sheet to share or open PDF in another app
    private func presentActivitySheet() {
        let controller = UIActivityViewController(activityItems: [CustomPDFView.pdfDocument?.dataRepresentation()], applicationActivities: nil)
        controller.popoverPresentationController?.barButtonItem = actionButton
        present(controller, animated: true, completion: nil)
    }
    
    func onTapHighLight() {
       guard let selections = pdfView.currentSelection?.selectionsByLine()
            else { return }

        selections.forEach({ selection in
            selection.pages.forEach({ page in
                let highlight = PDFAnnotation(bounds: selection.bounds(for: page), forType: .highlight, withProperties: nil)
                highlight.color = .yellow
                page.addAnnotation(highlight)
            })
        })
    }
    
    //MARK: Send text Message
    private func sendMessage() {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = pdfView.currentSelection?.string
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}

extension PDFViewController: MFMailComposeViewControllerDelegate {
    
    private func sendMail() {
        let mailComposeViewController = configureMailComposer()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("Can't send email")
        }
    }
    
    private func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setSubject("PDF Text Selection")
        if let selectedString = pdfView.currentSelection?.string {
            mailComposeVC.setMessageBody(selectedString, isHTML: false)
        }
        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            dismiss(animated: true, completion: nil)
    }
}

extension PDFDocument {

    func addPages(from document: PDFDocument) {
        let pageCountAddition = document.pageCount

        for pageIndex in 0..<pageCountAddition {
            guard let addPage = document.page(at: pageIndex) else {
                break
            }

            self.insert(addPage, at: self.pageCount)
        }
    }
}
