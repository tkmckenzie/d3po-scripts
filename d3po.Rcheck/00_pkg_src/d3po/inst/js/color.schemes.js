// Variables from R: title, legendTextSize, scaleTextSize, colorDomain, numLegendTicks, colorScheme, divergentColorScheme

// Color domain and range parameters
const colorDomainMin = 0;
const colorDomainMax = 1;
const colorDomainRange = colorDomainMax - colorDomainMin;

const colorRange = colorDomain.map(n => colorScheme((n - colorDomainMin) / colorDomainRange));

// Legend domain parameters
legendDomain = d3.range(numLegendTicks).map(n => colorDomainMin + n * colorDomainRange / (numLegendTicks - 1));

// Shape data
us = data.shape;
path = d3.geoPath();

// Value data
const state_value_zip = data.values.state.map(function(e, i) {return [e, data.values.value[i]];});
data_map = new Map(state_value_zip);

// Scales and formatting
const color = d3.scaleLinear()
  .domain(colorDomain)
  .range(colorRange);
const format = d => `${d}`;

// Legend position parameters
const legendWidth = 200;
const legendHeight = 20;
const legendX = 1000 - legendWidth - 150;
const legendY = 30;

// Setting viewbox for standardization
svg.attr("viewBox", [0, 0, 1000, 600]);

const defs = svg.append("defs");
const linearGradient = defs.append("linearGradient")
  .attr("id", "linear-gradient");
linearGradient
  .attr("x1", "0%")
  .attr("y1", "0%")
  .attr("x2", "100%")
  .attr("y2", "0%");
linearGradient.selectAll("stop")
  .data(colorDomain.map(function(e, i) {return {offset: `${Math.round(100 * (e - colorDomainMin) / colorDomainRange)}%`, color: colorRange[i]};}))
  .enter().append("stop")
  .attr("offset", d => d.offset)
  .attr("stop-color", d => d.color);
svg.append("text")
  .attr("class", "legendTitle")
  .attr("x", legendX)
  .attr("y", legendY - 10)
  .style("text-anchor", "left")
  .attr("font-size", legendTextSize)
  .text(title);
svg.append("rect")
  .attr("x", legendX)
  .attr("y", legendY)
  .attr("width", legendWidth)
  .attr("height", legendHeight)
  .style("fill", "url(#linear-gradient)");
const xLeg = d3.scaleLinear()
  .domain([colorDomainMin, colorDomainMax])
  .range([legendX, legendX + legendWidth - 1]);
const axisLeg = d3.axisBottom(xLeg)
  .tickValues(legendDomain)
  .tickSize(-legendHeight);
svg
  .attr("class", "axis")
  .append("g")
  .attr("transform", `translate(0, ${legendY + legendHeight})`)
  .style("font-size", `${scaleTextSize}px`)
  .call(axisLeg)
  .select(".domain").remove();

svg.append("g")
  .selectAll("path")
  .data(topojson.feature(us, us.objects.states).features)
  .enter().append("path")
    .attr("fill", d => color(data_map.get(d.properties.name)))
    .attr("d", path)
  .append("title")
    .text(d => `${d.properties.name} ${format(data_map.get(d.properties.name))}`);

svg.append("path")
  .datum(topojson.mesh(us, us.objects.states, (a, b) => a !== b))
  .attr("fill", "none")
  .attr("stroke", "white")
  .attr("stroke-linejoin", "round")
  .attr("d", path);
