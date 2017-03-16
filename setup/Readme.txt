
1) wxs dateien erstellen:
Export aus svn in ein dummy verzeichnis (Sicherstellen dass nur in svn eingecheckte Dateien und kein .svn in den directories ist)
   
For more information see: http://wix.sourceforge.net

Command verzeichnis öffnen (Start/Run)

Ins verzeichnis gehen
F:\Winexe>

heat.exe dir "F:\Winexe\DummyCode\Code" -cg Code -dr CODEDIR -gg -srd -out "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\Code.wxs"
heat.exe dir "F:\Winexe\DummyCode\Examples" -cg Examples -dr EXAMPLEDIR -gg -srd -out "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\Examples.wxs"
heat.exe dir "F:\Winexe\DummyCode\Manual" -cg Manual -dr MANUALDIR -gg -srd -out "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\Manual.wxs"

ersetze sourceDir dir "..\..\<Manual>"

Kopiere /svn/SimModel/trunk/Dist/wix/SimModel.wxs und passe Source an 

2) Ersetzen der GUIDs durch Thomas

3)
candle.exe "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\setup.wxs"  -o "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\setup.wixobj"  
candle.exe "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\Code.wxs" -o "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\Code.wixobj" 
candle.exe "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\Examples.wxs" -o "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\Examples.wixobj" 
candle.exe "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\Manual.wxs" -o "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\Manual.wixobj" 
candle.exe "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\SimModel.wxs" -o "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\SimModel.wixobj" 
candle.exe "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\BTS.DCILight.wxs" -o "C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\BTS.DCILight.wixobj" 

4) erstelle .msi
in das richtige verzeichnis  gehen:
cd C:\Projects\MoBiToolbox_for Matlab\Dev\Basis_Toolbox\Build\setup\
C:


Für das Produktiv setup sollte -sice:61 nicht mit ausgeführt werden
F:\Winexe\light.exe -out MoBiToolBox.msi setup.wixobj Code.wixobj Examples.wixobj Manual.wixobj SimModel.wixobj BTS.DCILight.wixobj -ext WixUIExtension -ext WixNetFxExtension -sice:61