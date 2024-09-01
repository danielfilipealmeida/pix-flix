//
//  VideoCreator.swift
//  cli
//
//  Created by Daniel Almeida on 16/08/2024.
//

import AVFoundation
import AppKit


extension NSImage {
    
    /// generates a CGImage from this NSImage.
    /// - Returns: a CGImage
    func cgImage() -> CGImage? {
        guard let tiffData = self.tiffRepresentation,
                  let bitmapRep = NSBitmapImageRep(data: tiffData),
                  let cgImage = bitmapRep.cgImage else { return nil }
        
        return cgImage
        
    }
    
    /// Generates a CIImage for this NSImage.
    /// - Returns: a CIImage
    func ciImage() -> CIImage? {
        guard let data = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: data) else {
            return nil
        }
        let ci = CIImage(bitmapImageRep: bitmap)
        
        return ci
    }
    
    // Creates a new NSImage from a CIImage
    static func fromCIImage(_ ciImage: CIImage) -> NSImage {
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        return nsImage
    }
    
    /// Generates a resized CVPixelBuffer representation of this image
    /// - Parameter size: the size of the final pixel buffer
    /// - Returns: a CVPixelBuffer
    func toPixelBuffer(size: CGSize) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let options: [NSObject: AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey: true as AnyObject,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true as AnyObject
        ]
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(size.width),
            Int(size.height),
            kCVPixelFormatType_32ARGB,
            options as CFDictionary,
            &pixelBuffer
        )
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        let pixelData = CVPixelBufferGetBaseAddress(buffer)
        
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: pixelData,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }
        
        
        var rect = CGRect(origin: .zero, size: size)
        context.clear(rect)
        guard let cgImage = self.cgImage(forProposedRect: &rect, context: nil, hints: nil) else {
            print("Error: Could not get CGImage from NSImage")
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }
        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        CVPixelBufferUnlockBaseAddress(buffer, [])
        
        return pixelBuffer
    }
    
    func save(
        toURL: URL,
        format: NSBitmapImageRep.FileType = .png
    ) -> Bool {
        guard let tiffData = self.tiffRepresentation,
              let bitmapImageRep = NSBitmapImageRep(data: tiffData),
              let imageData = bitmapImageRep.representation(using: format, properties: [:]) else {
            print("Error: could not create image data from NSImage")
            return false
        }
        
        do {
            try imageData.write(to: toURL)
            print("Image saved to \(toURL.path)")
            return true
        }
        catch {
            print("Error saving image: \(error.localizedDescription)")
            return false
        }
        
        
    }
}



/// Creates videos from images stored locally
class VideoCreator {
    var writer: AVAssetWriter?
    var writerInput: AVAssetWriterInput?
    var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    var images: [NSImage]?
    var outputURL: URL?
    var videoSize: CGSize?
    var duration: Double?
    
    /// Inicializes the object with a list of images, an output folder, a final size and duration
    /// - Parameter images: the array of images to use as input. they must already be ordered
    /// - Parameter outputURL: the url of the resulting video
    /// - Parameter videoSize: the width and height of the resulting video
    /// - Parameter duration: the time of the video in seconds
    ///
    init(images: [NSImage], outputURL: URL, videoSize: CGSize, duration: Double) {
        self.images = images
        self.outputURL = outputURL
        self.videoSize = videoSize
        self.duration = duration
        
        do {
            writer = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
                        
            let videoSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: videoSize.width,
                AVVideoHeightKey: videoSize.height
            ]
            
            writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            writerInput!.expectsMediaDataInRealTime = false
            
            let attributes: [String: Any] = [
                kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
                kCVPixelBufferWidthKey as String: videoSize.width,
                kCVPixelBufferHeightKey as String: videoSize.height
            ]
            
            pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput!, sourcePixelBufferAttributes: attributes)

        }
        catch {
            print("AVAssetWriter error: \(error.localizedDescription)")
        }
    }
    
    func run(completion: @escaping (Bool) -> Void) {
        do {
            try FileManager.default.removeItem(at: self.outputURL!)
            print("Deleted file \(self.outputURL!)")
        }
        catch {
            print("File doesn't exist. no need to delete")
        }
        
        guard writer!.canAdd(writerInput!) else {
           print("Cannot add writer input")
           completion(false)
           return
        }
        writer!.add(writerInput!)
        
        writer!.startWriting()
        writer!.startSession(atSourceTime: .zero)
                       
        let frameDuration = CMTime(seconds: self.duration! / Double(self.images!.count), preferredTimescale: 600)
        var frameCount: Int32 = 0
        let mediaInputQueue = DispatchQueue(label: "mediaInputQueue")
                    
        writerInput!.requestMediaDataWhenReady(on: mediaInputQueue) {
            for image in self.images! {
                if self.writerInput!.isReadyForMoreMediaData {
                    let time = CMTimeMultiply(frameDuration, multiplier: frameCount)
                    if let pixelBuffer:CVPixelBuffer = image.toPixelBuffer(size: self.videoSize!) {
                        //self.saveBuffer(buffer: pixelBuffer, toURL: URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("image-\(frameCount+1).png"))
                        self.pixelBufferAdaptor!.append(pixelBuffer, withPresentationTime: time)
                    }
                    else {
                        print("Error geting Pixel Buffer from image \(image.description)")
                    }
                    frameCount += 1
                }
            }
            
            self.writerInput!.markAsFinished()
            self.writer!.finishWriting {
                if self.writer!.status == .completed {
                    print("Video creation succeeded")
                    completion(true)
                } else {
                    print("Video creation failed: \(self.writer!.error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                }
            }
        }
    }
    
    private func cleanup() {
        self.writer = nil
        self.writerInput = nil
        self.pixelBufferAdaptor = nil
    }
    
    func saveBuffer(buffer: CVPixelBuffer, toURL: URL, format: NSBitmapImageRep.FileType = .png) ->Bool {
        let ciImage: CIImage = CIImage(cvPixelBuffer: buffer)
        let nsImage: NSImage = .fromCIImage(ciImage)
        
        guard let tiffData = nsImage.tiffRepresentation,
              let bitmapImageRep = NSBitmapImageRep(data: tiffData),
              let imageData = bitmapImageRep.representation(using: format, properties: [:]) else {
            print("Error: could not create image data from NSImage")
            return false
        }
        
        do {
            try imageData.write(to: toURL)
            print("Image saved to \(toURL.path)")
            return true
        }
        catch {
            print("Error saving image: \(error.localizedDescription)")
            return false
        }
    }

}
