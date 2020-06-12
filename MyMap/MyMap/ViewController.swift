//
//  ViewController.swift
//  MyMap
//
//  
//  Copyright © 2020 Swift-Beginners. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController ,UITextFieldDelegate{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Text Fieldのdelegate通知先を設定
        inputText.delegate = self
        
        
    }

    
    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var dispMap: MKMapView!
    
    //textField.textは値がない状態がある変数で「オプショナル」と呼ばれている キーボードの検索が押されると呼び出される
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //キーボードを閉じる
        textField.resignFirstResponder()
        
        //入力された文字を取り出す（もしオプショナルに値が入っていれば）
        if let serchKey = textField.text{
            
            //入力された文字をデバッグエリアに表示
            print(serchKey)
            //CLGeocoderインスタンスを取得　このクラスを使うと緯度経度から住所を検索することができる　逆も可能
            let geocoder = CLGeocoder()

            //入力された文字から位置情報を取得 住所の文字列から位置情報を取得するメソッド CLPlacemarkクラスで格納してくれる
            geocoder.geocodeAddressString(serchKey, completionHandler: {(placemarks,error)in
                //位置情報が存在する場合はunwrapPlacemarksに取り出す placemalksもオプショナルなのでif letを使いアンラップする
                if let unwrapPlacemarks = placemarks{
                    //1件目の情報を取り出す　unwrapPlacemarksは配列なので
                    if let firstPlacemark =  unwrapPlacemarks.first{
                        //経度や緯度、高度の情報を取り出す
                        if let location = firstPlacemark.location{
                            //locationの中にあるcoordinate緯度経度が格納されている変数
                            let targetCoordinate = location.coordinate
                            //デバッグエリアに緯度経度を表示
                            print(targetCoordinate)
                            //MKPointAnnotationインスタンスを取得し、ピン生成
                            let pin = MKPointAnnotation()
                            //ピンを置く経度緯度を設定
                            pin.coordinate = targetCoordinate
                            //pinのタイトルは最初に入力した文字列
                            pin.title = serchKey
                            //ピンを地図に置く
                            self.dispMap.addAnnotation(pin)
                            //緯度経度を中心として半径５００メートルの範囲を表示　引数は　中心　縦横の表示する幅（メートル単位）
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                            
                            
                        }
                    }
                }
                
                
            })
        }
        
        return true
    }
    @IBAction func changeMapButton(_ sender: Any) {
    }
}

