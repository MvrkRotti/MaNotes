//
//  ScanService.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 24.12.2024.
//

import VisionKit
import Vision
import Photos

protocol ScanService: VNDocumentCameraViewControllerDelegate {
    var text: String { get set }
    var onChangedText: ((String) -> Void)? { get set }
    func recognizeText(inImage: UIImage)
    func scanPages(assets: [PHAsset])
}

class ScanServiceImpl: NSObject, ScanService {
    
    var text = ""
    
    private var count = 0
    
    private var countPages = 0
    
    var onChangedText: ((String) -> ())?
    
    lazy var workQueue = {
        return DispatchQueue(
            label: "workQueue",
            qos: .userInitiated,
            attributes: [],
            autoreleaseFrequency: .workItem
        )
    }()
    
    lazy var textRecognitionRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest(completionHandler: self.handlerReq)
        request.recognitionLevel = .accurate
        request.minimumTextHeight = 0.01
        request.recognitionLanguages = ["zh-Hans", "zh-Hant", "en-US"]
        return request
    }()
    
    private func handlerReq(request: VNRequest?, error: Error?) {
        guard let observations = request?.results as? [VNRecognizedTextObservation] else { return }
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else { return }
            self.text += topCandidate.string
            self.text += "\n"
        }
        
        DispatchQueue.main.async {
            guard self.count == self.countPages - 1 else {
                self.count += 1
                return
            }
            self.onChangedText?(self.text)
        }
    }
    
    func recognizeText(inImage: UIImage) {
        guard let cgImage = inImage.cgImage else { return }
        workQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.textRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
    
    func scanPages(assets: [PHAsset]) {
        countPages = assets.count
        assets.forEach { asset in
            recognizeText(inImage: self.getAssetThumbnail(asset: asset))
        }
    }
    
    private func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(
            for: asset,
            targetSize: CGSize(width: CGFloat(asset.pixelWidth), height: CGFloat(asset.pixelHeight)),
            contentMode: .aspectFit,
            options: option,
            resultHandler: {(result, info) -> Void in
                thumbnail = result!
            }
        )
        return thumbnail
    }
}

extension ScanServiceImpl {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        countPages = scan.pageCount
        for i in 0 ..< scan.pageCount {
            let img = scan.imageOfPage(at: i)
            recognizeText(inImage: img)
        }
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        controller.dismiss(animated: true)
    }
}


