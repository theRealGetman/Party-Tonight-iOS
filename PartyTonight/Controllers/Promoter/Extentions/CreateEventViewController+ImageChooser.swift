//
//  CreateEventViewController+ImageChooser.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 30.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import YangMingShan
extension CreateEventViewController: YMSPhotoPickerViewControllerDelegate{
    
    @IBAction func presentPhotoPicker(_ sender: UIButton) {
        
        let pickerViewController = YMSPhotoPickerViewController.init()
        
        pickerViewController.numberOfPhotoToSelect = maxImagesToChoose
        
        let customColor = UIColor.init(red:102.0/255.0, green:23.0/255.0, blue:94.0/255.0, alpha:1.0)
        
        pickerViewController.theme.titleLabelTextColor = UIColor.white
        pickerViewController.theme.navigationBarBackgroundColor = customColor
        pickerViewController.theme.tintColor = UIColor.white
        pickerViewController.theme.orderTintColor = customColor
        pickerViewController.theme.orderLabelTextColor = UIColor.white
        pickerViewController.theme.cameraVeilColor = customColor
        pickerViewController.theme.cameraIconColor = UIColor.white
        pickerViewController.theme.statusBarStyle = .default
        
        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
        

    }
    
 
    
    
    func deletePhotoImage(_ sender: UIButton!) {
        let mutableImages: NSMutableArray! = NSMutableArray.init(array: images)
        mutableImages.removeObject(at: sender.tag)
        self.images = NSArray.init(array: mutableImages)
        
    }
    
    
    
    // MARK: - YMSPhotoPickerViewControllerDelegate
    func photoPickerViewControllerDidReceivePhotoAlbumAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController.init(title: "Allow photo album access?", message: "Need your permission to access photo albumbs", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewControllerDidReceiveCameraAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController.init(title: "Allow camera album access?", message: "Need your permission to take a photo", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
        picker.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPicking image: UIImage!) {
        picker.dismiss(animated: true) {
            self.images = [image]
            //self.collectionView.reloadData()
        }
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPickingImages photoAssets: [PHAsset]!) {
        
        picker.dismiss(animated: true) {
            let imageManager = PHImageManager.init()
            let options = PHImageRequestOptions.init()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            options.isSynchronous = true
            self.uiImages.value.removeAll()
            for asset: PHAsset in photoAssets
            {
                
                
                let targetSize = CGSize(width: 640, height: 480)
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    self.uiImages.value.append(image!)
                })
            }
            
            //self.images = mutableImages.copy() as? NSArray
            //print(self.images);
            //self.collectionView.reloadData()
        }
    }
}

