TOP = ../..

include $(TOP)/configure/CONFIG
include $(TOP)/configure/RELEASE

PROD_IOC = schottMCLS

# Note: DBD file is manually expanded and installed to ../../../dbd/schottMCLS.dbd
# to include all necessary record types from base, asyn, stream, and calc

# DBD includes
DBD += schottMCLS.dbd
schottMCLS_DBD += base.dbd
schottMCLS_DBD += devSoft.dbd
schottMCLS_DBD += asyn.dbd
schottMCLS_DBD += drvAsynSerialPort.dbd
schottMCLS_DBD += asynRecord.dbd
schottMCLS_DBD += calc.dbd
schottMCLS_DBD += stream.dbd

# Source files
schottMCLS_SRCS += schottMCLS_registerRecordDeviceDriver.cpp
schottMCLS_SRCS += main.cpp

# Link with required libraries
schottMCLS_LIBS += stream asyn calc
schottMCLS_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(EPICS_BASE)/configure/RULES
include $(EPICS_BASE)/configure/RULES.ioc
