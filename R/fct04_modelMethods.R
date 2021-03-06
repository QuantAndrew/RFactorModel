#' Model methods
#' 
#' Get the objects of \code{RebDates}, \code{TS}, \code{TSF}, \code{TSR}, \code{TSFR}, \code{TSFRM} through a \code{modelPar} object.
#' @rdname ModelMethods
#' @name ModelMethods
#' @aliases Model.RebDates
#' @param modelPar a \bold{modelPar} object
#' @return \code{Model.RebDates} return a \bold{RebDates} object(See detail in \code{\link{getRebDates}}).
#' @author Ruifei.Yin
#' @export
#' @examples
#' modelPar <- modelPar.default()
#' 
#' # -- get the RebDates object
#' RebDates <- Model.RebDates(modelPar)
Model.RebDates <- function(modelPar){  
  begT <- modelPar$time$begT
  endT <- modelPar$time$endT
  rebFreq <- modelPar$time$rebFreq
  shiftby <- modelPar$time$shiftby
  dates <- modelPar$time$dates
  RebDates <- getRebDates(begT=begT,endT=endT,rebFreq=rebFreq,shiftby=shiftby,dates=dates)
  attr(RebDates,"MP") <- modelPar
  return(RebDates)
}




#' @return \code{Model.TS} return a \bold{TS} object(See detail in \code{\link{getTS}}).
#' @rdname ModelMethods
#' @export
#' @examples 
#' # -- get the TS object
#' TS <- Model.TS(modelPar)
Model.TS <- function(modelPar){  
  # ---- get RebDates
  RebDates <- Model.RebDates(modelPar)  
  # ---- build the TS
  indexID <- modelPar$univ$indexID
  stocks <- modelPar$univ$stocks
  rm <- modelPar$univ$rm
  TS <- getTS(RebDates,indexID=indexID,stocks=stocks,rm=rm)
  attr(TS,"MP") <- modelPar
  return(TS)
}





#' @return \code{Model.TSR} return a \bold{TSR} object(See detail in \code{\link{getTSR}})
#' @rdname ModelMethods
#' @export
#' @examples
#' # -- get the TSR object
#' TSR <- Model.TSR(modelPar)
Model.TSR <- function(modelPar){ 
  # ---- get the TS
  TS <- Model.TS(modelPar)  
  # ---- get the TSR 
  dure <- modelPar$time$dure
  TSR <- getTSR(TS=TS, dure=dure) 
  attr(TSR,"MP") <- modelPar
  return(TSR)
}





#' @return \code{Model.TSF} get a \bold{TSF} object by modelPar directly.(See detail in \code{\link{getTSF}})
#' @rdname ModelMethods
#' @export
#' @examples
#' # -- get the TSF object
#' TSF <- Model.TSF(modelPar)
Model.TSF <- function(modelPar){ 
  TS <- Model.TS(modelPar)   
  TSF <-  Model.TSF_byTS(modelPar,TS) 
  attr(TSF,"MP") <- modelPar
  return(TSF)
}

#' @param TS a \bold{TS} or \bold{TSR} object
#' @return \code{Model.TSF_byTS} get the \bold{TSF}(or \code{TSFR}) object by modelPar and \code{TS}(or \code{TSR}).
#' @note Function \code{Model.TSF_byTS} is offen used when getting \code{TS} is time costly, or when test different factor related parametres frequently. Note that if parametre \code{TS} is a \code{TSR} object, then \code{Model.TSF_byTS} return a \code{TSFR} object, else return a \code{TSF} object.
#' @rdname ModelMethods
#' @export
#' @examples
#' # -- get the TSF object by TS
#' TS <- Model.TS(modelPar)
#' TSF <- Model.TSF_byTS(modelPar,TS)
#' # -- get the TSFR object by TSR
#' TSR <- Model.TSR(modelPar)
#' TSFR <- Model.TSF_byTS(modelPar,TSR)
Model.TSF_byTS <- function(modelPar,TS){ 
  factorFun <- modelPar$factor$factorFun
  factorPar <- modelPar$factor$factorPar
  factorDir <- modelPar$factor$factorDir
  factorRefine <- modelPar$factor$factorRefine 
  TSF <- getTSF(TS,factorFun=factorFun,factorPar=factorPar,factorDir=factorDir,factorRefine=factorRefine)  
  attr(TSF,"MP") <- modelPar
  return(TSF)
}




#' @return \code{Model.TSFR} return a \bold{TSFR} object(See detail in \code{\link{getTSR}} and \code{\link{getTSF}})
#' @rdname ModelMethods
#' @export
#' @examples
#' # -- get the TSFR object
#' TSFR <- Model.TSFR(modelPar)
Model.TSFR <- function(modelPar){
  # ---- get the TSF
  TSF <- Model.TSF(modelPar)
  # ---- get the TSFR
  TSFR <- getTSR(TS=TSF)
  attr(TSFR,"MP") <- modelPar
  return(TSFR)
}

#' @param MPs 
#' @param nm a character string, specificating the names of the returned list 
#' @return \code{Model.TSFs} return a named list of \bold{TSF} object, whose elements is coresponding to the elements of \bold{MPs}
#' @rdname ModelMethods
#' @export
#' @examples
#' # -- get the TSFs list
#' factorIDs <- c("F000001","F000002","F000005")
#' FactorLists <- buildFactorLists_lcfs(factorIDs)
#' MPs <- getMPs_FactorLists(FactorLists, modelPar.default())
#' TSFs <- Model.TSFs(MPs)
Model.TSFs <- function(MPs, nm = names(MPs)){  
  re <- plyr::llply(MPs, Model.TSF, .progress="text")
  names(re) <- nm
  return(re)
}

#' @return \code{Model.TSFRs} return a named list of \bold{TSFR} object, whose elements is coresponding to the elements of \bold{MPs}
#' @rdname ModelMethods
#' @export
#' @examples
#' # -- get the TSFRs list
#' TSFRs <- Model.TSFRs(MPs)
Model.TSFRs <- function(MPs, nm = names(MPs)){
  re <- plyr::llply(MPs, Model.TSFR, .progress="text")
  names(re) <- nm
  return(re)
}

#' @return \code{Model.TSFs_byTS} return a named list of \bold{TSF}(or \code{TSFR}) object, whose elements is coresponding to the elements of \bold{MPs}
#' @note Function \code{Model.TSFs_byTS} is offen used when getting \code{TS} is time costly, or when test different factor related parametres frequently. Note that if parametre \code{TS} is a \code{TSR} object, then \code{Model.TSFs_byTS} return a list of \code{TSFR} object, else return a list of \code{TSF} object.
#' @rdname ModelMethods
#' @export
#' @examples
#' # -- get the list by TS and TSR
#' TSFs <- Model.TSFs_byTS(MPs, TS)
#' TSFRs <- Model.TSFs_byTS(MPs, TSR)
Model.TSFs_byTS <- function(MPs, TS, nm = names(MPs)){
  re <- plyr::llply(MPs, Model.TSF_byTS, TS=TS, .progress="text")
  names(re) <- nm
  return(re)
}









