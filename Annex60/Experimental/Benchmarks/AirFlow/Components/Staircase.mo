within Annex60.Experimental.Benchmarks.AirFlow.Components;
model Staircase
  "Zone representing a staircase connecting multiple floor models"

  parameter Modelica.SIunits.Temperature TRoom = 293.15
    "Indoor air temperature of room in K";
  parameter Modelica.SIunits.Height heightRoom = 3 "Height of room in m";
  parameter Modelica.SIunits.Length lengthRoom = 3 "Length of room in m";
  parameter Modelica.SIunits.Length widthRoom = 3 "Width of room in m";
  parameter Real doorOpening = 1
    "Opening of door (between 0:closed and 1:open)";

  parameter Modelica.SIunits.CoefficientOfHeatTransfer UValue = 1
    "Heat transfer coefficient for outside wall";

  replaceable package Medium = Modelica.Media.Air.SimpleAir;
  parameter Boolean forceErrorControlOnFlow = true
    "Flag to force error control on m_flow. Set to true if interested in flow rate";

  Fluid.MixingVolumes.MixingVolume volumeStairs(
    redeclare package Medium = Medium,
    m_flow_nominal=0.001,
    V=heightRoom*lengthRoom*widthRoom,
    T_start=TRoom,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=4,
    mSenFac=60) "Air volume of staircase element"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conRoom(G=
        heightRoom*widthRoom*UValue)
    "Thermal conductor between fixed T and Volume"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_toHallway(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_toHallway(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_bot(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_top(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));
  Airflow.Multizone.MediumColumn col2(
    redeclare package Medium = Medium,
    h=heightRoom/2,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-60})));

  Airflow.Multizone.MediumColumn col1(
    redeclare package Medium = Medium,
    h=heightRoom/2,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Airflow.Multizone.Orifice ori(
    redeclare package Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow,
    A=widthRoom*lengthRoom)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,78})));
  Airflow.Multizone.DoorDiscretizedOperable doo(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    wOpe=1,
    hOpe=2.2,
    CDOpe=0.78,
    CDClo=0.78,
    nCom=10,
    hA=3/2,
    hB=3/2,
    dp_turbulent(displayUnit="Pa") = 0.01,
    forceErrorControlOnFlow=forceErrorControlOnFlow) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-80,0})));
  Modelica.Blocks.Sources.Constant const(k=doorOpening)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-60,30})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTemp
    "Dry bulb air temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{80,-20},{120,20}}), iconTransformation(extent={{
            -128,30},{-108,50}})));
equation
  connect(weaBus.TDryBul, preTemp.T);

  connect(conRoom.port_b, volumeStairs.heatPort) annotation (Line(
      points={{10,0},{20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_a_bot, port_a_bot) annotation (Line(
      points={{0,-100},{0,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a_bot, col2.port_b) annotation (Line(
      points={{0,-100},{0,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(doo.port_b1, port_b_toHallway) annotation (Line(
      points={{-90,-6},{-92,-6},{-92,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(doo.port_a2, port_a_toHallway) annotation (Line(
      points={{-90,6},{-92,6},{-92,60},{-100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, doo.y) annotation (Line(
      points={{-60,23.4},{-60,0},{-69,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ori.port_b, port_a_top) annotation (Line(
      points={{4.44089e-016,88},{4.44089e-016,96},{0,96},{0,98}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori.port_a, col1.port_a) annotation (Line(
      points={{-6.66134e-016,68},{-6.66134e-016,64},{0,64},{0,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(doo.port_b2, volumeStairs.ports[1]) annotation (Line(
      points={{-70,6},{-56,6},{-56,-24},{27,-24},{27,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(doo.port_a1, volumeStairs.ports[2]) annotation (Line(
      points={{-70,-6},{-62,-6},{-62,-26},{29,-26},{29,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col2.port_a, volumeStairs.ports[3]) annotation (Line(
      points={{0,-50},{0,-28},{31,-28},{31,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col1.port_b, volumeStairs.ports[4]) annotation (Line(
      points={{0,40},{0,32},{62,32},{62,-26},{33,-26},{33,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preTemp.port, conRoom.port_a) annotation (Line(
      points={{-20,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics),                         Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>An air volume to represent a staircase element for a scalable air flow benchmark. </p>
<h4>Assumptions and limitations</h4>
<p>This is a very simple room representation. The model is intended to roughly approximate a first order response of the zone to changes in outdoor air temperature. This is achieved by a thermal resistance in model conRoom and the capitancy of the mixing volume represented by the value for mSenFac. The G-Value of conRoom is approximated by the area of one outside wall multiplied with a U-Value of 1 W/(m**2*K). The value for mSenFac has been estimated from comparisons with other room models as shown in <a href=\"modelica://Annex60.Experimental.Benchmarks.AirFlow.Examples.ZoneStepResponse\">Annex60.Experimental.Benchmarks.AirFlow.Examples.ZoneStepResponse</a>. For this model, a value for mSenFac slightly lower than in <a href=\"modelica://Annex60.Experimental.Benchmarks.AirFlow.Components.SimpleZone\">Annex60.Experimental.Benchmarks.AirFlow.Components.SimpleZone</a> has been chosen.</p>
<h4>Typical use and important parameters</h4>
<p>port_a_toHallway and port_b_toHallway should be connected to the corresponding ports of a hallway model. port_a_top and port_b_top can be connected to another staircase model via its respective port_a_bot and port_b_bot. </p>
<h4>References</h4>
<p>Inspired by Buildings.Airflow.Multizone.Examples.Validation3Rooms </p>
</html>",
   revisions="<html>
<ul>
<li>
February 2015 by Marcus Fuchs:<br/>
First implementation
</li>
</ul>
</html>"));
end Staircase;