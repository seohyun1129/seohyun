library(rvest)
#kbo타자선수기록
url = "https://www.koreabaseball.com/Record/Player/HitterBasic/Basic1.aspx"
html <- read_html(url)
table <- html %>% html_nodes("table")
td <- table %>% html_nodes("td")
text <- td %>% html_text()
df <- as.data.frame(matrix(text, nrow=30, ncol=16, byrow=TRUE))
data <- cbind(df[1], df[2], df[3],df[4],df[6],df[7],df[9],df[12])
names(data) <- c("순위", "선수명","팀명","타율","타석","타수","안타","홈런")
data
plot(as.numeric(data$타석),as.numeric(data$타율))
cor(as.numeric(data$타석),as.numeric(data$타율))
cor(as.numeric(data$타석),as.numeric(data$홈런))
cor(as.numeric(data$타석),as.numeric(data$안타))
#타석과 안타의 상관관계가 가장 강하다.

#kbo투수선수기록
url2 = "https://www.koreabaseball.com/Record/Player/PitcherBasic/Basic1.aspx"
html2 <- read_html(url2)
table2 <- html2 %>% html_nodes("table")
td2 <- table2 %>% html_nodes("td")
text2 <- td2 %>% html_text()
df2 <- as.data.frame(matrix(text2, nrow=27, ncol=19, byrow=TRUE))
data2 <- cbind(df2[1],df2[2], df2[3],df2[4],df2[5],df2[6],df2[10],df2[14],df2[16])
names(data2) <- c("순위", "선수명","팀명","평균자책점","경기","승리","승률","볼넷","삼진")
data2
plot(as.numeric(data2$평균자책점),as.numeric(data2$승률))
cor(as.numeric(data2$평균자책점),as.numeric(data2$승률))
cor(as.numeric(data2$평균자책점),as.numeric(data2$볼넷))
cor(as.numeric(data2$평균자책점),as.numeric(data2$삼진))
#평균자책점과 승률과의 음의 상관관계가 가장 강하다.