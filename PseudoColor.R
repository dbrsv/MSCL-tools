# ����������� ��������� || LIBRARIES-----------------------------
library(stringi)
library(magrittr)
library(readr)

# ���������� ������� || FUNCTIONS-----------------------------
# ������� ������ ������� �� *.csv �����  (�������, L*, a*, b*) ||
# READS DATA FROM *.CSV FILE
read_log_files <- function(dat){
  dat <- read_csv(fn, 
                  col_names = T,
                  trim_ws = T,
