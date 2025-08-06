//
//  AddAccountViewController.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import UIKit
import AVFoundation
import AudioToolbox

protocol AddAccountDelegate: AnyObject {
    func didAddAccount(_ account: OTPAccount)
}

class AddAccountViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var secretTextField: UITextField!
    @IBOutlet weak var accountNameTextField: UITextField!
    
    // MARK: - Properties
    weak var delegate: AddAccountDelegate?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        handleSaveTapped()
    }
    
    @IBAction func scanQRButton(_ sender: UIButton) {
        startQRCodeScanner()
    }
}

// MARK: - Form Logic
extension AddAccountViewController {
    
    func handleSaveTapped() {
        guard let accountName = accountNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !accountName.isEmpty else {
            showAlert(message: "Please enter an account name.")
            return
        }
        
        guard let secretInput = secretTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !secretInput.isEmpty else {
            showAlert(message: "Please enter a valid secret key.")
            return
        }
        
//        guard isValidBase32(secretInput) else {
//            showAlert(message: "Invalid Base32 TOTP secret. Please try again.")
//            return
//        }
//        
//        guard let otpSecret = OTPSecret(secretInput) else {
//            showAlert(message: "Failed to initialize OTP secret.")
//            return
//        }
        let OTPSecretObj = OTPSecret(secretInput)
        // MARK: Force unwrap for testing only
        // Setting time interval to 10 so it's easy for testing
        let OTPGenerator = TOTPGenerator(secret: OTPSecretObj!, timeInterval: 10, algorithm: .sha1)
        let newAccount = OTPAccount(accountName: accountName, dateAdded: Date(), secret: OTPSecretObj!)
        
        // save account
        // this design patter is sooooo freaking clever
        newAccount.addUserOTPAccount()
        
        delegate?.didAddAccount(newAccount)
        dismiss(animated: true, completion: nil)
       
//        // MARK: Store metadata
//        OTPAccountStore.add(accountName: accountName)
//        
//        // MARK: Store secret securely
//        // TODO: Replace with actual secure storage implementation
////        try? SecureOTPStore.addAccount(     )
        
    }
    
    func isValidBase32(_ string: String) -> Bool {
        let base32Charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
        return string.uppercased().allSatisfy { base32Charset.contains($0) }
    }
}

// MARK: - QR Code Scanning
extension AddAccountViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func startQRCodeScanner() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else {
            showAlert(message: "Camera unavailable.")
            return
        }
        captureSession.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        guard captureSession.canAddOutput(metadataOutput) else {
            showAlert(message: "Cannot scan for QR code.")
            return
        }
        captureSession.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            processScannedOTPURL(stringValue)
        }
        
        previewLayer.removeFromSuperlayer()
    }
    
    func processScannedOTPURL(_ urlString: String) {
        guard let url = URL(string: urlString),
              url.scheme == "otpauth",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            showAlert(message: "Invalid OTP QR code.")
            return
        }
        
        let label = url.path.replacingOccurrences(of: "/", with: "")
        accountNameTextField.text = label
        
        if let secretItem = queryItems.first(where: { $0.name.lowercased() == "secret" }),
           let secret = secretItem.value {
            secretTextField.text = secret
        } else {
            showAlert(message: "Secret not found in QR code.")
        }
    }
}

// MARK: - Alerts
extension AddAccountViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

