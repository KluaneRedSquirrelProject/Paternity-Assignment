# Description
# Converts vial IDs into squirrel_ids. Takes an input vector of vial IDs and 
# searches the krsp DB for their associated squirrel_id's

# Arguments
# vial_ids: a character vector of vial IDs that appear in the dna1 or dna2
# columns of either the trapping or juvenile tables

# Value: a vector of squirrel IDs. Note that sapply() is used to simplify the
# output so if the result is a list, check whether any vial_id is associated
# with multiple squirrel_ids

library(krsp)


squirrel_id_finder <- function(vial_id) {
  
  con <- krsp_connect(host = "krsp.cepb5cjvqban.us-east-2.rds.amazonaws.com",
                      dbname = "krsp",
                      username = Sys.getenv("krsp_user"),
                      password = Sys.getenv("krsp_password"))
  
  flastall <- tbl(con, "flastall2") %>%
    collect() %>%
    select(squirrel_id)
  
  juvenile <- tbl(con, "juvenile") %>%
    filter(!is.na(dna1) & !is.na(dna2)) %>% 
    select(squirrel_id, j_dna1 = dna1, j_dna2 = dna2) %>%
    collect()
  
  trapping <- tbl(con, "trapping") %>%
    filter(!is.na(dna1) & !is.na(dna2)) %>%
    select(squirrel_id, trap_dna1 = dna1, trap_dna2 = dna2) %>%
    collect()
  
  # make a phonebook of squirrel_ids and their vial_ids
  id_lookup <- flastall %>%
    left_join(trapping, by = "squirrel_id") %>%
    left_join(juvenile, by = "squirrel_id") %>%
    select(squirrel_id, j_dna1, j_dna2, trap_dna1, trap_dna2) %>%
    as.data.frame()
  
  # convert vial_ids to squirrel_ids by sapplying over sid_lookup()
  sid_lookup <- function(vial_id){
    
    if (vial_id %in% id_lookup$trap_dna1) {
      sid <- id_lookup[which(id_lookup$trap_dna1 == vial_id),1]
      
    } else if (vial_id %in% id_lookup$trap_dna2) {
      sid <- id_lookup[which(id_lookup$trap_dna2 == vial_id),1]
      
    } else if (vial_id %in% id_lookup$j_dna1) {
      sid <- id_lookup[which(id_lookup$j_dna1 == vial_id),1]
      
    } else if (vial_id %in% id_lookup$j_dna2) {
      sid <- id_lookup[which(id_lookup$j_dna2 == vial_id),1]
      
    } else {
      sid <- NA
    }
    print(sid)
  }
  
  sapply(vial_id, FUN = sid_lookup, simplify = T)
}

#############
## example ##
#############
# con <- krsp_connect(host = "krsp.cepb5cjvqban.us-east-2.rds.amazonaws.com",
#                     dbname = "krsp",
#                     username = Sys.getenv("krsp_user"),
#                     password = Sys.getenv("krsp_password"))
# 
# flastall <- tbl(con, "flastall2") %>%
#   collect() %>%
#   select(squirrel_id)
# 
# juvenile <- tbl(con, "juvenile") %>%
#   filter(!is.na(dna1) & !is.na(dna2)) %>% 
#   select(squirrel_id, j_dna1 = dna1, j_dna2 = dna2) %>%
#   collect()
# 
# trapping <- tbl(con, "trapping") %>%
#   filter(!is.na(dna1) & !is.na(dna2)) %>%
#   select(squirrel_id, trap_dna1 = dna1, trap_dna2 = dna2) %>%
#   collect()
# 
# set.seed(27)
# vial_id <- c(sample(juvenile$j_dna1, 20), sample(juvenile$j_dna2, 20), sample(trapping$trap_dna1, 20), sample(trapping$trap_dna2, 20))
# vial_id <- vial_id[!is.na(vial_id)]
# vial_id <- vial_id[vial_id!=""]
# vial_id
# 
# 
#  out <- squirrel_id_finder(vial_id)
#  out
 