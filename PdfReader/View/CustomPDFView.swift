//
//  CustomPDFView.swift
//  PdfReader
//
//  Created by CSS on 27/01/21.
//  Copyright © 2021 Sowmiya. All rights reserved.
//

import Foundation
import PDFKit

class CustomPDFView
{
    static var pdfView: PDFView? = nil
    
    static var pdfDocument: PDFDocument? = nil {
        didSet {
            pdfView?.document = pdfDocument
            fit()
        }
    }
    
    static var showBreaks: Bool = false {
        didSet { fit() }
    }
    
    static var scrolling: Bool = true {
        didSet { fit() }
    }
    
    static var coverPage: Bool = true {
        didSet { fit() }
    }
    
    
    static func fit() {
        let pages = pdfView?.currentPage
        
        let page: PDFPage?
        
        if pages == nil  {
            page = nil
        } else {
            page = pages
        }
        
        pdfView?.displaysAsBook = coverPage
        pdfView?.displaysPageBreaks = showBreaks
        pdfView?.enableDataDetectors = true
        pdfView?.displayMode = showBreaks ? .twoUp : .singlePageContinuous
        pdfView?.displayDirection = scrolling ? .vertical : .horizontal
        pdfView?.pageShadowsEnabled = false
        pdfView?.autoScales = true
        if showBreaks{
            pdfView?.scaleFactor = 0.47
        }
        if let page = page { pdfView?.go(to: page) }
    }
    
    static func goToPreviousPage() {
        if pdfView?.canGoToPreviousPage == true { pdfView?.goToPreviousPage(nil) }
    }
    
    static func goToNextPage() {
        if pdfView?.canGoToNextPage == true { pdfView?.goToNextPage(nil) }
    }
    
}
