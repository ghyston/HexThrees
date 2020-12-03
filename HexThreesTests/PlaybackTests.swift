//
//  PlaybackTests.swift
//  HexThreesTests
//
//  Created by Ilja Stepanow on 02.09.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

@testable import HexThrees
import XCTest

// @todo:
// Add test cases:
// pause
// update delta much more than duration
// callback is called on edge cases

class PlaybackRegularTests: XCTestCase {
	var playback: Playback!
	
	override func setUp() {
		// Given
		playback = Playback()
	}
	
	func testUnreversedUnscaled() {
		// When
		playback.start(duration: 5.0)
		
		// Then
		XCTAssertEqual(playback.update(delta: 1.0), 0.2)
		XCTAssertEqual(playback.update(delta: 2.0), 0.6)
		XCTAssertEqual(playback.update(delta: 3.0), 1.0)
		XCTAssertEqual(playback.update(delta: 1.0), 1.0)
	}
	
	func testReversedUnscaled() {
		// When
		playback.start(duration: 5.0, reversed: true)
		
		// Then
		XCTAssertEqual(playback.update(delta: 1.0), 0.8)
		XCTAssertEqual(playback.update(delta: 2.0), 0.4)
		XCTAssertEqual(playback.update(delta: 3.0), 0.0)
		XCTAssertEqual(playback.update(delta: 1.0), 0.0)
	}
}

class PlaybackCallbackTests: XCTestCase {
	var playback: Playback!
	var counter: Int = 0
	
	override func setUp() {
		// Given
		playback = Playback()
		counter = 1
	}
	
	private func incCounter() {
		counter += 1
	}
	
	/* func testCallbackIsCalledOnce() {
	 
	     //When
	     playback.start(
	         duration: 1.0,
	         reversed: false,
	         repeated: false,
	         onFinish: self.incCounter)
	     _ = playback.update(delta: 1.2)
	 
	     // Then
	     XCTAssertEqual(counter, 2)
	 }
	 
	 func testCallbackWasCalledTwiceInOneUpdate() {
	 
	     //When
	     playback.start(
	         duration: 1.0,
	         reversed: false,
	         repeated: false,
	         onFinish: self.incCounter)
	     _ = playback.update(delta: 2.2)
	 
	     // Then
	     XCTAssertEqual(counter, 3) //@todo: fix that!
	 } */
}
