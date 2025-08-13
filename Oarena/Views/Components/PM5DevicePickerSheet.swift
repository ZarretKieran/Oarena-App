//
//  PM5DevicePickerSheet.swift
//  Oarena
//

import SwiftUI

struct PM5DevicePickerSheet: View {
	@Environment(\.dismiss) private var dismiss
	@ObservedObject private var pm5 = PM5BluetoothManager.shared

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Header + Scan Button Card
                    CardView(backgroundColor: Color.oarenaAccent.opacity(0.05)) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Connect to PM5")
                                    .font(.headline)
                                    .foregroundColor(.oarenaPrimary)
                                Text("Make sure your PM5 is on and nearby.")
                                    .font(.caption)
                                    .foregroundColor(.oarenaSecondary)
                            }
                            Spacer()
                            Button(action: {
                                if pm5.isScanning { pm5.stopScanning() } else { pm5.startScanning() }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: pm5.isScanning ? "pause.circle.fill" : "dot.radiowaves.left.and.right")
                                        .foregroundColor(.white)
                                    Text(pm5.isScanning ? "Stop" : "Scan")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.oarenaAccent)
                                .cornerRadius(10)
                                .shadow(color: Color.oarenaAccent.opacity(0.25), radius: 6, x: 0, y: 3)
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Devices Card
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Nearby PM5 Monitors")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.oarenaPrimary)
                                Spacer()
                                if pm5.isScanning { ProgressView().scaleEffect(0.8) }
                            }

                            if pm5.discoveredDevices.isEmpty {
                                Text("No PM5s found.")
                                    .font(.caption)
                                    .foregroundColor(.oarenaSecondary)
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(pm5.discoveredDevices) { device in
                                        Button {
                                            pm5.connect(to: device)
                                            dismiss()
                                        } label: {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(device.name)
                                                        .font(.body)
                                                        .fontWeight(.medium)
                                                        .foregroundColor(.oarenaPrimary)
                                                    Text("RSSI \(device.rssi.intValue)")
                                                        .font(.caption)
                                                        .foregroundColor(.oarenaSecondary)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(.oarenaSecondary)
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 10)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Connect PM5")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
	PM5DevicePickerSheet()
}


