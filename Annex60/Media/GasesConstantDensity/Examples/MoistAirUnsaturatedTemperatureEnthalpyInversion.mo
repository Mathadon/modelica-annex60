within Annex60.Media.GasesConstantDensity.Examples;
model MoistAirUnsaturatedTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
  extends Annex60.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium =
        Annex60.Media.GasesConstantDensity.MoistAirUnsaturated);
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Media/GasesConstantDensity/Examples/MoistAirUnsaturatedTemperatureEnthalpyInversion.mos"
        "Simulate and plot"));
end MoistAirUnsaturatedTemperatureEnthalpyInversion;
