//
//  APIServiceImp.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire
import ObjectMapper

struct APIServiceImp : APIService{
    //    private var targetType : TargetType
    
    private var apiServiceProvider = MoyaProvider<APIServiceEndpoints>(manager: DefaultAlamofireManager.sharedManager) //MoyaProvider<SRAPIServiceEndPoints>(
    private var endPoint : APIServiceEndpoints
    private let mappingClosure : (Any)->Any
    
    init(endPoint : APIServiceEndpoints, mapping : @escaping (Any)->Any) {
        self.endPoint = endPoint
        self.mappingClosure = mapping
    }
    
    func execute() -> Observable<APIResult> {
        return execute(with: mappingClosure)
    }
    
    private func execute(with completion : @escaping (Any)->Any)->Observable<APIResult>{
        return Observable.create({ (observer) -> Disposable in
            self.apiServiceProvider.request(self.endPoint, completion: { (result) in
                switch result{
                case .success(let response):
                    guard (200..<300 ~= response.statusCode) else{
                        print("[API ERROR] \(self.endPoint.description) - Reponse StatusCode Invalid")
                        observer.onNext(APIResult.apiError(APIError.statusCodeInvalid   ))
                        observer.onCompleted()
                        return
                    }
                    do{
                        let responsData = try response.mapJSON()
                        /// The only function of mappedData which is an object of GeneralAPIModel
                        /// is to check if the call to API is successul
                        /// If it is successful, we pass the rawData to the closure
                        let mappedData = try Mapper<GeneraAPIModel>().map(JSONObject: responsData)
                        if mappedData.success {
                            let data = completion(responsData)
                            observer.onNext(APIResult.apiData(data))
                            observer.onCompleted()
                        }else{
                            if let error = mappedData.error{
                                print("[API ERROR] \(self.endPoint.description) - \(error.type)")
                                print("[API Message] \(self.endPoint.description) - \(error.info)")
                                let apiError = APIError.generalError(title: error.type, message: error.info)
                                observer.onNext(APIResult.apiError(apiError))
                            }
                            observer.onCompleted()
                        }
                    }catch{
                        print("[API ERROR] \(self.endPoint.description) - Mapping Error")
                        observer.onNext(APIResult.apiError(APIError.mappingError))
                        observer.onCompleted()
                    }
                case .failure(let error):
                    print("error in here = \(error.localizedDescription)")
                    observer.onNext(APIResult.apiError(APIError.mappingError))
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
}


class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 20 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
