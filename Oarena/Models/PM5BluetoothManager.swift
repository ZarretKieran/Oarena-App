//
//  PM5BluetoothManager.swift
//  Oarena
//
//  Basic BLE scanning/connection for Concept2 PM5
//

import Foundation
import CoreBluetooth
import SwiftUI

final class PM5BluetoothManager: NSObject, ObservableObject {
	static let shared = PM5BluetoothManager()

	// Published state for UI
	@Published var isBluetoothPoweredOn: Bool = false
	@Published var isScanning: Bool = false
	@Published var discoveredDevices: [DiscoveredDevice] = []
	@Published var connectedPeripheralName: String? = nil
	@Published var connectionState: ConnectionState = .disconnected

	enum ConnectionState {
		case disconnected
		case connecting
		case connected
	}

	struct DiscoveredDevice: Identifiable, Equatable {
		let id: UUID
		let name: String
		let rssi: NSNumber
		fileprivate let peripheral: CBPeripheral

		static func == (lhs: DiscoveredDevice, rhs: DiscoveredDevice) -> Bool {
			lhs.id == rhs.id
		}
	}

	// CoreBluetooth
	private var central: CBCentralManager!
	private var connectedPeripheral: CBPeripheral? {
		didSet {
			connectedPeripheralName = connectedPeripheral?.name
			objectWillChange.send()
		}
	}
	private var discovered: [UUID: DiscoveredDevice] = [:]

	// Concept2 PM5 Services (from Concept2 docs)
	// Base: CE06xxxx-43E5-11E4-916C-0800200C9A66
    private let pmControlService = CBUUID(string: "CE060020-43E5-11E4-916C-0800200C9A66")
    private let pmRowingService = CBUUID(string: "CE060030-43E5-11E4-916C-0800200C9A66")
    private let deviceInformationService = CBUUID(string: "180A") // standard Device Information

	var isConnected: Bool { connectionState == .connected }

    private override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: .main, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }

    func startScanning() {
		guard isBluetoothPoweredOn else { return }
		if connectionState == .connected { return }
		discovered.removeAll()
		discoveredDevices = []
		isScanning = true
        // Do not filter by services: some PM5s may not advertise service UUIDs
        // Filter by name/service in didDiscover instead (per Concept2 samples)
        central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
	}

	func stopScanning() {
		isScanning = false
		central.stopScan()
	}

	func connect(to device: DiscoveredDevice) {
		connectionState = .connecting
		connectedPeripheral = device.peripheral
        central.stopScan()
        isScanning = false
        central.connect(device.peripheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey: true,
                                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,
                                                     CBConnectPeripheralOptionNotifyOnNotificationKey: true])
	}

	func disconnect() {
		guard let peripheral = connectedPeripheral else { return }
		central.cancelPeripheralConnection(peripheral)
	}
}

extension PM5BluetoothManager: CBCentralManagerDelegate {
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch central.state {
		case .poweredOn:
			isBluetoothPoweredOn = true
		default:
			isBluetoothPoweredOn = false
			isScanning = false
		}
	}

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let localName = (advertisementData[CBAdvertisementDataLocalNameKey] as? String) ?? peripheral.name ?? ""
        let serviceUUIDs = (advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID]) ?? []

        let nameLooksLikePM5 = localName.uppercased().contains("PM5")
        let advertisesPM5Service = serviceUUIDs.contains(pmControlService) || serviceUUIDs.contains(pmRowingService)
        guard nameLooksLikePM5 || advertisesPM5Service else { return }

        let displayName = localName.isEmpty ? "PM5" : localName
        let device = DiscoveredDevice(id: peripheral.identifier, name: displayName, rssi: RSSI, peripheral: peripheral)
        discovered[peripheral.identifier] = device
        discoveredDevices = Array(discovered.values).sorted { $0.rssi.intValue > $1.rssi.intValue }
    }

	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		peripheral.delegate = self
		connectionState = .connected
		connectedPeripheral = peripheral
		stopScanning()
        // Discover services to validate PM5
        peripheral.discoverServices([pmControlService, pmRowingService, deviceInformationService])
	}

	func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		connectionState = .disconnected
		connectedPeripheral = nil
	}

	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		connectionState = .disconnected
		connectedPeripheral = nil
		// Optionally restart scanning for convenience
	}
}

extension PM5BluetoothManager: CBPeripheralDelegate {
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		// Placeholder – future characteristic discovery will go here
	}
}


