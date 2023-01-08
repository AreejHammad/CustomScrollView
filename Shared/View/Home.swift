//
//  Home.swift
//  CustomScrollView (iOS)
//
//  Created by Balaji on 18/03/21.
//

import SwiftUI

struct Home: View {
    
    // Search Text...
    @State var searchQuery = ""
    
    // Offsets...
    @State var offset: CGFloat = 0
    // Start Offset...
    @State var startOffset: CGFloat = 0
    
    // to move title to center were getting the title Width...
    @State var titleOffset: CGFloat = 0
    
    // to get the scrollview padded from the top were going to get the height of the title Bar...
    @State var titleBarHeight: CGFloat = 0
    
    // to adopt for dark mode...
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
        ZStack(alignment: .top){
            
            // moving the search bar to the top if user starts typing...
            
            VStack{
                
                if searchQuery == ""{
                    
                    HStack{
                        
                
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Image(systemName: "doc.viewfinder")
                                .font(.title2)
                                .foregroundColor(.primary)
                        })
                    }
                    .padding()
                    
                    HStack{
                        
                        (
                        
                            Text("My ")
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            +
                            
                            Text("Cards")
                                .foregroundColor(.gray)
                        )
                        .font(.largeTitle)
                        .overlay(
                        
                            GeometryReader{reader -> Color in
                                
                                let width = reader.frame(in: .global).maxX
                                
                                DispatchQueue.main.async {
                                    // storing...
                                    if titleOffset == 0{
                                        titleOffset = width
                                    }
                                }
                                
                                return Color.clear
                            }
                            .frame(width: 0, height: 0)
                        )
                        .padding()
                        // getting offset and moving the view....
                        // scaling...
                        .scaleEffect(getScale())
                        .offset(getOffset())
                        
                        Spacer()
                    }
                }
                
                VStack{
                    
                    // Search Bar...
                    
                    HStack(spacing: 15){
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 23, weight: .bold))
                            .foregroundColor(.gray)
                        
                        TextField("Seach", text: $searchQuery)
                    }
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(8)
                    .padding()
                    
                    if searchQuery == ""{
                        
                        // Divider Line...
                        HStack{
                            
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.6))
                                .frame(height: 0.5)
                        }
                        .padding()
                    }
                }
                .offset(y: offset > 0 && searchQuery == "" ? (offset <= 95 ? -offset : -95) : 0)
            }
            .zIndex(1)
            // padding bottom...
            // to decrease height of the view...
            .padding(.bottom,searchQuery == "" ? getOffset().height : 0)
            .background(
            
                ZStack{
                    
                    let color = scheme == .dark ? Color.black : Color.white
                    
                    LinearGradient(gradient: .init(colors: [color,color,color,color,color.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea()
            )
            .overlay(
            
                GeometryReader{reader -> Color in
                    
                    let height = reader.frame(in: .global).maxY
                    
                    DispatchQueue.main.async {
                        if titleBarHeight == 0{
                            titleBarHeight = height - (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                        }
                    }
                    
                    return Color.clear
                }
            )
            // animating only if user starts typing...
            .animation(.easeInOut,value: searchQuery != "")
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                VStack(spacing: 15){
                    
                    // dont use this filter method...
                    // its just for tutorial...
                    
                    ForEach(searchQuery == "" ? friends : friends.filter{$0.name.lowercased().contains(searchQuery.lowercased())}){friend in
                        
                        // Friend Card Row View.....
                        FriendRowView(friend: friend)
                    }
                }
                .padding(.top,10)
                .padding(.top,searchQuery == "" ? titleBarHeight : 90)
                // Getting Offset by using geometry Reader...
                .overlay(
                
                    GeometryReader{proxy -> Color in
                        
                        let minY = proxy.frame(in: .global).minY
                        
                        DispatchQueue.main.async {
                            
                            // to get original offset
                            // ie from 0
                            // just minus start offset...
                            if startOffset == 0{
                                startOffset = minY
                            }
                            
                            offset = startOffset - minY
                            print(offset)
                        }
                        
                        return Color.clear
                    }
                    .frame(width: 0, height: 0)
                    
                    ,alignment: .top
                )
            })
        }
    }
    
    func getOffset()->CGSize{
        
        var size: CGSize = .zero
        
        let screenWidth = UIScreen.main.bounds.width / 2
        // since width is slow moving were multiplying with 1.5...
        size.width = offset > 0 ? (offset * 1.5 <= (screenWidth - titleOffset) ? offset * 1.5 : (screenWidth - titleOffset)) : 0
        size.height = offset > 0 ? (offset <= 75 ? -offset : -75) : 0
        
        return size
    }
    
    // little bit shrinking title when scrolling...
    
    func getScale()->CGFloat{

        if offset > 0{
            let screenWidth = UIScreen.main.bounds.width
            
            let progress = 1 - (getOffset().width / screenWidth)
            
            return progress >= 0.9 ? progress : 0.9
        }
        else{
            return 1
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}
