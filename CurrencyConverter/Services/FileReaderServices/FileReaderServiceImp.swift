//
//  FileReaderServiceImp.swift
//  CurrencyConverter
//
//  Created by Hairui on 4/4/18.
//  Copyright © 2018 Hairui's Organisation. All rights reserved.
//

import Foundation
import RxSwift

class FileReaderServiceImp: FileReaderService {
    
    private let mappingClosure : (Any)->Any
    private let fileName : String
    
    init(fileEndPoint : FileReaderServiceEndPoints, mapping : @escaping (Any)->Any) {
        self.fileName = fileEndPoint.rawValue
        self.mappingClosure = mapping
    }
    
    func execute() -> Observable<FileResult> {
        return requestFile(name: fileName, completion: mappingClosure)
    }
    
    private func requestFile(name:String, type : String = "json", completion : @escaping (Any)->Any) -> Observable<FileResult>{
        return Observable.create({ (observer) -> Disposable in
            do{
                guard let filename = Bundle.main.url(forResource: name, withExtension: type) else{
                    throw FileReaderError.invalidFileName
                }
                
                let data = try Data(contentsOf: filename)
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])else{
                    throw FileReaderError.invalidData
                }
                let mappedData = completion(jsonObject)
                observer.onNext(FileResult.fileData(mappedData))
                observer.onCompleted()
                
            }catch FileReaderError.invalidFileName{
                print("[FileReader InvalidFileName Error - FileName:\(name)]")
                observer.onNext(FileResult.fileError(FileReaderError.invalidFileName))
                observer.onCompleted()
            }catch FileReaderError.invalidData{
                print("[FileReader InvalidData Error - FileName:\(name)]")
                observer.onNext(FileResult.fileError(FileReaderError.invalidData))
                observer.onCompleted()
            }catch{
                print("[FileReader Error - \(error.localizedDescription)]")
                observer.onNext(FileResult.fileError(FileReaderError.executeError))
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }    
    
}
