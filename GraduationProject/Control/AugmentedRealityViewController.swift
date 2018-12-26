//
//  AugmentedRealityViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 24.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import ARKit

class AugmentedRealityViewController: UIViewController {

    @IBOutlet weak var planeDetected: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    let floorNodeName = "Floor Node"
    var count = 0
    
    //Store The Rotation Of The CurrentNode
    var currentAngleY: Float = 0.0
    
    //Not Really Necessary But Can Use If You Like
    var isRotating = false
    
    var documentId: String?
    var documentDetailId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Do any additional setup after loading the view.
        configuration.planeDetection = .horizontal
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        addGestures()
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func createFloorNode(planeAnchor: ARPlaneAnchor) -> SCNNode {
        
        let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        floorNode.geometry?.firstMaterial?.isDoubleSided = true
        floorNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        floorNode.eulerAngles.x = -.pi / 2
        floorNode.name = floorNodeName
        
        return floorNode
    }
    
    
    func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinched(_:)))
        sceneView.addGestureRecognizer(pinch)
        
        let move = UIPanGestureRecognizer(target: self, action: #selector(moveNode(_:)))
        sceneView.addGestureRecognizer(move)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateNode(_:)))
        sceneView.addGestureRecognizer(rotate)
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func pinched(_ sender: UIPinchGestureRecognizer){
        
        let sceneView = sender.view as! ARSCNView
        let pinchLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(pinchLocation)
        
        if !hitTest.isEmpty {
            let results = hitTest.first!
            let node = results.node
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            node.runAction(pinchAction)
            sender.scale = 1.0
            
        }
        else {
            
        }
        
    }
    
    @objc func moveNode(_ sender: UIPanGestureRecognizer){
        if !isRotating{
            
            //1. Get The Current Touch Point
            let currentTouchPoint = sender.location(in: self.sceneView)
            //2. Get The Next Feature Point Etc
            guard let hitTest = self.sceneView.hitTest(currentTouchPoint, types: .existingPlane).first else { return }
            //3. Convert To World Coordinates
            let worldTransform = hitTest.worldTransform
            //4. Set The New Position
            let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
            //5. Apply To The Node
            self.sceneView.scene.rootNode.enumerateChildNodes{ (node, _) in
                node.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
            }
            
        }
        
        
    }
    
    
    @objc func rotateNode(_ sender: UIRotationGestureRecognizer){
        //1. Get The Current Rotation From The Gesture
        let rotation = Float(sender.rotation)
        
        //2. If The Gesture State Has Changed Set The Nodes EulerAngles.y
        if (sender.state == .changed){
            isRotating = true
            self.sceneView.scene.rootNode.enumerateChildNodes{ (node, _) in
                node.eulerAngles.y = currentAngleY + rotation
            }
            
        }
        
        //3. If The Gesture Has Ended Store The Last Angle Of The Cube
        if(sender.state == .ended) {
            self.sceneView.scene.rootNode.enumerateChildNodes{ (node, _) in
                currentAngleY = node.eulerAngles.y
            }
            isRotating = false
        }
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            if count == 0 {
                addFurniture(hitTestResult: hitTest.first!)
                count = count + 1
            }
            else {
                print("You have already Furniture")
            }
        }
        else{
            alert(title: "ARKit", message: "Not a plane")
            print("Not a plane")
        }
        
    }
    
    
    
    func addFurniture(hitTestResult: ARHitTestResult) {
        
        var furnitureName = ""
        
        if documentId == "Desk" {
            if documentDetailId == "qJrPHPMm5PALHF112Ljb" {
                furnitureName = "woodDesk"
            }
            else if documentDetailId == "7lydIfiJcZoxamYFrree" {
                furnitureName = "table"
            }
        }
        else if documentId == "Chair" {
            
        }
        else if documentId == "Sofa" {
            if documentDetailId == "OCZmw8dEmUa24HIK7FYH" {
                furnitureName = "leatherSofa"
            }
        }
        
        
        
        
        
        let node: SCNNode!
        guard let scene = SCNScene(named: "art.scnassets/\(furnitureName).scn") else { return }
        if let desk = scene.rootNode.childNode(withName: furnitureName, recursively: false) {
            print(desk)
            node = desk
        }
        else {
            fatalError("missing pyramid mode in scene file")
        }
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        node.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        self.sceneView.scene.rootNode.addChildNode(node)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AugmentedRealityViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        print("Added")
        DispatchQueue.main.async {
            self.planeDetected.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.planeDetected.isHidden = true
            }
        }
        
        //print("New flat surface detected, new ARPlaneAnchor added")
    }
    
    //    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    //         guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    //         //print("Updating floor's anchor")
    //
    //        node.enumerateChildNodes { (childNode, _) in
    //            childNode.removeFromParentNode()
    //        }
    //
    //        let createPlaneNode = createFloorNode(planeAnchor: planeAnchor)
    //        node.addChildNode(createPlaneNode)
    //
    //    }
    //
    //    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    //        guard let _ = anchor as? ARPlaneAnchor else { return }
    //        print("Removing floor's anchor")
    //
    //        node.enumerateChildNodes { (childNode, _) in
    //            childNode.removeFromParentNode()
    //        }
    //    }
    
}
