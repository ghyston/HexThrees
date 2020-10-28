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
}

// MARK: Purchase handlers
extension IAPHelper {
	
	fileprivate func handlePurchased(_ transaction: SKPaymentTransaction) {
		broadcast(.purchaseSuccessfull)
		SKPaymentQueue.default().finishTransaction(transaction)
	}
	
	fileprivate func handleFailed(_ transaction: SKPaymentTransaction) {
		broadcast(.purchaiseFailed)
		SKPaymentQueue.default().finishTransaction(transaction)
	}
	
	fileprivate func handleRestored(_ transaction: SKPaymentTransaction) {
		broadcast(.restoreSuccessfull)
		SKPaymentQueue.default().finishTransaction(transaction)
	}
	
	fileprivate func handleDeffered(_ transaction: SKPaymentTransaction) {
		broadcast(.purchaseDeffered)
	}
	
	fileprivate func handleProductNotFound() {
		broadcast(.productNotFound)
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
			case .deferred: handleDeffered(transaction)
			case .purchased: handlePurchased(transaction)
			case .failed: handleFailed(transaction)
			case .restored: handleRestored(transaction)
			@unknown default: fatalError("Unknown payment transaction case.")
			}
		}
	}
}
