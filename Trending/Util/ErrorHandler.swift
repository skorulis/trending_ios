//
//  ErrorHandling.swift
//  Trending
//
//  Created by Alexander Skorulis on 12/12/20.
//

import Foundation
import SwiftUI

protocol ErrorHandler {
    func handle<T: View>(
        _ error: Error?,
        in view: T,
        retryHandler: (() -> Void)?
    ) -> AnyView
}

struct AlertErrorHandler: ErrorHandler {
    // We give our handler an ID, so that SwiftUI will be able
    // to keep track of the alerts that it creates as it updates
    // our various views:
    private let id = UUID()

    func handle<T: View>(
        _ error: Error?,
        in view: T,
        retryHandler: (() -> Void)?
    ) -> AnyView {

        var presentation = error.map { Presentation(
            id: id,
            error: $0,
            retryHandler: retryHandler
        )}

        // We need to convert our model to a Binding value in
        // order to be able to present an alert using it:
        let binding = Binding(
            get: { presentation },
            set: { presentation = $0 }
        )

        return AnyView(view.alert(item: binding, content: makeAlert))
    }
}

private extension AlertErrorHandler {
    struct Presentation: Identifiable {
        let id: UUID
        let error: Error
        let retryHandler: (() -> Void)?
    }
    
    func makeAlert(for presentation: Presentation) -> Alert {
        let error = presentation.error
        if let retry = presentation.retryHandler {
            return Alert(
                title: Text("An error occured"),
                message: Text(error.localizedDescription),
                primaryButton: .default(Text("Dismiss")),
                secondaryButton: .default(Text("Retry"), action: retry)
                
            )
        } else {
            return Alert(
                title: Text("An error occured"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Dismiss"))
            )
        }
    }
}

struct ErrorHandlerEnvironmentKey: EnvironmentKey {
    static var defaultValue: ErrorHandler = AlertErrorHandler()
}

extension EnvironmentValues {
    var errorHandler: ErrorHandler {
        get { self[ErrorHandlerEnvironmentKey.self] }
        set { self[ErrorHandlerEnvironmentKey.self] = newValue }
    }
}

extension View {
    func handlingErrors(
        using handler: ErrorHandler
    ) -> some View {
        environment(\.errorHandler, handler)
    }
}

struct ErrorEmittingViewModifier: ViewModifier {
    @Environment(\.errorHandler) var handler

    var error: Error?
    var retryHandler: (() -> Void)?

    func body(content: Content) -> some View {
        handler.handle(error,
            in: content,
            retryHandler: retryHandler
        )
    }
}

extension View {
    func emittingError(
        _ error: Error?,
        retryHandler: (() -> Void)?
    ) -> some View {
        modifier(ErrorEmittingViewModifier(
            error: error,
            retryHandler: retryHandler
        ))
    }
}

