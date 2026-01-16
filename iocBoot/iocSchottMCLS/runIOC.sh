#!/bin/bash

# Quick start script for Schott MC-LS IOC using asyn testConnect
cd "$(dirname "$0")"

echo "Starting Schott MC-LS IOC"
echo "PV prefix: MCLS:LED:"
echo ""
echo "Available commands:"
echo "  caput MCLS:LED:Intensity 128    # Set brightness to 50%"
echo "  caget MCLS:LED:Intensity_RBV   # Read current brightness"
echo "  caput MCLS:LED:LEDEnable 1     # Enable LED"
echo "  exit                            # Exit IOC"
echo ""

# Use the asyn testConnect executable which has stream and asyn support
/opt/epics/synApps/support/asyn-R4-42/bin/linux-x86_64/testConnect st.cmd
