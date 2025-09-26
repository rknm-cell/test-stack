
import Foundation
import Combine

class PlayLogViewModel: ObservableObject {
    @Published var playDescription = ""
    @Published var selectedCategory: PlayCategory = .general
    @Published var playDate = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let appState: AppState
    private var cancellables = Set<AnyCancellable>()
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    // MARK: - Validation
    var isFormValid: Bool {
        !playDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Actions
    func savePlayEntry() {
        guard isFormValid else {
            errorMessage = "Please enter a description for your play moment"
            return
        }
        
        guard let currentUser = appState.currentUser else {
            errorMessage = "User not authenticated"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Create the play entry
        let playEntry = PlayEntry(
            userId: currentUser.id,
            description: playDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            date: playDate
        )
        
        // Add to app state
        appState.addPlayEntry(playEntry)
        
        // Reset form
        resetForm()
        
        isLoading = false
        
        // Show success feedback (you could add a success message here)
        print("Play entry saved successfully!")
    }
    
    func resetForm() {
        playDescription = ""
        selectedCategory = .general
        playDate = Date()
        errorMessage = nil
    }
}


