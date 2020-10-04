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
	private let fullVersionIdentifier = "com.hyston.hexthrees.iap.fullversion"
	
	static let shared = IAPHelper()
	
	private override init() {}
	
	enum IAPHelperError: Error {
		case noProductIDsFound
		case noProductsFound
		case paymentWasCancelled
		case productRequestFailed
	}
	
	var onReceiveProductsHandler: ((Result<[SKProduct], IAPHelperError>) -> Void)?
	
	func getProducts(withHandler productsReceiveHandler: @escaping (_ result: Result<[SKProduct], IAPHelperError>) -> Void) {
		onReceiveProductsHandler = productsReceiveHandler

		let request = SKProductsRequest(productIdentifiers: Set([fullVersionIdentifier]))
		request.delegate = self
		request.start()
	}
	
	private func getPriceFormatted(for product: SKProduct) -> String? {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = product.priceLocale
		return formatter.string(from: product.price)
	}
}

extension IAPHelper: SKProductsRequestDelegate {
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		onReceiveProductsHandler?(response.products.count > 0
									? .success(response.products)
									: .failure(.noProductsFound))
	}
	
	func request(_ request: SKRequest, didFailWithError error: Error) {
		onReceiveProductsHandler?(.failure(.productRequestFailed))
	}
}

extension IAPHelper.IAPHelperError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
		case .noProductsFound: return "No In-App Purchases were found."
		case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
		case .paymentWasCancelled: return "In-App Purchase process was cancelled."
		}
	}
}
