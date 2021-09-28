#Ref: https://www.youtube.com/watch?v=sSnbmbRmtSA
pacman::p_load(dplyr, data.table, stringr, tidyr)

data <- read.csv(
		'../data_cleaning_challenge.csv',
		stringsAsFactors = FALSE,
		header           = TRUE
)

indexHeaders <- which(data$Row.Type == 'Row Type')
rmHeaders    <- data[- indexHeaders, - c(10, 11)] %>% tibble()
rmEmptyRows  <- rmHeaders[!apply(rmHeaders == "", 1, all),]

# Return index location of the unwanted subHeaders [first name, last name, date]
indexPerson <- which(
		str_detect(
			rmEmptyRows$Row.Type,
			'first name'
		)
)

data <- rmEmptyRows %>%
		mutate(
			FirstName = NA,
			LastName  = NA,
			Date      = NA
		)

data[indexPerson, "FirstName"] <- data[indexPerson, 1]
data[indexPerson, "LastName"]  <- data[indexPerson, 2]
data[indexPerson, "Date"]      <- data[indexPerson, 3]

data <- data %>%
	tidyr::fill(
		FirstName:date,	
		.direction = 'down'
	)

data$FirstName <- stringr::str_remove_all(data$FirstName, pattern = 'first name: ')
data$LastName  <- stringr::str_remove_all(data$LastName, pattern = 'last name: ')
data$date      <- stringr::str_remove_all(data$date, pattern = 'Date: ')

cleaned <- data[- indexPerson,] %>%
		dplyr::relocate(
			FirstName,
			LastName,
			Date
		)
