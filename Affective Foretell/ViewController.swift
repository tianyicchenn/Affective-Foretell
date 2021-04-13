//
//  ViewController.swift
//  Affective Foretell
//
//  Created by Tianyi Chen on 13/04/2021.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var faceView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        faceView.delegate = self
        guard ARFaceTrackingConfiguration.isSupported else {
            statusLabel.text = "AR Face Detection is not supported"
            return
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        faceView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        faceView.session.pause()
    }
    
    
    

}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = faceView.device else { return nil }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let faceNode = SCNNode(geometry: faceGeometry)
        faceNode.geometry?.firstMaterial?.fillMode = .lines
        return faceNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAncher = anchor as? ARFaceAnchor,
        let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        faceGeometry.update(from: faceAncher.geometry)
    }
}
