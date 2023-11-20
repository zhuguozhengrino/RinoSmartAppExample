//
//  RequestHandler.swift
//  RinoMatterExtension
//
//  Created by zhangstar on 2023/4/28.
//

import MatterSupport
import RinoMatterExtensionKit

// The extension is launched in response to `MatterAddDeviceRequest.perform()` and this class is the entry point
// for the extension operations.
class RequestHandler: MatterAddDeviceExtensionRequestHandler {
    override func validateDeviceCredential(_ deviceCredential: MatterAddDeviceExtensionRequestHandler.DeviceCredential) async throws {
        // Use this function to perform additional attestation checks if that is useful for your ecosystem.
        RinoMatterExtensionSupport.shared.validateDeviceCredential(deviceCredential)
    }

    override func selectWiFiNetwork(from wifiScanResults: [MatterAddDeviceExtensionRequestHandler.WiFiScanResult]) async throws -> MatterAddDeviceExtensionRequestHandler.WiFiNetworkAssociation {
        // Use this function to select a Wi-Fi network for the device if your ecosystem has special requirements.
        // Or, return `.defaultSystemNetwork` to use the iOS device's current network.
        return RinoMatterExtensionSupport.shared.selectWiFiNetwork(from: wifiScanResults)
    }

    override func selectThreadNetwork(from threadScanResults: [MatterAddDeviceExtensionRequestHandler.ThreadScanResult]) async throws -> MatterAddDeviceExtensionRequestHandler.ThreadNetworkAssociation {
        // Use this function to select a Thread network for the device if your ecosystem has special requirements.
        // Or, return `.defaultSystemNetwork` to use the default Thread network.
        return RinoMatterExtensionSupport.shared.selectThreadNetwork(from: threadScanResults)
    }

    override func commissionDevice(in home: MatterAddDeviceRequest.Home?, onboardingPayload: String, commissioningID: UUID) async throws {
        // Use this function to commission the device with your Matter stack.
        
        RinoMatterExtensionSupport.shared.commissionDevice(in: home, onboardingPayload: onboardingPayload, commissioningID: commissioningID)
    }

    override func rooms(in home: MatterAddDeviceRequest.Home?) async -> [MatterAddDeviceRequest.Room] {
        // Use this function to return the rooms your ecosystem manages.
        // If your ecosystem manages multiple homes, ensure you are returning rooms that belong to the provided home.
        return [.init(displayName: "Room")]
    }

    override func configureDevice(named name: String, in room: MatterAddDeviceRequest.Room?) async {
        // Use this function to configure the (now) commissioned device with the given name and room.
        
        RinoMatterExtensionSupport.shared.configureDevice(named: name, in: room)
    }
}
