//
//  ViewController.swift
//  CameraPhotoLibrary
//
//  Created by 김지훈 on 2023/11/24.
//

import UIKit
//헤더 파일 및 델리게이트 프로토콜 추가
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imgView: UIImageView!
    //UIImagePickerController 이미지 생성
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    //사진 이미지 불러오기 용도
    var captureImage: UIImage!
    // 녹화한 비디오 URL저장
    var videoURL: URL!
    // 이미지 저장 여부
    var flagImageSave = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCaptureImageFromCamera(_ sender: UIButton) {
        
        // 카메라 사용여부
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
            //이미지 저장허용
            flagImageSave = true
            //이미지 피커 delegate self
            imagePicker.delegate = self
            //카메라로
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = ["public.img"]
            //편집허용 x
            imagePicker.allowsEditing = false
            
            //현재 뷰 컨트롤러를 imagePicker로 대체, 즉 뷰에 imagePicker로 보이게
            present(imagePicker,animated: true, completion: nil)
        }
        else{
            //카메라 사용할수 없을때는 경고창
            myAlert("Camera inaccessable", message: "Application cannot access the camera")
        }
    }
    // '사진불러오기' 코드 작성
    @IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            flagImageSave = false
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.image"]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
            
        }else{
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album")
        }
        
    }
    //'비디오 촬영'코드 작성
    @IBAction func btnRecordVideoFromCamera(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            
            flagImageSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.image"]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
        else{
            myAlert("Camera inaccessable", message: "Application cannot access the camera")
        }
    }
    //'비디오 불러오기' 코드 작성
    @IBAction func btnLoadVideoFromLibrary(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            flagImageSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.image"]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album")
        }
    }
    // 델리게이트 메서드 구현
    // (사용자가 사진, 비디오 촬영 or 포토 라이브러리에서 선택이 끝났을때 호출되는 didFinishPickingMediaWithInfo)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        //미디어 종류 확인
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        //미디어 종류: 사진
        if mediaType.isEqual(to: "public,image" as String) {
            //사진를 captureImage에 저장
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            //flagImageSave면 포토라이브러리에 저장
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            
            imgView.image = captureImage
            
        } else if mediaType.isEqual(to: "public.movie" as String) {
            if flagImageSave {
                videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
                
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    // 경고 메서드 작성
    func myAlert(_ title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default , handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated:  true, completion: nil)
    }
}

