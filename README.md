# techchallenge_jingluo


You may no need to install cocoapods, if encounter library error, then try to install podfile.

### Models and API service ###
* Models are automatically generated by #JSONExport#.  

2, #Alamofire# for web service. 

3, Using #ObjectMapper# for mapping JSON to Mappble Model. 


### Architeture ###
1, MVVM + #RxSwift# for Architeture  


### UI ###
1, Weather icons are from #SwiftIcons#.  

2, UI is all created by InterfaceBuilder and AutoLayout.  


### Interactions ###
1, Interface is inspired by iPhone build-in App Weather. 

2, At the top of the screen is showing current weather summary infomations. This part can been tapped, which makes it show current weather info.  

3, Hourly data can be scroll horizontally and can not be tapped.  

4, Daily data can be scroll vertically. Each row can be tapped. When it's tapped, the top summary view will show weather info of the day and changes background color to weather-related color. If you want to show current weather info, just tap on top view.  


### Unit Test ###
1, Use default XCTest framework for webservice call.


### 3rd-party libraries/tool used ###
* RxSwift

2, Alamofire 

3, ObjectMapper

4, SwiftIcons

5, JSONExport  
