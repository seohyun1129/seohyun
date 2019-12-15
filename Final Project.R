library(RSelenium)
library(rvest)
library(lubridate)
library(ggplot2)

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4446L,
  browserName = "chrome"
)

remDr$open()
remDr$navigate("https://kr.trip.com/flights/")

#����� �Է�
departures <- remDr$findElement(using = "xpath",value='//*[@id="main"]/div/div[2]/form/div/div[1]/ul/li[1]/div[2]/input')
departures$sendKeysToElement(list("��õ"))

#������ �Է�
arrivals <- remDr$findElement(using = "xpath", value='//*[@id="main"]/div/div[2]/form/div/div[1]/ul/li[1]/div[4]/input')
arrivals$sendKeysToElement(list("�ٳ�"))

#�˻� ��ư Ŭ��
search <- remDr$findElement(using="xpath", value='//*[@id="main"]/div/div[2]/form/div/div[1]/div/div/div[2]')
search$clickElement()

#������ ���� ����
folder <- "c:/test"
if(!dir.exists(folder)) dir.create(folder)
setwd(folder)

#�������� ���� ��¥, �ð�
date <- Sys.Date()
h <- hour(Sys.time())
m <- minute(Sys.time())

#�����ȿ� ���� ��¥�� �ð����� ������ ����
now <- paste(date, h, m, sep="-")
now.folder <- paste(folder, now, sep="/")
if(!dir.exists(now.folder)) dir.create(now.folder)
setwd(now.folder)

#html�� �޾ƿ�
source = remDr$getPageSource()[[1]]

#������������ �ٿ���� ������ ���Ϸ� ����
filename = "ticket price.txt"
writeLines(source, filename)
html = read_html(filename, encoding="euc-kr")

#��ü ������
span = html %>% html_nodes("span")

#���� ������ ����
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

#������ �м�
price = gsub(",","",price)
price = as.numeric(price)
summary(price)
hist(price)
boxplot(price, main="boxplot of price")
price = as.data.frame(price)
ggplot(data=price)+
  geom_density(mapping=aes(x=price), adjust=1/2)

#��߽ð� ������ ����
class <- remDr$findElement(using = "class", value='time')
class$getElementText()

remDr$close()