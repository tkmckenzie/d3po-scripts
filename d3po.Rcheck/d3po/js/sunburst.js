// Variables from R: colorScheme, divergentColorScheme

const partition = data => d3.partition()
    .size([2 * Math.PI, radius])
  (d3.hierarchy(data)
    .sum(d => d.value)
    .sort((a, b) => b.value - a.value));

const range = divergentColorScheme ? d3.range(0, 1, 1 / (data.children.length - 1)).concat([1])
  : d3.range(0, 1, 1 / (data.children.length));
const colors = range.map(colorScheme);
color = d3.scaleOrdinal(colors);

const radius = Math.min(width * 0.45, height * 0.45);

const format = d3.format(",d");

const arc = d3.arc()
  .startAngle(d => d.x0)
  .endAngle(d => d.x1)
  .padAngle(d => Math.min((d.x1 - d.x0) / 2, 0.005))
  .padRadius(radius / 2)
  .innerRadius(d => d.y0)
  .outerRadius(d => d.y1);

const root = partition(data);

svg.attr("viewBox", [-width / 2, -height / 2, width, height]);

svg.append("g")
    .attr("fill-opacity", 0.6)
  .selectAll("path")
  .data(root.descendants().filter(d => d.depth))
  .enter().append("path")
    .attr("fill", d => { while (d.depth > 1) d = d.parent; return color(d.data.name); })
    .attr("d", arc)
  .append("title")
    .text(d => `${d.ancestors().map(d => d.data.name).reverse().join("/")}\n${format(d.value)}`);

svg.append("g")
    .attr("pointer-events", "none")
    .attr("text-anchor", "middle")
    .attr("font-size", 10)
    .attr("font-family", "sans-serif")
  .selectAll("text")
  .data(root.descendants().filter(d => d.depth && (d.y0 + d.y1) / 2 * (d.x1 - d.x0) > 10))
  .enter().append("text")
    .attr("transform", function(d){
      const x = (d.x0 + d.x1) / 2 * 180 / Math.PI;
      const y = (d.y0 + d.y1) / 2;
      return `rotate(${x - 90}) translate(${y},0) rotate(${x < 180 ? 0 : 180})`;
    })
    .attr("dy", "0.35em")
    .text(d => d.data.name);
