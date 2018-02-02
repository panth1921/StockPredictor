//
//  ViewController.swift
//  StockPredictor
//
//  Created by Panth Patel on 16/09/16.
//  Copyright © 2016 Panth Patel. All rights reserved.
//

import UIKit
import Foundation

var closingprice = String()
var targetresult = Double()

var nortargetresult = Double()




var vc = ViewController()




class ViewController: UIViewController {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let url = URL(string: "http://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=AAPL&apikey=8685ZJTXGSCENYGZ")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    do
                    {
                        //Array
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let Daily = myJson["Time Series (Daily)"] as? NSDictionary
                        {
                            var date = String()
                            date = "2017-11-08"
                            
                            if let date = Daily[date] as? NSDictionary
                            {
                                print("hiiii")
                                
                                if let cp = date["4. close"]
                                {
                                    print (cp)
                                    closingprice = "\(cp)"
                                    print (closingprice)
                                    self.backpropagate()
                                }
                            }
                            
                        }
                    }
                    catch
                    {
                        
                    }
                }
            }
        }
        task.resume()
        
    
    }
    
    
    var error = Double()
    var errorflag=true;
    var epochnumber = 0;
    
    var weights_0 = [0.656345,0.432734,0.243162,0.163723]
    var adweights_0: [Double] = []
    
    var weights_1 = [0.656381,0.432734,0.243162,0.163723]
    var adweights_1: [Double] = []
    
    var weights_2 = [0.656334,0.432734,0.243162,0.163723]
    var adweights_2: [Double] = []
    
    var weights_3 = [0.656356,0.432734,0.243162,0.163723]
    var adweights_3: [Double] = []
    
    var weights_4 = [0.656324,0.432734,0.243162,0.163723]
    var adweights_4: [Double] = []
    
    var weightshidden = [0.656324,0.432734,0.243162,0.163723]
    var adweightshidden: [Double] = []
    
    var neth = [Double](repeating: 0,count: 5 )
    var outh = [Double](repeating: 0,count: 5)
    var neto = Double()
    
    
    
    var i = [Neuron?](repeating: nil,count:4 )
    var h = [Neuron?](repeating: nil,count:5)
    var output = Neuron()
       
    
    
    
    func backpropagate()
    {
        
        targetresult = Double(closingprice)!
        nortargetresult = (((targetresult - 1)/targetresult) * 2) - 1
        
        print(closingprice,"backpropagate1")
        print("hiii1")
         print("someInts is of type [Int] with \(i.count) items.")
        print(targetresult)
        
        i[0]?.info = 113.29
        i[1]?.info = 115.00;
        i[2]?.info = 112.49;
        i[3]?.info = 113.30;
        
        for j in 0 ..< 4
        {
            i[j]?.norinput = ((((i[j]?.info)! - 1)/115.19) * 2) - 1;
        }
        
        for k in 0 ..< 5
        {
            for j in 0 ..< 4
            {
                i[j]?.next = h[k];
            }
            
            h[k]?.next = output;
            
        }
        
        while(errorflag == true)
        {
            for i in 0 ..< 5
            {
                h[i]?.info = 0.0;
            }
            
            
            errorflag = false;
            
            
            for y in 0 ..< 4
            {
                h[0]?.info += (i[y]?.norinput)! * weights_0[y];
            }
            
            for y in 0 ..< 4
            {
                h[1]?.info += (i[y]?.norinput)! * weights_1[y];
            }
            
            for y in 0 ..< 4
            {
                h[2]?.info += (i[y]?.norinput)! * weights_2[y];
            }
            
            for y in 0 ..< 4
            {
                h[3]?.info += (i[y]?.norinput)! * weights_3[y];
            }
            
            for y in 0 ..< 4
            {
                h[4]?.info += (i[y]?.norinput)! * weights_4[y];
            }
            
            
            
            for x in 0 ..< 5
            {
                
                outh[x] = 1/( 1 + pow(M_E,(-1*(h[x]?.info)!)));
            }
            
            
            for  x in 0 ..< 5
            {
                neto += outh[x] * weightshidden[x];
            }
            
            output.info = 1/( 1 + pow(M_E,(-1*neto)));
            error = ((nortargetresult-output.info) * (nortargetresult-output.info))/2;
            
            
            
            for i in 0 ..< 5
            {
                h[i]?.info = 0.0;
            }
            
            if(error > 0.00011 )
            {
                epochnumber += 1;
                errorflag = true;
                
                adweightshidden = adjustingweightsh(weightshidden,outh: outh);
                adweights_0 = adjustingweights(weights_0,outh: outh);
                adweights_1 = adjustingweights(weights_1,outh: outh);
                adweights_2 = adjustingweights(weights_2,outh: outh);
                adweights_3 = adjustingweights(weights_3,outh: outh);
                adweights_4 = adjustingweights(weights_4,outh: outh);
                
                
                
                let interresult = output.info + 1
                let interesult2 = interresult*116
                let interesult3 = interesult2/2
                let interesult4 = interesult3 + 1;
                
                print("Prediction1 = \(interesult4)");
                
                weightshidden = adweightshidden;
                weights_0 = adweights_0;
                weights_1 = adweights_1;
                weights_2 = adweights_2;
                weights_3 = adweights_3;
                weights_4 = adweights_4;
                
                
                for i in 0 ..< 5
                {
                    h[i]?.info = 0.0;
                }
                neto = 0.0;
                
                
                
                
                
                
            }
            
        }
        
    }
    
    
    func adjustingweights(_ weights: [Double], outh: [Double]) -> [Double]
    {
        
        var outnor = output.info - nortargetresult
        var outnoroutoneminusout = (outnor) * (output.info) * (1 - output.info)
        var adweights = [Double](repeating: 0, count: weights.count)
        for z in 0 ..< weights.count
        {
            for y in 0 ..< weights.count
            {
                
               var result1 = outnoroutoneminusout * (outh[z])
               var result2 = (1 - outh[z]) * (weightshidden[z])
               
                
                adweights[y] = weights[y] - (0.2 * (i[y]?.norinput)!);
            }
        }
        
        return adweights;
        
    }
    
    
    func adjustingweightsh(_ weights: [Double], outh: [Double]) -> [Double]
    {
        
        var adweights = [Double]( repeating: 0, count: weights.count)
        for x in 0 ..< weights.count
        {
            adweights[x] = weights[x] - ((0.2) * (output.info-nortargetresult) * (output.info) * (1 - output.info) * (outh[x]));
        }
        return adweights;
        
    }
    
    
    
    
    
}
