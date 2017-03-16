# Matlab-Toolbox

## About the Toolbox
The MoBi® Toolbox for Matlab® is a collection of Matlab® functions, which allows for the processing of models developed in PK-Sim® or  MoBi® from within Matlab®. For example, the Matlab® environment can be used to change parameters in a model, simulate the model, and analyze the results. This allows for an efficient operation in the model analysis stage, using the programming options as well as the function library available within Matlab® in combination with the powerful modeling interface and solver kernel included in PK-Sim® and 
MoBi®. In addition, the toolbox offers efficient analysis methods tailored to the needs of systems biology and PBPK modeling including parameter identification and optimization. 

The Toolbox can be found under _**Program Files (x86)/Open Systems Pharmacology/MoBi Toolbox for Matlab X.Y**_

## Typical Matlab script to evaluate a model
The MoBi® Toolbox for Matlab® offers convenient access to PBPK and systems biology models developed in MoBi® or PK-Sim®.
A Matlab® code to analyze a MoBi® model typically contains the following steps:
1. Initialize the MoBi model.
2. Set parameters.
3. Simulate model
4. Analyze results
5. Store modified model or reset.

The steps 2-4 are often repeated in an iterative manner, as can also be automated
using the Matlab® programming options.

Even though Matlab® scripts can be programmed from scratch, it is recommended
to execute _**generateMatlabCodeForXML**_ on first usage. This will open a
Graphical User Interface (GUI) which allows you to:
- select a MoBi® model (xml) file,
- select parameters of the model to be initialized in order to vary them from within Matlab®.
- select entities to be retrieved after simulation, e.g. the drug plasma concentration.

Pressing the 'OK' button generates a Matlab® executable M-file, which contains the necessary Matlab®commands for executing the selected MoBi® model manipulations and evaluations.
The file is ideally suited for non-experts to start generating executable Matlab®-scripts for MoBi® model handling as it will reveal the necessary M-file structure.

## Toolbox schema
![clipboard01](https://cloud.githubusercontent.com/assets/25061876/24003370/9016e00e-0a63-11e7-8f69-ed6b952c6867.jpg)

## Code Status
[![Build status](https://ci.appveyor.com/api/projects/status/2pxt8se6bgjvrrh0/branch/master?svg=true&passingText=master%20-%20passing)](https://ci.appveyor.com/project/open-systems-pharmacology-ci/matlab-toolbox/branch/master)

## Code of conduct
Everyone interacting in the Open Systems Pharmacology community (codebases, issue trackers, chat rooms, mailing lists etc...) is expected to follow the Open Systems Pharmacology [code of conduct](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CODE_OF_CONDUCT.md).

## Contribution
We encourage contribution to the Open Systems Pharmacology community. Before getting started please read the [contribution guidelines](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CONTRIBUTING.md). If you are contributing code, please be familiar with the [coding standard](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CODING_STANDARD.md).

## License
Matlab-Toolbox is released under the [GPLv2 License](LICENSE).
