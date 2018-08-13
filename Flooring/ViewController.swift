//
//  ViewController.swift
//  Flooring
//
//  Created by Gopi Srinath on 12/08/18.
//  Copyright © 2018 Gopi Srinath. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController , ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.sceneView.showsStatistics=true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,ARSCNDebugOptions.showFeaturePoints]
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createFloor(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let woodenNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        woodenNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "woodenFloor")
        woodenNode.geometry?.firstMaterial?.isDoubleSided = true
        woodenNode.position = SCNVector3(planeAnchor.center.x,planeAnchor.center.y,planeAnchor.center.z)
        woodenNode.eulerAngles = SCNVector3(90.degreesToRadians,0,0)
        return woodenNode
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let woodenNode = createFloor(planeAnchor: planeAnchor)
        node.addChildNode(woodenNode)
        print("New flat surface detected, new ARPlaneAnchor added")
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        print("Updating floors anchor")
        node.enumerateChildNodes{ (childNode, _) in
            childNode.removeFromParentNode()
        }
        let woodenNode = createFloor(planeAnchor: planeAnchor)
        node.addChildNode(woodenNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else { return }
        node.enumerateChildNodes{ (childNode, _) in
            childNode.removeFromParentNode()
        }

    }

}

extension Int{
    var degreesToRadians: Double {
        return Double(self) * .pi/180
    }
}

