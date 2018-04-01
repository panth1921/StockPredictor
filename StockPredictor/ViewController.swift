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
var openprice = String()
var lowprice = String()
var highprice = String()

var closingtarget = String()
var openpricepredict = String()
var lowpricepredict = String()
var highpricepredict = String()



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
        var urlstr = "http://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=AAPL&apikey=8685ZJTXGSCENYGZ"
        let url = URL(string: urlstr)
         var request = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            request.setValue("application/xml;charset=utf-8", forHTTPHeaderField: "Content-Type")
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

                        
                        
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let Daily = myJson["Time Series (Daily)"] as? NSDictionary
                        {
                            var userCalendar = Calendar.current
                            
                            var datetest: Date!
                            var datetest1: Date!
                            var datetest2: Date!
                            
                            
                            
                            datetest = userCalendar.date(byAdding: .day, value: 0, to: Date())
                            datetest1 = userCalendar.date(byAdding: .day, value: -1, to: Date())
                            
                            var dateFormatter = DateFormatter()
                            var dateFormatter1 = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
        /*for time*/         dateFormatter1.timeZone = TimeZone(abbreviation: "EST")
         /*for time*/         dateFormatter1.dateFormat = "HH:mm:00"
         /*for time*/        var stringtime: String = dateFormatter1.string(from: datetest as Date)
         /*for time*/        print(stringtime)
                            
                            var stringdate: String = dateFormatter.string(from: datetest as Date)
                            var stringdate1: String = dateFormatter.string(from: datetest1 as Date)
                            print(stringdate)
                            //print(stringdate1)
        
         /* current date*/    print("before while",stringdate,datetest)
                            
                            while (Daily[stringdate] as? NSDictionary == nil)
                            {
                                print("daily1",Daily[stringdate] as? NSDictionary)
                                print("in while loop1")
                                
                                datetest = userCalendar.date(byAdding: .day, value: -1, to: datetest)
                                 stringdate = dateFormatter.string(from: datetest as Date)
                                print(stringdate)
                                
                            }
                            print("after while1",stringdate)
                            
                           
                            
                            if let date = Daily[stringdate] as? NSDictionary
                            {
                                
                                if let cp = date["4. close"], let cp2 = date["1. open"],let cp3 = date["2. high"], let cp4 = date["3. low"]
                                {
                                    print (cp)
                                    closingtarget = "\(cp)"
                                    openpricepredict = "\(cp2)"
                                    highpricepredict  = "\(cp3)"
                                    lowpricepredict = "\(cp4)"
                                    print ("closingpricepredict = ",closingtarget)
                                    print ("openpricepredict = ",openpricepredict)
                                    print ("highpricepredict = ",highpricepredict)
                                    print ("lowpricepredict = ",lowpricepredict)
                                    
                                }
                            }
                            
                            datetest = userCalendar.date(byAdding: .day, value: -1, to: datetest)
                            stringdate = dateFormatter.string(from: datetest as Date)
                            
                           
                            
                            while (Daily[stringdate] as? NSDictionary == nil)
                            {
                                print("daily2",Daily[stringdate] as? NSDictionary)
                                print("in while loop2")
                                
                                datetest = userCalendar.date(byAdding: .day, value: -1, to: datetest)
                                stringdate = dateFormatter.string(from: datetest as Date)
                                print(stringdate)
                            }
                            print("after while2",stringdate)
                            
                           
                            
                        if let date = Daily[stringdate] as? NSDictionary
                            {
                                print("hiiii")
                                print(datetest)
                                
        if let cp = date["4. close"], let cp2 = date["1. open"],let cp3 = date["2. high"], let cp4 = date["3. low"]
                                {
                                    print (cp)
                                    closingprice = "\(cp)"
                                    openprice = "\(cp2)"
                                    highprice  = "\(cp3)"
                                     lowprice = "\(cp4)"
                                    print ("closingprice = ",closingprice)
                                    print ("openprice = ",openprice)
                                    print ("highprice = ",highprice)
                                    print ("lowprice = ",lowprice)
                                    self.backpropagate()
                                }
                               
                            }
                            else
                        {
                            
                            var userCalendar = Calendar.current
                            var datetest: Date!
                            
                            
                              datetest = userCalendar.date(byAdding: .day, value: -1, to: Date())
                            
                            
                            var dateday = userCalendar.component(.day, from: datetest)
                            var dateyear = userCalendar.component(.year, from: datetest)
                            var datemonth = userCalendar.component(.month, from: datetest)
                           print("nil")
                           
                            
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
    
    var weights_0 = [0.7426,0.432734,0.243162,0.163723]
    var adweights_0: [Double] = []
    
    var weights_1 = [0.656381,0.432734,0.243162,0.163723]
    var adweights_1: [Double] = []
    
    var weights_2 = [0.656334,0.432734,0.243162,0.163723]
    var adweights_2: [Double] = []
    
    var weights_3 = [0.656356,0.432734,0.243162,0.163723]
    var adweights_3: [Double] = []
    
    var weights_4 = [0.34578,0.432734,0.243162,0.23451]
    var adweights_4: [Double] = []
    
    var weightshidden = [0.656324,0.432734,0.243162,0.163723,0.42803]
    var adweightshidden: [Double] = []
    
    var neth = [Double](repeating: 0,count: 5 )
    var outh = [Double](repeating: 0,count: 5)
    var neto = Double()
    
    
    
    var i = [Neuron?](repeating: nil,count:4 )
    var h = [Neuron?](repeating: nil,count:5)
    var output = Neuron(info: 0.0)
       
    
    
    
    func backpropagate()
    {
        
        targetresult = Double(closingtarget)!
        
        //targetresult = 167
        
        nortargetresult = (((targetresult - 1)/targetresult) * 2) - 1
        
        //*print(closingprice,"backpropagate1")
        //print("hiii1")
        //print("someInts is of type [Int] with \(i.count) items.")
        //print("targetresult =", targetresult)//
        
        var closingpriceinfo = Double(closingprice)!
        var openpriceinfo = Double(openprice)!
        var highpriceinfo = Double(highprice)!
        var lowpriceinfo = Double(lowprice)!

       
        i[0] = Neuron(info: closingpriceinfo)
        i[1] = Neuron(info: openpriceinfo)
        i[2] = Neuron(info: highpriceinfo)
        i[3] = Neuron(info: lowpriceinfo)
        
        h[0] = Neuron(info: 0)
        h[1] = Neuron(info: 0)
        h[2] = Neuron(info: 0)
        h[3] = Neuron(info: 0)
        h[4] = Neuron(info: 0)
        
        print("i[0] = ", i[0]!.info)
       
        print("i[0] = ", i[0]!.info)
        
        for j in 0 ..< 4
        {
            i[j]?.norinput = ((((i[j]?.info)! - 1)/targetresult) * 2) - 1;
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
            
            
            print("w1 = " , weights_0[0] , ", " , weights_0[1]  , ", " , weights_0[2] , ", " , weights_0[3]);
            print("w1 = " , weights_1[0] , ", " , weights_1[1]  , ", " , weights_1[2] , ", " , weights_1[3]);
            print("w1 = " , weights_2[0] , ", " , weights_2[1]  , ", " , weights_2[2] , ", " , weights_2[3]);
            print("w1 = " , weights_3[0] , ", " , weights_3[1]  , ", " , weights_3[2] , ", " , weights_3[3]);
            print("w1 = " , weights_4[0] , ", " , weights_4[1]  , ", " , weights_4[2] , ", " , weights_4[3]);
            
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
               
                
                outh[x] = 1/( 1 + pow(M_E,(-1*(h[x]!.info))));
            }
            
            
            for  x in 0 ..< 5
            {
                neto += outh[x] * weightshidden[x];
            }
            
            output.info = 1/( 1 + pow(M_E,(-1*neto)));
            error = ((nortargetresult-output.info) * (nortargetresult-output.info))/2;
            
            let interresult = output.info + 1
            let interesult2 = interresult*targetresult
            let interesult3 = interesult2/2
            let interesult4 = interesult3 + 1;
             print("output.info = \(interesult4)");
            
            
            for i in 0 ..< 5
            {
                h[i]?.info = 0.0;
            }
            
            if(error >  0.000000001 )
            {
                epochnumber += 1
                print("epoch = ", epochnumber)
                print("error = ", error )
                errorflag = true;
                
                adweightshidden = adjustingweightsh(weightshidden,outh: outh);
                adweights_0 = adjustingweights(weights_0,outh: outh);
                adweights_1 = adjustingweights(weights_1,outh: outh);
                adweights_2 = adjustingweights(weights_2,outh: outh);
                adweights_3 = adjustingweights(weights_3,outh: outh);
                adweights_4 = adjustingweights(weights_4,outh: outh);
                
                
                
               
                
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
            
            else
            {
            
              prediction()
                
            }
            
        }
        
    }
    
    
    func prediction()
    {
     
        print ("closingpricepredict = ",closingtarget)
        print ("openpricepredict = ",openpricepredict)
        print ("highpricepredict = ",highpricepredict)
        print ("lowpricepredict = ",lowpricepredict)
        
        var closingpriceinfo = Double(closingtarget)!
        var openpriceinfo = Double(openpricepredict)!
        var highpriceinfo = Double(highpricepredict)!
        var lowpriceinfo = Double(lowpricepredict)!
        
        
        i[0] = Neuron(info: closingpriceinfo)
        i[1] = Neuron(info: openpriceinfo)
        i[2] = Neuron(info: highpriceinfo)
        i[3] = Neuron(info: lowpriceinfo)
        
        
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
            
            
            outh[x] = 1/( 1 + pow(M_E,(-1*(h[x]!.info))));
        }
        
        
        for  x in 0 ..< 5
        {
            neto += outh[x] * weightshidden[x];
        }
        
        output.info = 1/( 1 + pow(M_E,(-1*neto)));
        
        
        
        
        
        
        let interresult = output.info + 1
        let interesult2 = interresult*targetresult
        let interesult3 = interesult2/2
        let interesult4 = interesult3 + 1;
        
        print("w1 = " , weights_0[0] , ", " , weights_0[1]  , ", " , weights_0[2] , ", " , weights_0[3]);
        print("w1 = " , weights_1[0] , ", " , weights_1[1]  , ", " , weights_1[2] , ", " , weights_1[3]);
        print("w1 = " , weights_2[0] , ", " , weights_2[1]  , ", " , weights_2[2] , ", " , weights_2[3]);
        print("w1 = " , weights_3[0] , ", " , weights_3[1]  , ", " , weights_3[2] , ", " , weights_3[3]);
        print("w1 = " , weights_4[0] , ", " , weights_4[1]  , ", " , weights_4[2] , ", " , weights_4[3]);
        
        print("Prediction = \(interesult4)");
        
        
        var holidayarray = ["2018-03-30","2018-05-28","2018-07-04","2018-09-03","2018-11-22","2018-12-25"
,"2019-01-01","2019-01-21","2019-02-18","2019-04-19","2019-05-27","2019-07-04","2019-09-02","2019-11-28","2019-12-25"
,"2020-01-01","2020-01-20","2020-02-17","2020-04-10","2020-05-25","2020-07-03","2020-09-07","2020-11-26","2020-12-25"
,"2021-01-01","2021-01-18","2021-02-15","2021-04-02","2021-05-31","2021-07-05","2021-09-06","2021-11-25","2021-12-24"
,"2022-01-01","2022-01-17","2022-02-21","2022-04-15","2022-05-30","2022-07-04","2022-09-05","2022-11-24","2022-12-26"
,"2023-01-02","2023-01-16","2023-02-20","2023-04-07","2023-05-29","2023-07-04","2023-09-04","2023-11-23","2023-12-25"
,"2024-01-01","2024-01-15","2024-02-19","2024-03-29","2024-05-27","2024-07-04","2024-09-02","2024-11-28","2024-12-25"
,"2025-01-01","2025-01-20","2025-02-17","2025-04-18","2025-05-26","2025-07-04","2025-09-01","2025-11-27","2025-12-25"         ]
        
         var datetest: Date!
       // var datefortest: Date!
        var userCalendar = Calendar.current
        
        datetest = userCalendar.date(byAdding: .day, value: 0, to: Date())
        datetest = userCalendar.date(byAdding: .day, value: 0, to: datetest)
        print("dateforpuretest = ",datetest)
        datetest = userCalendar.date(byAdding: .day, value: 1, to: datetest)
        
        //datefortest = userCalendar.date(byAdding: .day, value: -2, to: Date())
         var weekdayint = userCalendar.component(.weekday, from: datetest)
         print("weekdayint0 =",weekdayint)
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var stringdate: String = dateFormatter.string(from: datetest as Date)
        print("stringdate0 = ",stringdate)
        var strd = true;
        
      // var stringdate1: String = dateFormatter.string(from: datefortest as Date)
        //print("stringdate1 = ",stringdate)
       // datetest = userCalendar.date(byAdding: .day, value: 1, to: datetest)
        //datefortest = userCalendar.date(byAdding: .day, value: 1, to: datetest)
        
        while strd == true
        {
            for  x in 0 ..< 67
            {
                if(stringdate == holidayarray[x] )
                {
                    strd = false
                    datetest = userCalendar.date(byAdding: .day, value: 1, to: datetest)
                    print("holiday")
                }
            }
            strd = false
            //not sure look at code again
        }
        
       weekdayint = userCalendar.component(.weekday, from: datetest)
        
        print("weekdayint1 =",weekdayint)
         if(weekdayint == 7)
         {
         datetest = userCalendar.date(byAdding: .day, value: 2, to: datetest)
             stringdate = dateFormatter.string(from: datetest as Date)
/*check for holiday*/while strd == true
                {
                for  x in 0 ..< 67
                {
                    if(stringdate == holidayarray[x] )
/*check for holiday*/ {
                        strd = false
                        datetest = userCalendar.date(byAdding: .day, value: 1, to: datetest)
 /*check for holiday*/    print("holiday")
                    }
                }
                strd = false
                }
/*check for holiday*/
         stringdate = dateFormatter.string(from: datetest as Date) //final stringdate
            print(stringdate)
         var weekdayint1 = userCalendar.component(.weekday, from: datetest)
         print(weekdayint1)
         print(datetest)
         }
        else if(weekdayint == 1)
         {
            datetest = userCalendar.date(byAdding: .day, value: 1, to: datetest)
            stringdate = dateFormatter.string(from: datetest as Date)
/*check for holiday*/while strd == true
                {
                for  x in 0 ..< 67
                    {
                    if(stringdate == holidayarray[x] )
/*check for holiday*/{
                        strd = false
                        datetest = userCalendar.date(byAdding: .day, value: 1, to: datetest)
/*check for holiday*/ print("holiday")
                    }
                    }
                strd = false
                //not sure look at code again
                }
 /*check for holiday*/
            
            stringdate = dateFormatter.string(from: datetest as Date) //final stringdate
            print(stringdate)
            var weekdayint1 = userCalendar.component(.weekday, from: datetest)
            print(weekdayint1)
            print(datetest)
        }
         else
         {
            stringdate = dateFormatter.string(from: datetest as Date) //final stringdate
            print(stringdate)
        print(datetest)
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
                var result3 = result1 * result2
               var result4 = result3 * 8
                
                adweights[y] = weights[y] - (result4 * (i[y]?.norinput)!);
            }
        }
        
        return adweights;
        
    }
    
    
    func adjustingweightsh(_ weights: [Double], outh: [Double]) -> [Double]
    {
        
        var adweights = [Double]( repeating: 0, count: weights.count)
        for x in 0 ..< weights.count
        {
            adweights[x] = weights[x] - ((8) * (output.info-nortargetresult) * (output.info) * (1 - output.info) * (outh[x]));
        }
        return adweights;
        
    }
    
    
    
    
    
}
