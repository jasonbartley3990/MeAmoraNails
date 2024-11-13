//
//  RecentMeasurementsScreen.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct RecentMeasurementsScreen: View {
    var calender = Calendar.current
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    @EnvironmentObject var environment: EnvironmentViewModel
    
    @ObservedObject var viewModel: NailCameraViewModel
    
    @StateObject var recentMeasurementsViewModel: RecentMeasurementsViewModel = RecentMeasurementsViewModel()
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    Color.white.ignoresSafeArea(.all)
                    
                    VStack {
                        HStack {
                            Spacer().frame(width: 15, height: 15)
                            Image("chevron.left").resizable()
                                .frame(width: 10, height: 14).onTapGesture {
                                self.didTapBack()
                                }
                                .offset(x: 7, y: 1)
                            
                            Spacer()
                            
                            Text("Recent Measurements").font(.system(size: 24, weight: .bold)).padding()
                            
                            Spacer()
                            
                            Spacer().frame(width: 10, height: 14)
                            Spacer().frame(width: 15, height: 15)
                        }
                        
                        if environment.successfulMeasurements.isEmpty {
                            Spacer()
                            
                            Text("No Measurements")
                                .font(.system(size: 22))
                                .foregroundStyle(.myMeAmore)
                            
                            OrangeButtonView(text: "Start New Measurement").onTapGesture {
                                self.viewModel.showOptionMenu = true
                                self.didTapBack()
                                self.viewModel.showProfile = false
                            }
                            
                        } else {
                            ScrollView {
                                ForEach(self.environment.successfulMeasurements) {
                                    measurement in
                                    let date = getDateString(date: measurement.createddate ?? "Unknown Date")
                                    VStack {
                                        NavigationLink(destination: PreviousMeasurementsScreen(measurement: measurement, viewModel: self.viewModel), label: {
                                            //Text(date ?? "Unknown Date")
                                            
                                            HStack {
                                                Image("MyMeasurementButton")
                                                
                                                Text(date ?? "Unknown Date")
                                                    .font(.system(size: 16.5))
                                                    .foregroundStyle(.black)
                                                    .padding()
                                                    .offset(x: -9)
                                                
                                                Spacer()
                                                
                                                
                                                Image(systemName: "chevron.right")
                                                
                                                
                                            }.frame(width: geo.size.width - 30)
                                        })
                                        .contentShape(Rectangle())
                                        .buttonStyle(PlainButtonStyle())
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                        //Spacer().frame(width: 100, height: 55)
                        
                        Spacer()
                    }.onAppear(perform: {
                        //self.environment.getPostMeasurements()
                        self.environment.getAllSuccessfulMeasurements()
                        self.environment.isShowingTabView = false
                    })
                }
            }
        }
    }
    
//    func getDateString(date: String) -> String? {
//        let components = date.components(separatedBy: " ")
//        guard components.count >= 4 else {return nil}
//        let dayOfWeek = components[0]
//        let day = components[1]
//        let month = components[2]
//        let year = components[3]
//        let time = components[4]
//        return "\(dayOfWeek) \(month) \(day), \(year) \(time)"
//    }
    
    func getDateString(date: String) -> String? {
        print(date)
        let userTimeZone = TimeZone.current
        print(userTimeZone)
        
        var userDateCompnents = DateComponents()
        
        let components = date.components(separatedBy: "-")
        guard components.count >= 3 else {return nil}
        
        let year = components[0]
        userDateCompnents.year = Int(year)
        
        let month = components[1]
        userDateCompnents.month = Int(month)
        
        let dayTime = components[2]
        let dayComponents = dayTime.components(separatedBy: "T")
        
        let day = dayComponents[0]
        let time = dayComponents[1]
        
        userDateCompnents.day = Int(day)
        
        let timeComponents = time.components(separatedBy: ":")
        userDateCompnents.hour = Int(timeComponents[0])
        userDateCompnents.minute = Int(timeComponents[1])
        
        
        var userDate = calender.date(from: userDateCompnents)
        var secondsFromGmt: Int { return TimeZone.current.secondsFromGMT() }
        
        var timeSince1970 = userDate?.timeIntervalSince1970 ?? 0.0
        let realTime = timeSince1970 + Double(secondsFromGmt)
        let realDate = Date(timeIntervalSince1970: realTime)
        
        dateFormatter.dateFormat = "E MMMM d yyyy"
        timeFormatter.dateFormat = "HH:mm a"
        
        
        return "\(dateFormatter.string(from: realDate)) at \(timeFormatter.string(from: realDate))"
    }
    
    func didTapBack() {
        self.viewModel.showPreviousMeasurements = false
    }
    
}


