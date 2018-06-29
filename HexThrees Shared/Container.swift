//
//  InstanceContainer.swift
//  Ravens macOS
//
//  Created by Ilja Stepanow on 09.11.17.
//  Copyright © 2017 Ilja Stepanow. All rights reserved.
//

import Foundation

/**
 Usage:
 
 let container = Container()
 let foo = FooImpl()
 container.Register(foo as Foo)
 let resolved : Foo? = container.Resolve()
 
 */
class Container {
    
    var instances = Dictionary<String, Any>()
    
    //@todo: rename it with code convensions (camelCaseSmallFirst)
    
    func Register<T>(_ inst: T) {
        
        let typeName = "\(T.self)"
        instances[typeName] = inst
    }
    
    func Resolve<T>() -> T {
        
        let typeName = "\(T.self)"
        let result = instances[typeName]
        
        //@todo: check type and throw exception, if not correct
        
        return result as! T
    }
    
    func TryResolve<T>() -> Optional<T> {
        
        let typeName = "\(T.self)"
        let result = instances[typeName]
        return result as? T
    }
    
    //@todo: call it on finish and ensure, that all d-tors are called!
    func Clean() {
        instances.removeAll()
    }
    
    func debug() {
        dump(instances)
    }
}

/*func testInstanceContainer () {
    let foo1 = FooImpl1()
    let foo2 = FooImpl2()
    let container = Container()
    
    container.Register(foo1 as Foo)
    container.Register(foo2 as Foo)
    container.debug()
    
    let resolved : Foo? = container.Resolve()
    resolved?.printFoo()
    print ("temp")
}*/
