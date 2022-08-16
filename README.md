# JSON Application Example

## Description
This application example demonstrates the usage of the [JSON Library](https://github.com/simatic-ax/json)

This application example consists of two parts.

1. Showing the usage of the library in a PLC Program, which can be downloaded to a 1500 PLC
1. Many examples as UnitTest in the `test` folder

## Execute the Application Example on the PLC (AX Code local)

1. Open a command line interface (CLI) and switch to the target folder like:
      ```sh
      D:
      cd \Examples
      ```
1. Install the application example `AX Code`

      Run the following commands in a CLI
      ```sh
      apax create @simatic-ax/ae-json-library --registry https://npm.pkg.github.com ae-json-library
      axcode ae-json-library
      ```

1. Start a PLCSIM Advanced Instance. Download a TIA Portal created HWCN with a 1500 standard PLC (IP: Address 192.168.0.1).

1. If not open, open a terminal in AX Code (`CTRL+SHIFT+ö`)

1. Install dependencies
   
   ```cli
   apax install -L
   ```
1. Build in download the project to the PLC
   
   ```cli
   apax dlsim
   ```
   
   The project will be compiled and downloaded to the PLCSIM Advanced instance

1. Open the monitoring file mon.mon

1. Go online
 
## Contribution

Thanks for your interest in contributing. Anybody is free to report bugs, unclear documentation, and other problems regarding this repository in the Issues section or, even better, is free to propose any changes to this repository using pull requests.


## License and Legal information

Please read the [Legal information](LICENSE.md)