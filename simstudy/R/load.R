if(file.exists("main.R")) {
  for(file in list.files(recursive = T, pattern = ".R")) {
    if( file != "main.R" && file != "load.R") {
      print(paste("loading", file))
      source(file) 
    }
  }
}