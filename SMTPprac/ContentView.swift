import MessageUI
import SwiftUI
import UIKit

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation

    var address: [String]

    var subject: String

    var messageBody: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode

        init(
            presentation: Binding<PresentationMode>
        ) {
            _presentation = presentation
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            $presentation.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(presentation: presentation)
    }

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<MailView>
    ) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setToRecipients(address)
        viewController.setSubject(subject)
        viewController.setMessageBody(messageBody, isHTML: false)
        return viewController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {}
}

struct ContentView: View {
    @State var isShowMailView = false
    var body: some View {
        Button {
            #if DEBUG
            // シュミレータでは表示できない
            isShowMailView = true
            #endif
        } label: {
            Text("メール")
        }
        .sheet(isPresented: $isShowMailView) {
            MailView(
                address: ["swkshuto0208@icloud.com"],
                subject: "報告",
                messageBody: "サンプルアプリです"
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ContentView(isShowMailView: false)
}
