import SwiftUI
import SafariServices

struct SFSafariVC: UIViewControllerRepresentable {
    @Binding var website : String
    @Binding var isPressingDone: Bool
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: URL(string: website)!)
        print(website)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
    final class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let sf_vc : SFSafariVC
        
        init (sf_vc : SFSafariVC){
            self.sf_vc = sf_vc
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController){
            print("Done pressed")
            self.sf_vc.presentationMode.wrappedValue.dismiss()
        }
        
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(sf_vc: self)
    }
}
