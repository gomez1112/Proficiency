//
//  UnlockManager.swift
//  Proficiency
//
//  Created by Gerard Gomez on 1/14/23.
//

import StoreKit

final class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    enum RequestState {
        case loading
        case loaded(SKProduct)
        case failed(Error?)
        case purchased
        case deferred
    }
    private enum StoreError: Error {
        case invalidIdentifiers, missingProduct
    }
    @Published var requestState = RequestState.loading
    private let dataController: DataController
    private let request: SKProductsRequest
    private var loadedProducts = [SKProduct]()
    init(dataController: DataController) {
        // Store the data controller we were sent.
        self.dataController = dataController
        let productIDs = Set(["com.transfinite.Proficiency.unlock"])
        request = SKProductsRequest(productIdentifiers: productIDs)
        super.init()
        SKPaymentQueue.default().add(self)
        guard !dataController.fullVersionUnlocked else { return }
        request.delegate = self
        request.start()
    }
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async { [self] in
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased, .restored:
                    self.dataController.fullVersionUnlocked = true
                    self.requestState = .purchased
                    queue.finishTransaction(transaction)
                case .failed:
                    if let product = loadedProducts.first {
                        self.requestState = .loaded(product)
                    } else {
                        self.requestState = .failed(transaction.error)
                    }
                    queue.finishTransaction(transaction)
                case .deferred:
                    self.requestState = .deferred
                default:
                    break
                }
            }
        }
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.loadedProducts = response.products
            guard let unlock = self.loadedProducts.first else { self.requestState = .failed(StoreError.missingProduct)
                return
            }
            if !response.invalidProductIdentifiers.isEmpty {
                print("ALERT: Received invalid product identifiers: \(response.invalidProductIdentifiers)")
                return
            }
            self.requestState = .loaded(unlock)
        }
    }
    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
