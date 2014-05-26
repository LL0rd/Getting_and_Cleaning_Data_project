# load the reshape Lib
require(reshape2)

# Reading the Data into Temp-Tables 

datax1 <- read.table("train/X_train.txt")
datax2 <- read.table("test/X_test.txt")
datay1 <- read.table("train/y_train.txt")
datay2 <- read.table("test/y_test.txt")
datas1 <- read.table("train/subject_train.txt")
datas2 <- read.table("test/subject_test.txt")

# Merge Temp Tables
dataX <- rbind(datax1, datax2)
dataY <- rbind(datay1, datay2)
dataS <- rbind(datas1, datas2)

# getting features
features <- read.table("features.txt")[,"V2"]
colnames(dataX) <- features
colnames(dataY) <- "activity_id"
colnames(dataS) <- "subject"

#Getting the Measurements
#good_features <- grep("-mean\\(\\)|-std\\(\\)", feature_list[, 2])
means <- grep("-mean\\(\\)", features, value=TRUE)
stds <- grep("-std\\(\\)", features, value=TRUE)
good_features <- c(means, stds)
dataX2 <- dataX[, good_features]

#names(dataX) <- feature_list[good_features, 2]
#names(dataX) <- gsub("\\(|\\)", "", names(dataX))
#names(dataX) <- tolower(names(dataX)) 

#getting activities

act <- read.table("activity_labels.txt")
colnames(act) <- c("activity_id", "activity")
#act[, 2] = gsub("_", "", tolower(as.character(act[, 2])))
dataY2 <- merge(dataY, act)

# Data Output
#dataY[,1] = act[dataY[,1], 2]
data1 <- cbind(dataX2, dataY2["activity"])
write.csv(data1, "measurements_mean_std.txt")

# merge subjects
data2 <- cbind(data1, dataS)
data2_melt <- melt(data2, id=c("subject", "activity"))


data3 <- dcast(data2_melt, act + dataS ~ variable, mean)
write.csv(data3, "activity_subject_means.txt")
