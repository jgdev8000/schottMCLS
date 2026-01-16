#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "epicsExit.h"
#include "epicsThread.h"
#include "iocsh.h"
#include "iocshRegisterCommon.h"

int main(int argc, char *argv[])
{
    // Register common iocsh commands
    iocshRegisterCommon();

    if(argc==2) {
        // Load and execute the startup script, then continue to interactive shell
        iocsh(argv[1]);
        // Fall through to interactive shell mode below
    }

    // Interactive shell mode (either standalone or after script)
    iocsh(NULL);
    epicsExit(0);
    return(0);
}
