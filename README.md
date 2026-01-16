# Schott MC-LS IOC (EPICS Input/Output Controller)

This IOC provides EPICS control of a Schott MC-LS LED illuminator/controller via USB serial connection.

## Hardware Connection

The Schott MC-LS device uses a Cypress USB chip (ID: `04b4:f232`) that presents itself as a serial port:
- Linux: `/dev/ttyUSB0`
- Windows: `COM3` (or similar, check Device Manager)
- macOS: `/dev/tty.usbserial-XXXXX`

To verify the device is connected:
```bash
lsusb | grep Cypress
ls -la /dev/ttyUSB0
```

## Quick Start - Running the IOC

The easiest way to run the IOC is using the provided startup script:

```bash
/opt/iocs/schottMCLS/iocBoot/iocSchottMCLS/runIOC.sh
```

This will start the IOC and display available commands.

## Building a Custom IOC Executable (Optional)

To build your own compiled IOC executable with custom features:

```bash
cd /opt/iocs/schottMCLS
make clean
make
```

The compiled executable will be: `schottMCLSApp/src/O.linux-x86_64/schottMCLS`

Run with:
```bash
cd /opt/iocs/schottMCLS/iocBoot/iocSchottMCLS
/opt/iocs/schottMCLS/schottMCLSApp/src/O.linux-x86_64/schottMCLS st.cmd
```

### Build Requirements
- EPICS Base 7.0.5 or later
- asyn-R4-42 (in synApps)
- StreamDevice-2-8-22 (in synApps)
- Build system should automatically find these through RELEASE file

## EPICS PV Records

After startup, the following Process Variables are available:

### Brightness Control
- **MCLS:LED:Intensity** (write-only, ao record)
  - Range: 0-255
  - 0 = off, 255 = maximum brightness
  - Sends command: `&I##` (## is hex value)

- **MCLS:LED:Intensity_RBV** (read-only, ai record)
  - Reads back current brightness level
  - Scans every 10 seconds
  - Command: `&I?`

### LED Control
- **MCLS:LED:LEDEnable** (bo record)
  - Enables the LED
  - Sends command: `&L1`

- **MCLS:LED:LEDDisable** (bo record)
  - Disables the LED
  - Sends command: `&L0`

## Usage Examples

### In an IOC shell:
```
epics> caput MCLS:LED:Intensity 128         # Set brightness to 50%
Old : MCLS:LED:Intensity 0
New : MCLS:LED:Intensity 128

epics> caget MCLS:LED:Intensity_RBV         # Read current brightness
MCLS:LED:Intensity_RBV 128

epics> caput MCLS:LED:LEDEnable 1           # Turn LED on
Old : MCLS:LED:LEDEnable Off
New : MCLS:LED:LEDEnable On

epics> dbpr MCLS:LED:Intensity              # Print record details
epics> exit                                  # Exit the IOC
```

### From another terminal (using EPICS channel access):
```bash
caput MCLS:LED:Intensity 192
caget MCLS:LED:Intensity_RBV
caput MCLS:LED:LEDEnable 1
```

## Device Protocol

### Serial Settings
- Baud rate: 9600
- Data bits: 8
- Parity: None
- Stop bits: 1
- Terminator: CR+LF (0x0D 0x0A)
- Reply timeout: 1000 ms

### Commands
```
Command           Response        Description
&I?              &I##            Query intensity (## is hex 00-FF)
&I##             (echo)          Set intensity to ## (hex 00-FF)
&L1              (echo)          Enable LED
&L0              (echo)          Disable LED
```

## Files Structure

```
iocSchottMCLS/
├── README.md                           # This file
├── configure/
│   └── CONFIG                          # Build configuration
├── schottMCLSApp/
│   ├── src/
│   │   ├── Makefile                    # Build rules
│   │   ├── main.cpp                    # IOC main program
│   │   └── schottMCLS.dbd              # Database definition
│   └── Db/
│       ├── schottMCLS.db               # EPICS database records
│       └── schottMCLS.proto            # StreamDevice protocol
└── iocBoot/
    └── iocSchottMCLS/
        └── st.cmd                      # Startup script
```

## Troubleshooting

### Build Errors
- Ensure EPICS_BASE, ASYN, and STREAM paths are correct in `configure/CONFIG`
- Try `make clean` before rebuilding
- Check that synApps modules are installed

### Device Not Found
- Check USB connection: `lsusb | grep Cypress`
- Check serial port exists: `ls -la /dev/ttyUSB*`
- May need to install USB drivers for your system
- Verify device address in st.cmd (currently `/dev/ttyUSB0`)

### No Response from Device
1. Enable debugging in st.cmd:
```
asynSetTraceMask("L0", 0, 9)
asynSetTraceIOMask("L0", 0, 2)
```

2. Test serial connection manually:
```bash
screen /dev/ttyUSB0 9600
# Type: &I?
# Should respond with: &IXX (current intensity)
# Exit: Ctrl-A then X
```

3. Check device power and cable connections

### PV Records Not Loading
- Verify database file path in st.cmd is correct
- Check `schottMCLS.db` file exists and is readable
- Look for error messages in IOC console output

## Dependencies

- EPICS Base 7.0.5 or later
- asyn-R4-42
- StreamDevice-2-8-22
- Both available in synApps installation

## Notes

- The IOC uses StreamDevice for protocol handling - this provides easy command/response parsing
- asyn handles the low-level serial port communication
- Protocol file is searched in `$STREAM_PROTOCOL_PATH` directory
- All PV values are in decimal (0-255); protocol uses hexadecimal (00-FF)
# schottMCLS
