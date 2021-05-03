//
//  ViewController.swift
//  Affective Foretell
//
//  Created by Tianyi Chen on 13/04/2021.
//

import UIKit
import ARKit

private let planewidth: CGFloat = 0.36
private let planeheight: CGFloat = 0.36
private let nodeYPosition: Float = 0.020
private let forecastImageView = UIImageView()

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!

    
    private let forecastPlane = SCNPlane(width: planewidth, height: planeheight)
    private let forecastNode = SCNNode()
    
    private let bgPlane = SCNPlane(width: planewidth, height: planeheight)
    private let bgNode = SCNNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let faceNode = SCNNode(geometry: faceGeometry)
        //node.geometry?.firstMaterial?.fillMode = .lines
        faceNode.geometry?.firstMaterial?.transparency = 0.0
        
        let gifImage = UIImage.gifImageWithName("ML")
        let gifImageView = UIImageView(image: gifImage)
        forecastPlane.firstMaterial?.diffuse.contents = gifImageView
        forecastPlane.firstMaterial?.isDoubleSided = true
        forecastNode.opacity = 0.7
        forecastNode.position.z = faceNode.position.z
        forecastNode.position.y = nodeYPosition
        forecastNode.geometry = forecastPlane
        
        bgPlane.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "glow")
        bgPlane.firstMaterial?.isDoubleSided = true
        bgNode.position.z = faceNode.position.z
        bgNode.position.y = nodeYPosition
        bgNode.opacity = 0.7
        bgNode.geometry = bgPlane
        
        faceNode.addChildNode(forecastNode)
        faceNode.addChildNode(bgNode)
        return faceNode
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        faceGeometry.update(from: faceAnchor.geometry)
    }
}
