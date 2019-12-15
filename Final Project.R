library(RSelenium)
library(rvest)
library(lubridate)

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4446L,
  browserName = "chrome"
)

remDr$open()
remDr$navigate("https://kr.trip.com/flights/")

#출발지 입력
departures <- remDr$findElement(using = "xpath",value='//*[@id="main"]/div/div[2]/form/div/div[1]/ul/li[1]/div[2]/input')
departures$sendKeysToElement(list("인천"))

#도착지 입력
arrivals <- remDr$findElement(using = "xpath", value='//*[@id="main"]/div/div[2]/form/div/div[1]/ul/li[1]/div[4]/input')
arrivals$sendKeysToElement(list("다낭"))

#검색 버튼 클릭
search <- remDr$findElement(using="xpath", value='//*[@id="main"]/div/div[2]/form/div/div[1]/div/div/div[2]')
search$clickElement()

#저장할 폴더 생성
folder <- "c:/test"
if(!dir.exists(folder)) dir.create(folder)
setwd(folder)

#웹페이지 접속 날짜, 시간
date <- Sys.Date()
h <- hour(Sys.time())
m <- minute(Sys.time())

#폴더안에 위의 날짜와 시간으로 폴더를 생성
now <- paste(date, h, m, sep="-")
now.folder <- paste(folder, now, sep="/")
if(!dir.exists(now.folder)) dir.create(now.folder)
setwd(now.folder)

#html을 받아옴
source = remDr$getPageSource()[[1]]

#웹페이지에서 다운받은 페이지 파일로 저장
filename = "ticket price.txt"
writeLines(source, filename)
html = read_html(filename, encoding="euc-kr")

#전체 데이터
span = html %>% html_nodes("span")

#가격 데이터 추출
em = span %>% html_nodes("em")
n = gsub("(\r)(\n)(\t)","",em)
n = strsplit(n,">")
p = list(length=36)
for(i in 1:36){
  p[i] = strsplit(n[[i]][2], "<")
}
price = list(length=36)
for(i in 1:36){
  price[i] = p[[i]][1]
}

#데이터 분석
price = gsub(",","",price)
price = as.numeric(price)
summary(price)
hist(price)
boxplot(price, main="boxplot of price")
barplot(price, main="barplot of price")

#출발시각 데이터 추출
class <- remDr$findElement(using = "class", value='time')
class$getElementText()

remDr$close()
