//  Created by Alexander Skorulis on 29/12/20.

import Foundation
import SwiftUI

class DebugSettingsViewModel: ObservableObject {
    
    @Published var networkSource: Int = 0 {
        didSet {
            UserDefaults.standard.setValue(networkSource, forKey: DebugConfigService.kMainURLKey)
        }
    }
    
}

struct DebugSettingsView: View {
    
    @State private var localServer = false
    @ObservedObject var viewModel: DebugSettingsViewModel
    
    init(locator: Servicelocator) {
        self.viewModel = DebugSettingsViewModel()
    }
    
    var body: some View {
        return ScrollView {
            VStack {
                Picker(selection: $viewModel.networkSource, label: Text("Picker")) {
                    Text("Prod").tag(0)
                    Text("Local").tag(1)
                    Text("Mocks").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                }
        }.navigationTitle("Debug")
    }
    
}
