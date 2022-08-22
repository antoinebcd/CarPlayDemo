//
//  CarPlaySceneDelegate.swift
//  CarSample
//
//  Created by Antoine Petipont. Below on 17.08.22.
//

import UIKit
import SwiftUI
import CarPlay
import AVFoundation
import MediaPlayer
class CarplaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    
    var player: AVPlayer!


    private var carplayInterfaceController: CPInterfaceController?

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        // Background of CPMapTemplate
        let contentView = CarPlayContentView()
        window.rootViewController = UIHostingController(rootView: contentView)

        // Retain the intent to add or remove templates later.
        carplayInterfaceController = interfaceController

        grid()
    }

    // MARK: - CPTemplates

    private func grid() {
        let template = CPGridTemplate(title: "Template Grid", gridButtons: [
            CPGridButton(titleVariants: ["Map"], image: UIImage(systemName: "map")!, handler: map(_:)),
            CPGridButton(titleVariants: ["List"], image: UIImage(systemName: "list.dash")!, handler: list(_:)),
            CPGridButton(titleVariants: ["Search"], image: UIImage(systemName: "magnifyingglass")!, handler: search(_:)),
            CPGridButton(titleVariants: ["Action"], image: UIImage(systemName: "square.and.arrow.up")!, handler: action(_:)),
            CPGridButton(titleVariants: ["Alert"], image: UIImage(systemName: "exclamationmark.triangle")!, handler: alert(_:)),
            CPGridButton(titleVariants: ["Siri"], image: UIImage(systemName: "waveform.circle")!, handler: siri(_:)),
        ])

        carplayInterfaceController?.setRootTemplate(template, animated: true)
    }

    private func map(_ button: CPGridButton) {
        let template = CPMapTemplate()
        template.mapDelegate = self

        carplayInterfaceController?.pushTemplate(template, animated: true)
    }

    private func list(_ button: CPGridButton) {
        let template = CPListTemplate(title: "List of Audio", sections: [
            CPListSection(items: [
                CPListItem(text: "Online Podcast", detailText: ""),
                CPListItem(text: "Text", detailText: "", image: UIImage(systemName: "suit.heart")),
                CPListItem(text: "Text", detailText: "", image: nil, showsDisclosureIndicator: true),
            ])
        ])
        template.delegate = self

        carplayInterfaceController?.pushTemplate(template, animated: true)
    }

    private func search(_ button: CPGridButton) {
        let template = CPSearchTemplate()
        template.delegate = self

        carplayInterfaceController?.pushTemplate(template, animated: true)
    }

    private func action(_ button: CPGridButton) {
        let template = CPActionSheetTemplate(title: "This is sample action sheet", message: nil, actions: [
            CPAlertAction(title: "OK", style: .default, handler: { (action) in
                print("OK")
            }),
            CPAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                print("Cancel")
            }),
        ])

        carplayInterfaceController?.presentTemplate(template, animated: true)
    }

    private func alert(_ button: CPGridButton) {
        let template = CPAlertTemplate(titleVariants: ["This is sample alert."], actions: [
            CPAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
                print("OK")
                self?.carplayInterfaceController?.dismissTemplate(animated: true)
            }),
            CPAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (action) in
                print("Cancel")
                self?.carplayInterfaceController?.dismissTemplate(animated: true)
            }),
        ])

        carplayInterfaceController?.presentTemplate(template, animated: true)
    }

    private func siri(_ button: CPGridButton) {
        let template = CPVoiceControlTemplate(voiceControlStates: [
            CPVoiceControlState(identifier: "identifier", titleVariants: ["Test"], image: nil, repeats: true)
        ])

        carplayInterfaceController?.presentTemplate(template, animated: true)
    }
    
    @available(iOS 14.0, *)
    func setPlayer() {
        let stationUrl = "https://stitcher2.acast.com/livestitches/d07b5c22b2c37d4147073645df23f472.mp3?aid=61b0d9effb3dec001250c395&chid=e6a9fe4b-fcff-50c6-93a4-95c2d318a67c&ci=QkE3DNpoiF3NCTe6hsdvQyhBwu-ztLW2TBM8Q094IamS07Hd8Gwyiw%3D%3D&pf=rss&sv=sphinx%401.111.0&uid=9e596a4c5c28163ca9c058009b4f3072&Expires=1660837947477&Key-Pair-Id=K38CTQXUSD0VVB&Signature=js6rm6wBazF3bikjQDzC223ANas~K8h9RS1MwvU42h-7T~mWfpN~RK8vs1ewSo0CE83RV11V8I61RMKQEEZnSwhydziuug3ISQBew-vkrE5GTcXSHN8ORR6fOA0DdkKjD1kzKEOGCpANkDckERIvbyUIokcDyzUlbtDchYmfJsysJswnaUD3mS7FkMf2Kiv8Oa2XdP4jfwvSASGzfWU5AWeLkWm5~PlAILaXoty4uD6nzvlzyVz0RM~haAe6je3d7HIPM9VcH9GRl5qy-83ZtXXoqj1OP0BVtvmMRjnG6FKc7VzQu8q1MrNDeXEonlIOxHNCzotoQpxXmUg5sAyPyw__"
          let playerItem = AVPlayerItem(url: URL(string: stationUrl)!)
          player = AVPlayer(playerItem: playerItem)
          player.rate = 1.0
          player.play()
        self.setPlayerNowPlayingInformation();
        //self.showNowPlayingTemplate(animated: true)
      }
    
    
    //Here we setup the NowPlayingTemplate info to launch it later
    func setPlayerNowPlayingInformation() {
          var nowPlayingInfo: [String: Any] = [:]
                    
          nowPlayingInfo = [MPMediaItemPropertyTitle: "Media Title"]
                    
          if let image = UIImage (named: "carplay_app_icon") {
             nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { size -> UIImage in
                 return image
              })
          }
          MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

}

// MARK: - CPTemplate delegates

extension CarplaySceneDelegate: CPMapTemplateDelegate {

}

extension CarplaySceneDelegate: CPSearchTemplateDelegate {

    func searchTemplate(_ searchTemplate: CPSearchTemplate, updatedSearchText searchText: String, completionHandler: @escaping ([CPListItem]) -> Void) {
        print(searchText)

        completionHandler([
            CPListItem(text: searchText, detailText: "")
        ])
    }

    func searchTemplate(_ searchTemplate: CPSearchTemplate, selectedResult item: CPListItem, completionHandler: @escaping () -> Void) {
        print(item.text)

        completionHandler()
    }

}

@available(iOS 14.0, *)
extension CarplaySceneDelegate: CPListTemplateDelegate {

    func listTemplate(_ listTemplate: CPListTemplate, didSelect item: CPListItem, completionHandler: @escaping () -> Void) {
        setPlayer()

        // Dismiss indicator
        completionHandler()
    }
    
    
    
    
    //Here we launch the NowPlayingTemplate
    //As I wanted to add multiple template from maps entitlement and audio, I can't launch this template as it's only for audio entitlements
    private func showNowPlayingTemplate(animated: Bool) {
      guard carplayInterfaceController?.topTemplate != CPNowPlayingTemplate.shared else { return }
        
      #if targetEnvironment(simulator)
        UIApplication.shared.endReceivingRemoteControlEvents()
        UIApplication.shared.beginReceivingRemoteControlEvents()
      #endif
        
      if carplayInterfaceController?.templates.contains(CPNowPlayingTemplate.shared) == true {
          carplayInterfaceController?.pop(to: CPNowPlayingTemplate.shared, animated: animated)
      } else {
          carplayInterfaceController?.pushTemplate(CPNowPlayingTemplate.shared, animated: animated)
      }
    }
}
