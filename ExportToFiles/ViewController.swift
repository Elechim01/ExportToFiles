//
//  ViewController.swift
//  ExportToFiles
//
//  Created by Michele on 21/01/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    let documentInteractionController = UIDocumentInteractionController()
    
    func share(url:URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
//        Name of the url width extension
        documentInteractionController.presentOptionsMenu(from: view.frame,in:view, animated: true)
    }
    @IBAction func shareTapped(_ sender : UIButton){
        guard let url = URL(string: "https://books.goalkicker.com/iOSBook/IOSNotesForProfessional.pdf") else {
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: {(data,response,error) in
            guard let data = data,error == nil else{return}
//            file location
            let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(response?.suggestedFilename ?? "filename.csv")
            do{
//                write the data to that url
                try data.write(to: tempUrl)
                DispatchQueue.main.async {
//                    mostra in un pop up dove salvare i valori
                    self.share(url: tempUrl)
                }
                
            }catch{
                print(error)
            }
        }).resume()
    }
}
extension URL{
    var typeIdentifier : String?{
        return(try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName : String?{
        return(try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}

