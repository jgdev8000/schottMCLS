#!/bin/bash
# Schott MC-LS IOC Startup Script
# Run directly: /opt/iocs/schottMCLS/iocBoot/iocSchottMCLS/st.cmd

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Run the compiled IOC executable with the initialization script
exec /opt/iocs/schottMCLS/bin/linux-x86_64/schottMCLS "$SCRIPT_DIR/init.script"
