# Description
# Using data from the krsp DB, converts a vector of squirrel_ids into the files
# required to make Cervus paternity assignments

# Usage
# cervus_prep(juv_ids)

# Arguments
# juv_ids: a vector of squirrel_ids that can be coerced to type numeric.

# Value
# A list of 2 data.frames: IDs and gtypes. IDs contains the user-supplied
# juv_ids in col1, their dams (if known) in col2, and a list of candidate sires in
# col3. Cervus refers to this as the "offspring" file. gtypes contains the
# genotypes of all squirrels present in IDs.


#############
# libraries #
#############

# Before running load the krsp and lubridate libraries


# library(krsp)
# library(lubridate)


cervus_prep <- function(juv_ids) {
  
  # connect to krspDB; pull gtypes and flastall-------------------------------------------------------
  
  juv_ids <- as.numeric(juv_ids)
  
  con <- krsp_connect(host = "krsp.cepb5cjvqban.us-east-2.rds.amazonaws.com",
                      dbname = "krsp",
                      username = Sys.getenv("krsp_user"),
                      password = Sys.getenv("krsp_password"))
  
  con2 <- krsp_connect(host = "krsp.cepb5cjvqban.us-east-2.rds.amazonaws.com",
                       dbname = "krsp_suppl",
                       username = Sys.getenv("krsp_user"),
                       password = Sys.getenv("krsp_password"))
  
  all_gtypes <- tbl(con2, "genotypes") %>%
    collect() %>%
    filter(!is.na("03a")) %>% # this should be ok since missing data are "0"
    select(c(squirrel_id, "03a":"55b"))
  
  if (all(juv_ids %in% all_gtypes$squirrel_id) == F) {
    warning("one or more juv_ids do not have entries in the krsp genotypes DB")
  }
  
  flastall <- tbl(con, "flastall2") %>%
    collect() %>%
    mutate(dates = ymd(dates),
           datee = ymd(datee),
           bcert = as.factor(bcert),
           byear = byear) %>%
    filter(!is.na(dates),!is.na(datee)) %>%
    select(squirrel_id, sex, dam_id, byear, grid = gr, bcert, f1, f2, byear, dates, datee)
  
  juv_info <- flastall %>% filter(squirrel_id %in% juv_ids)
  
  # create an interval for reproductive viability of candidate sires ---------
  
  # criteria:
  # bcert is binary y/n whether the squirrel's byear is certain
  # when bcert == "Y", siring window starts 1yr after birth (dates)
  # when bcert == "N", siring window starts 8yrs before dates (squirrel lifespan <9yrs)
  # when f2 %in% c(4,5,10,11,12) death is confirmed; siring window ends at datee. Otherwise use today's date
  
  candidads <- flastall %>% filter(sex == "M")
  
  window_start <- as_date(rep(NA, nrow(candidads)))
  window_end <- as_date(rep(NA, nrow(candidads)))
  
  for (i in 1:nrow(candidads)) {
    if (candidads$bcert[i] == "Y") {  # byear is certain
      window_start[i] <- candidads$dates[i] + years(1)
    } else {
      window_start[i] <- candidads$dates[i] - years(8)
    }
  }
  for (i in 1:nrow(candidads)) {
    if (candidads$f2[i] %in% c(4, 5, 10, 11, 12)) { # death is confirmed
      window_end[i] <- candidads$datee[i]
    } else {
      window_end[i] <- today()
    }
  }
  candidads$window_start <- year(window_start)
  candidads$window_end <- year(window_end)
  
  # In rare cases window_start may come after window_end; if bcert == Y & death
  # is confirmed & datee is < 1 year after dates. Can only happen if squirrel
  # does not reach sexual maturity so nbd.
  
  
  # create the cervus IDs (offspring) input file ----------------------------
  
  # this file should have all juvs of interest in col1, known dams in col2, and
  # candidate sires in col3. Avoid having varying #'s of cols by collapsing all
  # sires for each juv into one character string
  
  # byear has to be a specific date to query candidads$sire_window but the day
  # itself isn't as important; using May 1 as an ad hoc birthday
  IDs <- juv_info %>%
    select(squirrel_id, dam_id, byear)
  
  sires <- NULL
  
  # first, save the list of sires to pull genotypes later
  for (i in 1:nrow(IDs)) {
    sires[i] <- candidads %>% 
      filter(window_start < IDs$byear[i],
             window_end > IDs$byear[i],
             squirrel_id %in% all_gtypes$squirrel_id) %>% 
      select(squirrel_id)
  } # note: this filters out potential sires with no genotype info
  
  # next, save the sires as one long character string on each line of IDs
  # (will appear here as "####\t####\t..." but will write as actual tabs)
  IDs$sires <- rep(NA_character_, nrow(IDs))
  
  for (i in 1:nrow(IDs)) {
    IDs$sires[i] <- sires[[i]] %>%
      unlist(use.names = F) %>%
      paste(collapse = "\t")
  }
  
  IDs <- IDs %>% select(juv = squirrel_id, dam = dam_id, sires) %>% as.data.frame()
  #^cervus formatted Names file
  
  # create genotypes file ---------------------------------------------------
  
  # unlist sires into a character vector
  sires <- unlist(sires) %>% unique()
  
  gtypes <- all_gtypes %>%
    filter(squirrel_id %in% c(IDs$juv, IDs$dam, sires),
           !is.na(squirrel_id)) %>%
    distinct() %>% 
    as.data.frame()
  
  return(list(IDs = IDs, gtypes = gtypes))
}


##########################################
## example using 30 random squirrel_ids ##
##########################################
# library (krsp)
# 
# con <- krsp_connect(host = "krsp.cepb5cjvqban.us-east-2.rds.amazonaws.com",
#                     dbname = "krsp",
#                     username = Sys.getenv("krsp_user"),
#                     password = Sys.getenv("krsp_password"))
# 
# con2 <- krsp_connect(host = "krsp.cepb5cjvqban.us-east-2.rds.amazonaws.com",
#                      dbname = "krsp_suppl",
#                      username = Sys.getenv("krsp_user"),
#                      password = Sys.getenv("krsp_password"))
# 
# all_gtypes <- tbl(con2, "genotypes") %>%
#   collect() %>%
#   filter(!is.na("03a")) %>% # this should be ok since missing data are "0"
#   select(c(squirrel_id, "03a":"55b"))
# 
# juv_ids <- flastall %>%
#   filter(squirrel_id %in% all_gtypes$squirrel_id) %>%
#   sample_n(30) %>%
#   select(squirrel_id) %>%
#   unlist()
# 
# cervus_inputs <- cervus_prep(juv_ids = juv_ids)
# cervus_inputs$IDs %>% str()
# 
# write.table(cervus_inputs$IDs, "cervus_prep_ids.txt", sep = "\t", row.names = F, quote = F)
# write.table(cervus_inputs$gtypes, "cervus_prep_gtypes.txt", sep = "\t", row.names = F, quote = F)
