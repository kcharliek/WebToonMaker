//
//  CameraHandler.swift
//  ToonMaker
//
//  Created by CHANHEE KIM on 2018. 5. 10..
//  Copyright © 2018년 CHK. All rights reserved.
//

import MobileCoreServices
import UIKit

class CameraHandler: NSObject {
    // MARK: - Variable
    private let imagePicker = UIImagePickerController()
    private let isPhotoLibraryAvailable = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    private let isSavedPhotoAlbumAvailable = UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
    private let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
    private let isRearCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.rear)
    private let isFrontCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.front)
    private let sourceTypeCamera = UIImagePickerControllerSourceType.camera
    private let rearCamera = UIImagePickerControllerCameraDevice.rear
    private let frontCamera = UIImagePickerControllerCameraDevice.front
    
    var delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate
    
    // MARK: - Contructor
    public init(delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Method
    public func getPhotoLibrary(on: UIViewController, canEdit: Bool) {
        
        if !isPhotoLibraryAvailable && !isSavedPhotoAlbumAvailable { return }
        let type = kUTTypeImage as String
        
        if isPhotoLibraryAvailable {
            imagePicker.sourceType = .photoLibrary
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if availableTypes.contains(type) {
                    imagePicker.mediaTypes = [type]
                    imagePicker.allowsEditing = canEdit
                }
            }
        } else if isPhotoLibraryAvailable {
            imagePicker.sourceType = .savedPhotosAlbum
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if availableTypes.contains(type) {
                    imagePicker.mediaTypes = [type]
                }
            }
        } else {
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.modalPresentationStyle = .overCurrentContext
        imagePicker.delegate = delegate
        on.present(imagePicker, animated: true, completion: nil)
    }
    
    public func getCamera(on: UIViewController, canEdit: Bool) {
        if !isCameraAvailable { return }
        let type1 = kUTTypeImage as String
        
        if isCameraAvailable {
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                if availableTypes.contains(type1) {
                    imagePicker.mediaTypes = [type1]
                    imagePicker.sourceType = sourceTypeCamera
                }
            }
            
            if isRearCameraAvailable {
                imagePicker.cameraDevice = rearCamera
            } else if isFrontCameraAvailable {
                imagePicker.cameraDevice = frontCamera
            }
        } else {
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.modalPresentationStyle = .overCurrentContext
        imagePicker.showsCameraControls = true
        imagePicker.delegate = delegate
        on.present(imagePicker, animated: true, completion: nil)
    }
}
