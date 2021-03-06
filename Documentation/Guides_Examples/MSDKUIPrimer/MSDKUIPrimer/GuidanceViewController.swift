//
// Copyright (C) 2017-2019 HERE Europe B.V.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import NMAKit
import MSDKUI

/// Shows usage of GuidanceManeuverView and how to fed maneuver data into it while running
/// guidance simulation.
class GuidanceViewController: UIViewController, GuidanceManeuverMonitorDelegate {

    @IBOutlet weak var guidanceManeuverView: GuidanceManeuverView!
    @IBOutlet weak var mapView: NMAMapView!

    var guidanceManeuverMonitor: GuidanceManeuverMonitor!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let route = RouteHelper.sharedInstance.selectedRoute else {
            print("No valid route yet.")
            return
        }

        guidanceManeuverMonitor = GuidanceManeuverMonitor(route: route)
        guidanceManeuverMonitor.delegate = self

        guidanceManeuverView.foregroundColor = UIColor(red: 1.0, green: 0.77, blue: 0.11, alpha: 1.0)

        startGuidanceSimulation(route: route)
    }

    // MARK: - GuidanceManeuverMonitorDelegate

    func guidanceManeuverMonitor(_ monitor: GuidanceManeuverMonitor,
                                 didUpdateData data: GuidanceManeuverData?) {
        print("data changed: \(String(describing: data))")
        if let maneuverData = data {
            guidanceManeuverView.state = .data(maneuverData)
        } else {
            guidanceManeuverView.state = .updating
        }
    }

    func guidanceManeuverMonitorDidReachDestination(_ monitor: GuidanceManeuverMonitor) {
        print("Destination reached.")
        guidanceManeuverView.tintColor = .colorAccentLight
        guidanceManeuverView.highlightManeuver = true
    }

    // MARK: - GuidanceHelper

    func startGuidanceSimulation(route: NMARoute) {
        GuidanceHelper.sharedInstance.startGuidanceSimulation(route: route, mapView: mapView)
    }

    @IBAction func onStopGuidanceButtonClicked(_ sender: UIButton) {
        GuidanceHelper.sharedInstance.stopGuidance()
    }
}
