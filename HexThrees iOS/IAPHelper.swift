//
//  IAPHelper.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 02.10.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation
import StoreKit

typealias ProductIdentifier = String

class IAPHelper: NSObject {
	private let fullVersionIdentifier = "com.hyston.HexThrees.fullversioniap"
	
	private var fullVersionProduct: SKProduct?
    
    enum RestoringState {
        case Default
        case RestoreRequested
        case RestoreReceived
    }
    private var restoredState: RestoringState = .Default;
	
	static let shared = IAPHelper()
	
	func canBePurchased() -> Bool {
		SKPaymentQueue.canMakePayments()
	}
	
	func productIsSet() -> Bool {
		fullVersionProduct != nil
	}
	
	private override init() {}
	
	func updateProducts() {
		if !SKPaymentQueue.canMakePayments() {
			return
		}

		let identifiers = [fullVersionIdentifier]
		let request = SKProductsRequest(productIdentifiers: Set(identifiers))
		request.delegate = self
		request.start()
	}
	
	func buy() {
		guard let product = fullVersionProduct else {
			handleProductNotFound()
			return
		}
		
		let payment = SKMutablePayment(product: product)
		SKPaymentQueue.default().add(payment)
	}
	
	func restore() {
        restoredState = .RestoreRequested
		SKPaymentQueue.default().restoreCompletedTransactions()
	}
	
	func getFullVersionPriceFormatted() -> String? {
		guard let product = fullVersionProduct else {
			return nil
		}
		
		return getPriceFormatted(for: product)
	}
	
	private func getPriceFormatted(for product: SKProduct) -> String? {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = product.priceLocale
		return formatter.string(from: product.price)
	}
    
    private func isFullVersionProduct(_ transaction: SKPaymentTransaction) -> Bool {
        transaction.payment.productIdentifier == fullVersionIdentifier
    }
}

// MARK: Purchase handlers
extension IAPHelper {
    
    fileprivate func handle(_ transaction: SKPaymentTransaction, callback: (() -> Void)? = nil, broadcastName: NSNotification.Name, finishTransaction: Bool) {
        if isFullVersionProduct(transaction){
            broadcast(broadcastName)
            callback?();
        }
        if finishTransaction {
            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }
    
    fileprivate func handleProductNotFound() {
        broadcast(.productNotFound)
    }
    
    fileprivate func restoreReceived() {
        restoredState = .RestoreReceived
    }
    
    fileprivate func finishRestore() {
        restoredState = .Default
    }
    
	private func broadcast(_ name: NSNotification.Name) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: name,
				object: nil)
		}
	}
}

// MARK: SKProductsRequestDelegate
extension IAPHelper: SKProductsRequestDelegate {
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		self.fullVersionProduct = response.products.first {$0.productIdentifier == fullVersionIdentifier}
	}
}

// MARK: SKPaymentTransactionObserver
extension IAPHelper: SKPaymentTransactionObserver {
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
			switch transaction.transactionState {
			case .purchasing: break;
            case .deferred: handle(transaction, broadcastName: .purchaseDeffered, finishTransaction: false)
            case .purchased: handle(transaction, broadcastName: .purchaseSuccessfull, finishTransaction: true)
            case .failed: handle(transaction, broadcastName: .purchaiseFailed, finishTransaction: true)
            case .restored: handle(transaction, callback: restoreReceived, broadcastName: .restoreSuccessfull, finishTransaction: true)
			@unknown default: fatalError("Unknown payment transaction case.")
			}
		}
	}
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        broadcast(.restoreFailed)
        finishRestore()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if (restoredState == .RestoreRequested) {
            broadcast(.restoreFailed)
        }
        finishRestore()
    }
}
