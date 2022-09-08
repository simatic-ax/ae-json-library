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

1. Start a PLCSIM Advanced Instance or using a 1500 PLC. Download a TIA Portal created HWCN with a 1500 standard PLC (Default IP Address 192.168.0.1).

1. If not open, open a terminal in AX Code (`CTRL+SHIFT+ö`)

1. Start the application example 
   
   ```cli
   apax start [1500]
   ```
   > `1500` is required, if you use a real 1500 PLC instead of PLCSIM Advanced.

      Result:

      After the Download you'll see following conten in the terminal. Exit by pressing `x`.

      ![](docs/monoutput.png)

1. Monitor voa mon-File:
   
      ![](docs/monuioutput.png)

   1. Open the file `default.mon`
   1. Enable monitoring
   1. Observe the values




## Contribution

Thanks for your interest in contributing. Anybody is free to report bugs, unclear documentation, and other problems regarding this repository in the Issues section or, even better, is free to propose any changes to this repository using pull requests.


## License and Legal information

Please read the [Legal information](LICENSE.md)