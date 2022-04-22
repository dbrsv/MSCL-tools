## ---------------------------
##
## Script name: PseudoColor.R
##
## Purpose of script: Generates raster file with pseudo colors of
##                    bottom sediments along the core
##
## Author: PhD Dmitrii Borisov
##
## Date Created: 2022-04-19
##
## Email: borisov.ocean@gmail.com
## 

# Подключение библиотек || LIBRARIES-----------------------------
library(stringi)
library(magrittr)
library(readr)

# Объявление функций || FUNCTIONS-----------------------------
# функция чтения даннных из *.csv файла  (глубина, L*, a*, b*) ||
# READS DATA FROM *.CSV FILE
read_log_files <- function(dat){
  dat <- read_csv(fn, 
                  col_names = T,
                  trim_ws = T,
                  skip = 9,
                  skip_empty_rows = T)
  
  d <- dat[,1][!is.na(dat$`L*`),] %>%
        unique() %>%
        t() %>%
        as.vector()
  
  depth <- as.vector(t(dat[,1]))
        
  L <- dat$`L*`[match(d, depth)]
  a <- dat$`a*`[match(d, depth)]
  b <- dat$`b*`[match(d, depth)]
    
  dLab <- data.frame(d, L, a, b)
  colnames(dLab) <- c("depth", "L", "a", "b")
  dLab
}

# функция конвертации цвета L*a*b* в RGB ||
# L*a*b* TO RGB CONVERSION
col_conv <- function(Lab){
  cols <- Lab %>% 
    convertColor(from = "Lab", to = "sRGB") %>%
    rgb()
}

#функция создания изображения и сохранения его в файл ||
# GENERATES AND SAVES JPEG IMAGE
image_write <- function(depth, colors, filename){
  fname <- filename %>% 
          stri_replace_all_regex(
                  pattern = ".csv",
                  replacement = "",
                  vectorize=F) %>%
          paste("_(", min(depth),"-", max(depth), ").jpg", sep = "", collapse = "")
  print(fname)
  jpeg(fname,
       width = 100,
       height = 1000,
       units = "px",
       pointsize = 12,
       bg = "white",
       quality = 75
       )
  par(mai = c(0, 0, 0, 0))
  image(0:10, depth, 
         matrix(rep(depth, each = 10), 
                nrow = 10), 
         col = colors, 
         xaxt = "n",
         yaxt = "n",
         xlab = "",
         ylab = "")
  
  dev.off()
  }

# Выбор *.csv файлов || CHOOSE *.СSV FILES-----
if (interactive() && .Platform$OS.type == "windows")
  fn <- choose.files(caption = "choose MSCL log-file", 
                     multi = T)

# Цикл для обработки данных из выбранных файлов || DATA PROCESSING -------

for(f in fn){
  dLab <- read_log_files(f)
  cols <- col_conv(dLab[,2:4])
  image_write(as.vector(t(dLab[,1])), cols, f)
}
