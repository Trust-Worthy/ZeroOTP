//
//  AddAccountViewController.swift
//  ZeroOTP
//
//  Created by Jonathan Bateman on 7/17/25.
//

import UIKit
import AVFoundation

protocol AddAccountDelegate: AnyObject {
    func didAddAccount(_ account: OTPAccount)
}

class AddAccountViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {
    
    // This is the button that allows a user to cancel adding an OTP account
    @IBAction func cancelTapped(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: QR-code option
    
    // This button allows the user to save a new OTP account entry
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let accountName = accountNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !accountName.isEmpty else {
            showAlert(message: "Please enter an Account name!")
            return
        }
        print("Account name saved!")
        
        // MARK: TO-DO
        // Research "secret" type to practice processing of secure data
        // Place where user enters the seed val / keep for the OTP algorithm
        guard let secret = secretTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !secret.isEmpty else {
            showAlert(message: "Please enter a valid secret key.")
            return
        }
        
        // Check to ensure the secret is valid
        // If it's not valid ask the user to try again
        guard isValidBase32(secret) else {
            showAlert(message: "Invalid Base32 TOTP secret. Please try again!")
            return
        }
        
        print("User Input is saved...")
        
        // After checks, store the secret is secure enclave
        // MARK: TO-DO
        
        // Create the OTP account object
        let newAccount = OTPAccount(accountName: accountName
                   , dateAdded: Date(),
                   secret: secret)
        
        // Send back to main controller
        delegate?.didAddAccount(newAccount)
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Class properties
    // Text field where user enters in secret
    @IBOutlet weak var secretTextField: UITextField!
    @IBOutlet weak var accountNameTextField: UITextField!
    weak var delegate: AddAccountDelegate?
    
    @IBAction func scanQRButton(_ sender: UIButton) {
        startQRCodeScanner()
    }
    
    // Properties for the scanner
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    // MARK: Alerts
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    // MARK: TO-DO
    // Enventually put all of these error checking functions into the utils directory
    
    func isValidBase32(_ string: String) -> Bool {
        let base32Charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
        
        return string.uppercased().allSatisfy { base32Charset.contains($0) }
    }

    func startQRCodeScanner() {
        
        /*
         
         Flow Summary

             Request camera device

             Wrap it in an input

             Attach input and output to a session

             Add a live camera feed layer

             Start the session

             When a QR code is detected, you get a callback via the delegate
         */
        
        // Central pipeline that manages data input from camera to output
        // This is like a live data bus for video input/output
        captureSession = AVCaptureSession()
        
        // Requesting the default video device which is the rear-facing camera
        // This gives me access to the camera hardward
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        // variable that stores the input object that "wraps" the camera
        let videoInput: AVCaptureDeviceInput
        
        // By wrapping the video Capture Device in an AV capture device input
        // it turns it into a usable input stream that the session has access to
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            showAlert(message: "Camera Unavailable")
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            showAlert(message: "Could not add video input!")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            showAlert(message: "Could not scan for qr code. Enter code manually.")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
    }
    
    // Process the qr code through the video feed
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first,
           let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) // Vibration
            processScannedOTPURL(stringValue)
        }
        
        previewLayer.removeFromSuperlayer()
    }
    
    // Parse the string url that's in the URL
    func processScannedOTPURL(_ urlString: String) {
        
        guard let url = URL(string: urlString),
              url.scheme == "otpauth",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            showAlert(message: "Invalid OTP QR code!")
            return
        }
        
        let label = url.path.replacingOccurrences(of: "/", with: "")
        accountNameTextField.text = label
        
        if let secretItem = queryItems.first(where: {$0.name.lowercased() == "secret"}),
           let secret = secretItem.value {
            secretTextField.text = secret
        } else {
            showAlert(message: "Could not find secret in QR code.")
        }
    }
    
    

}
