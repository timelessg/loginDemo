//
//  NetworkClient.swift
//  Demo
//
//  Created by 郭锐 on 2016/12/18.
//  Copyright © 2016年 郭锐. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

let BaseUrl = "http://timelessg.cn/"

enum CZSError : Swift.Error {
    case HTTPFailed
    case MapperError
    case CustomError(msg:String,code:Int)
    
    func show() -> CZSError{
        switch self {
        case .HTTPFailed:break
        case .MapperError:break
        case .CustomError(let _, let _):break
        }
        return self
    }
}

let SUCCESSCODE    = 1

let RESULT_CODE    = "code"
let RESULT_MESSAGE = "msg"
let RESULT_DATA    = "result"


public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var hud: Bool { get }
}

extension Request {
    var hud: Bool {
        return false
    }
    
    var method: HTTPMethod {
        return HTTPMethod.post
    }
}

protocol RequestClient {
    var host: String { get }
    func send<T: Request>(_ r: T) -> Observable<[String : Any]>
}

public struct NetworkClient:RequestClient{
    var host: String {
        return BaseUrl
    }
    
    func send<T : Request>(_ r: T) -> Observable<[String : Any]> {
        if r.hud {
            
        }
        return Observable<[String : Any]>.create({ (observer) -> Disposable  in
            Alamofire.request(URL.init(string: "\(self.host)\(r.path)")!, method: r.method, parameters: r.parameters).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let json = response.result.value as? [String : Any] {
                        if let code = json[RESULT_CODE] as? Int {
                            if code == SUCCESSCODE {
                                observer.onNext(json[RESULT_DATA] as! [String : Any])
                                observer.onCompleted()
                            } else {
                                let message = json[RESULT_MESSAGE] as! String
                                observer.onError(CZSError.CustomError(msg: message, code: code).show())
                            }
                        } else {
                            observer.onError(CZSError.MapperError.show())
                        }
                    }else{
                        observer.onError(CZSError.MapperError.show())
                    }
                case .failure(_):
                    observer.onError(CZSError.HTTPFailed.show())
                }
            }
            return Disposables.create {
                
            }
        })
    }
}
