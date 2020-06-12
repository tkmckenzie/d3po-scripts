format = d => d.toLocaleString();

const unique_y = Array.from(new Set(data.map(d => d.y)));
const range = d3.range(0, 1, 1 / (unique_y.length - 1)).concat([1]);
const colors = range.map(d3.interpolateSpectral);
color = d3.scaleOrdinal(colors)
  .domain(data.map(d => d.y));

const margin = ({top: 30, right: -1, bottom: -1, left: 1});

treemap = data => d3.treemap()
  .round(true)
  .tile(d3.treemapSliceDice)
  .size([
    width - margin.left - margin.right,
    height - margin.top - margin.bottom
  ])
  (d3.hierarchy(
    {
      values: d3.nest()
        .key(d => d.x)
        .key(d => d.y)
        .entries(data)
    },
    d => d.values
  ).sum(d => d.value))
  .each(d => {
    d.x0 += margin.left;
    d.x1 += margin.left;
    d.y0 += margin.top;
    d.y1 += margin.top;
});

svg.attr("viewBox", [0, 0, width, height])
  .style("font", "10px sans-serif");

const root = treemap(data);

const node = svg.selectAll("g")
  .data(root.descendants())
  .enter().append("g")
    .attr("transform", d => `translate(${d.x0},${d.y0})`);

const column = node.filter(d => d.depth === 1);

column.append("text")
  .attr("x", 3)
  .attr("y", "-1.7em")
  .style("font-weight", "bold")
  .text(d => d.data.key);

column.append("text")
  .attr("x", 3)
  .attr("y", "-0.5em")
  .attr("fill-opacity", 0.7)
  .text(d => format(d.value));

column.append("line")
  .attr("x1", -0.5)
  .attr("x2", -0.5)
  .attr("y1", -30)
  .attr("y2", d => d.y1 - d.y0)
  .attr("stroke", "#000");

const cell = node.filter(d => d.depth === 2);

cell.append("rect")
  .attr("fill", d => color(d.data.key))
  .attr("fill-opacity", (d, i) => d.value / d.parent.value)
  .attr("width", d => d.x1 - d.x0 - 1)
  .attr("height", d => d.y1 - d.y0 - 1);

cell.append("text")
  .attr("x", 3)
  .attr("y", "1.1em")
  .text(d => d.data.key);

cell.append("text")
  .attr("x", 3)
  .attr("y", "2.3em")
  .attr("fill-opacity", 0.7)
  .text(d => format(d.value));
  