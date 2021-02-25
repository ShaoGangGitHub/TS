//
//  TSVideoVC.swift
//  TS
//
//  Created by shg on 2021/2/23.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSVideoVC: TSBaseVC ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "相册"
        let pick = UIImagePickerController.init()
        pick.sourceType = .photoLibrary
        pick.delegate = self
        pick.mediaTypes = [String(kUTTypeVideo),String(kUTTypeMovie),String(kUTTypeQuickTimeMovie),String(kUTTypeMPEG2Video),String(kUTTypeMPEG4),String(kUTTypeAppleProtectedMPEG4Video),String(kUTTypeAVIMovie)]
        self.view.addSubview(pick.view)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.view.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    var callBack:((_ url:String) -> ())?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let url:URL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
        if self.callBack != nil {
            self.callBack!(url.absoluteString)
        }
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
