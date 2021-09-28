#Ref: https://www.youtube.com/watch?v=sSnbmbRmtSA
pacman::p_load(dplyr, data.table, stringr, tidyr)

data <- read.csv(
		'data_cleaning_challenge.csv',
		stringsAsFactors = FALSE,
		header           = TRUE
)

# Return row index location of the unwanted subHeaders ----
indexHeaders <- which(data$Row.Type == 'Row Type')

#Remove empty cols ----
rmHeaders    <- data[- indexHeaders, - c(10, 11)] %>% tibble()

# Remove empty rows ----
rmEmptyRows  <- rmHeaders[!apply(rmHeaders == "", 1, all),]

# Return row index location persona info [first name, last name, date],  ----
indexPerson <- which(
		str_detect(
			rmEmptyRows$Row.Type,
			'first name'
		)
)

# Create new empty cols for persona info ----
data <- rmEmptyRows %>%
		mutate(
			FirstName = NA,
			LastName  = NA,
			Date      = NA
		)

# inject persona info to newly created cols ----
data[indexPerson, "FirstName"] <- data[indexPerson, 1]
data[indexPerson, "LastName"]  <- data[indexPerson, 2]
data[indexPerson, "Date"]      <- data[indexPerson, 3]

data <- data %>%
	tidyr::fill(			
		FirstName:Date,
		.direction = 'down'
	)

# Returns relevent persona info ----
data$FirstName <- stringr::str_remove_all(data$FirstName, pattern = 'first name: ')
data$LastName  <- stringr::str_remove_all(data$LastName, pattern = 'last name: ')
data$Date      <- stringr::str_remove_all(data$Date, pattern = 'date: ')

cleaned <- data[- indexPerson,] %>%
		dplyr::relocate(
			FirstName,
			LastName,
			Date
		)
