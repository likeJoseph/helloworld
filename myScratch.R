#load tidyverse
library(tidyverse) # it includes tidyr, dplyr, and ggplot2
# tidyr : spread, gather
# dplyr : join, select, rename,
#         arrange - sort a variable in descending order
#         group_by, filter, 
#         mutate - creates new variables 
#         summarize - reduces multiple values to a single value
#         pipe operator - %>%

#load our data sets
commute_data_raw <- read.csv("data/commute_data.csv")
hr_performance_data_raw <- read.csv("data/hr_employees_performance_data.csv")
personal_data_raw <- read.csv("data/personal_data.csv", stringsAsFactors = FALSE)
rnd_performance_data_raw <- read.csv("data/research_and_development_employees_performance_data.csv")
sales_performance_data_raw <- read.csv("data/sales_employees_performance_data.csv")

#examine our data
str(commute_data_raw)
str(hr_performance_data_raw)
str(personal_data_raw)
str(rnd_performance_data_raw)
str(sales_performance_data_raw)

View(commute_data_raw)

# spread is like dcast in data.table
personal_data <- spread(data = personal_data_raw, key = Variable, value = Value)

# gather is like melt in data.table
a <- gather(data = personal_data, 
            key = Variable, value =Value,
            Age:RelationshipSatisfaction)

# ----

personal_data_raw %>% spread(key = Variable, value = Value) %>% View

personal_data %>% gather(key = Variable, value = Value,
                         Age:RelationshipSatisfaction)

k <- personal_data_raw %>% spread(key = Variable, value = Value) %>% 
  mutate(Age = as.integer(Age),
         Attrition = as.factor(Attrition)) %>%
  select(-Gender)

# install.packages('corrgram')
library(corrgram)  


# Join --------------------------------------------------------------------


 
hr_performance_data <- select(hr_performance_data_raw, -X)
rnd_performance_data <- select(rnd_performance_data_raw, -X)
sales_performance_data <- select(sales_performance_data_raw, -X)
commute_data <- select(commute_data_raw, -X)

hr_performance_data$Department <- "HR"
rnd_performance_data <- mutate(rnd_performance_data,
                               Department = "Research and Development")
sales_performance_data <- sales_performance_data %>%
  mutate(Department = "Sales")

performance_data <- rbind(hr_performance_data, rnd_performance_data,
                          sales_performance_data)

performance_data <- mutate(performance_data, 
                           Department = as.factor(Department))

employee_data <- performance_data %>%
  left_join(commute_data, by = "EmployeeNumber") %>%
  inner_join(personal_data, by = "EmployeeNumber")


rates <- employee_data %>%
  select(DailyRate, HourlyRate, MonthlyRate, MonthlyIncome)

corrgram::corrgram(rates)
corrgram(rates, upper.panel = panel.conf, lower.panel = panel.pts)


# Tables and Graphs -------------------------------------------------------


employee_data %>% 
  select(Gender, Attrition) %>% 
  group_by(Gender, Attrition) %>% 
  summarise(Count = n()) %>%
  spread(key = Attrition, value = Count) %>%
  mutate(PercentAttrition = Yes/(Yes + No))

# cf
library(data.table)
dt_x <- data.table(employee_data)
dt_x[,.N,by=.(Gender,Attrition)] %>% 
  dcast(Gender~Attrition,value.var="N") %>%
  mutate(PercentAttrition = Yes/(Yes + No))

#attrition by gender
a1 <- employee_data %>% 
  select(Gender, Attrition) %>% 
  group_by(Gender, Attrition) %>% 
  summarise(Count = n()) %>%
  spread(key = Attrition, value = Count) %>%
  mutate(PercentAttrition = Yes/(Yes + No))
a1

#attrition by gender by department
a2 <- employee_data %>% 
  select(Gender, Attrition, Department) %>% 
  group_by(Department, Gender, Attrition) %>% 
  summarise(Count = n()) %>%
  spread(key = Attrition, value = Count) %>%
  mutate(PercentAttrition = Yes/(Yes + No))
a2


over_forty <- filter(employee_data, Age > 40)

a3 <- over_forty %>% 
  select(Gender, Attrition, Department) %>% 
  group_by(Department, Gender, Attrition) %>% 
  summarise(Count = n()) %>%
  spread(key = Attrition, value = Count) %>%
  mutate(PercentAttrition = Yes/(Yes + No))
a3

dt_x[Age > 40 ]

a4 <- employee_data %>%
  select(Attrition, DistanceFromHome) %>%
  group_by(Attrition) %>%
  summarise(AvgDist = mean(DistanceFromHome),
            StdevDist = sd(DistanceFromHome))

a4

write.csv(x = a4, "commute_attrition.csv", row.names=FALSE)


# ggplot2 -----------------------------------------------------------------
library(ggthemes)

p1 <- ggplot(data = employee_data, 
             aes(x = Attrition, y = HourlyRate)) +
  geom_boxplot()
p1


p2 <- ggplot(data = employee_data, 
             aes(x = Attrition, y = HourlyRate,
                 fill = Department)) +
  geom_boxplot()
p2

p3 <- ggplot(data = employee_data, 
             aes(x = HourlyRate, fill = Attrition)) +
  geom_density(alpha = 0.4)
p3 + theme_light()


p4 <- ggplot(data = employee_data, 
             aes(x = HourlyRate, fill = Attrition)) +
  geom_histogram(alpha = 0.4) +
  facet_wrap(~Department, ncol =1) +
  scale_fill_fivethirtyeight()
p4



p5 <- ggplot(data = employee_data %>% mutate(Age = as.numeric(Age)), 
             aes(x = Age,
                 y = YearsAtCompany, color = Attrition)) +
  geom_point() +
  geom_smooth()
p5


p6 <- ggplot(data = employee_data %>% mutate(Age = as.numeric(Age)), 
             aes(x = Age,
                 y = YearsAtCompany)) +
  geom_point(aes(color = Attrition)) +
  geom_smooth(se = 0) +
  scale_color_fivethirtyeight()
p6 + theme_classic()

p7 <- ggplot(data = employee_data, 
             aes(x = Attrition, fill = as.factor(PerformanceRating))) +
  geom_bar(position = "dodge") +
  scale_fill_fivethirtyeight()
p7 + theme_classic()



# machine learning --------------------------------------------------------

# install.packages('party')
# install.packages('caret')


# Model1 ------------------------------------------------------------------

dataSpliter <- function(employee_data, p = 0.7){
  set.seed(10)
  num_obs <- dim(employee_data)[1]
  draw <- sample(1:num_obs, replace = FALSE)
  draw_split <- floor(num_obs*p)
  train <- employee_data[draw[1:draw_split],]
  test <- employee_data[draw[(draw_split+1):num_obs], ]
  
  result <- list(train = train, test = test)
  return(result)
}

employee_allset <- dataSpliter(employee_data)
employee_trainset <- employee_allset$train
employee_testset <- employee_allset$test


library(party)
library(caret)

train_ctree <- ctree(data = employee_trainset,
                     formula = Attrition ~ BusinessTravel +
                       DailyRate +
                       EnvironmentSatisfaction +
                       JobInvolvement)


employee_trainset[, c("Attrition", "BusinessTravel", "DailyRate",
                      "EnvironmentSatisfaction", "JobInvolvement")] %>% str()


train_ctree <- employee_trainset %>%
  mutate(Attrition = as.factor(Attrition),
         BusinessTravel = as.factor(BusinessTravel)) %>%
  ctree(formula = Attrition ~
          DailyRate +
          EnvironmentSatisfaction +
          JobInvolvement)

plot(train_ctree)

predict_ctree <- predict(train_ctree, employee_testset)

confusionMatrix(predict_ctree, 
                as.factor(employee_testset$Attrition))



# Model2 -----------------------------------------------------------
employee_data <- as.data.frame(unclass(employee_data),
                               stringsAsFactors = TRUE)

employee_allset <- dataSpliter(employee_data)
employee_trainset <- employee_allset$train
employee_testset <- employee_allset$test


train_ctree <- ctree(employee_trainset, formula = Attrition ~.)

plot(train_ctree)

predict_ctree <- predict(train_ctree, employee_testset)

confusionMatrix(predict_ctree, 
                employee_testset$Attrition)





# Model 3 -----------------------------------------------------------------

library(randomForest)

rand_forest <- randomForest(data = employee_trainset,
                            Attrition ~ .,
                            importance = TRUE)

predict_forest <- predict(rand_forest, employee_testset)

confusionMatrix(predict_forest, 
                employee_testset$Attrition,
                positive = "Yes")

importance(rand_forest)

importance(rand_forest)[order(importance(rand_forest)[,3],
                              decreasing=TRUE), ]

p1 <- ggplot(data = employee_data) +
  geom_bar(aes(x = OverTime, fill = Attrition), 
           position ="fill") +
  ggtitle("Percentage Attrition by Overtime") +
  scale_fill_colorblind()

p1


library(plotly)
library(htmlwidgets)
dp1 <- ggplotly(p1)
saveWidget(dp1, file = "attrition_vs_overtime.html")

pdf("attrition_vs_overtime.pdf")
p1
dev.off()


p2 <- ggplot(data = employee_data) +
  geom_bar(aes(x = OverTime, fill = Attrition), 
           position ="fill") +
  ggtitle("Percentage Attrition by Stock Option Level") +
  scale_fill_colorblind()

p2



employees_current <- employee_data %>%
  filter(Attrition == "No")

current_prediction_ctree <- predict(train_ctree, employees_current)
employees_current$PredictedAttrition <- current_prediction_ctree
likely_to_leave_list1 <- employees_current %>%
  filter(PredictedAttrition == "Yes")

current_prediction_forest <- predict(rand_forest,
                                     employees_current)
employees_current$PredictedAttrition2 <- current_prediction_forest
likely_to_leave_list2 <- employees_current %>%
  filter(PredictedAttrition2 == "Yes")

write.csv(x = likely_to_leave_list1, "ctree_model_likely_to_leave.csv",
          row.names = FALSE)
