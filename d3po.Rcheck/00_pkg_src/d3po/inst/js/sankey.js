//Variables from R: sortNodes, textAlign, edgeColor, marginProportion, colorScheme, divergentColorScheme

const align = "justify"; //one of "justify", "left", "right", or "center"

function wrap(text, width) {
    text.each(function () {
        var text = d3.select(this),
            words = text.text().split("\n").reverse(),
            word,
            line = [],
            lineNumber = 0,
            lineHeight = 1.1, // ems
            x = text.attr("x"),
            y = text.attr("y"),
            //dy = 0, //parseFloat(text.attr("dy")),
            dy = (0.9 - 0.5 * words.length) * lineHeight;
            tspan = text.text(null)
                        .append("tspan")
                        .attr("x", x)
                        .attr("y", y)
                        .attr("dy", dy + "em");
        while (word = words.pop()) {
            line.push(word);
            tspan.text(line.join(""));
            if (tspan.node().getComputedTextLength() > width) {
                line.pop();
                tspan.text(line.join(""));
                line = [word];
                tspan = text.append("tspan")
                            .attr("x", x)
                            .attr("y", y)
                            .attr("dy", (++lineNumber - 1) * lineHeight + dy + "em")
                            .text(word);
            }
        }
    });
    return text;
}

const links_raw = data;
const nodes_raw = Array.from(new Set(links_raw.flatMap(l => [l.source, l.target])), name => ({name: name, category: name.replace(/[^A-Za-z0-9]+/g, "")})).sort();
const data_raw = {nodes: nodes_raw.map(d => Object.assign({}, d)), links: links_raw.map(d => Object.assign({}, d)), units: "TWh"};

const sankey = d3.sankey()
  .nodeId(d => d.name)
  .nodeAlign(d3[`sankey${align[0].toUpperCase()}${align.slice(1)}`])
  .nodeWidth(15)
  .nodePadding(10)
  .extent(textAlign === "outside" ? [[marginProportion * width, 10], [(1 - marginProportion) * width, height - 10]] : [[1, 5], [width - 1, height - 5]]);

if (!sortNodes){
  sankey.nodeSort(null);
}

const {nodes, links} = sankey(data_raw);

const range = divergentColorScheme ? d3.range(0, 1, 1 / (nodes.length - 1)).concat([1])
  : d3.range(0, 1, 1 / (nodes.length));
const colors = range.map(colorScheme);
const colorScale = d3.scaleOrdinal(colors);
color = d => colorScale(d.category === undefined ? d.name : d.category);

function getGradID(d){return "linkGrad-" + d.source.category + d.target.category;}

g = svg.append("g")
		.attr("stroke", "#000")
	.selectAll("rect")
	.data(nodes)
	.enter().append("rect")
		.attr("x", d => d.x0)
		.attr("y", d => d.y0)
		.attr("height", d => d.y1 - d.y0)
		.attr("width", d => d.x1 - d.x0)
		.attr("fill", color)
	.append("title")
		.text(d => `${d.name}\n${format(d.value)}`);

const link = svg.append("g")
		.attr("fill", "none")
		.attr("stroke-opacity", 0.5)
	.selectAll("g")
	.data(links)
	.enter().append("g")
		.style("mix-blend-mode", "multiply");

if (edgeColor === "path"){
  const gradient = link.append("linearGradient")
	  	.attr("id", d => (d.uid = getGradID(d)))
		  .attr("gradientUnits", "userSpaceOnUse")
	  	.attr("x1", d => d.source.x1)
		  .attr("x2", d => d.target.x0);
  
  gradient.append("stop")
	  	.attr("offset", "0%")
		  .attr("stop-color", d => color(d.source));
  
  gradient.append("stop")
	  	.attr("offset", "100%")
		  .attr("stop-color", d => color(d.target));
}

link.append("path")
		.attr("d", d3.sankeyLinkHorizontal())
		.attr("stroke", d => edgeColor === "none" ? "#aaa"
			: edgeColor === "path" ? "url(#" + d.uid + ")"
			: edgeColor === "input" ? color(d.source)
			: color(d.target))
		.attr("stroke-width", d => Math.max(1, d.width));

svg.append("g")
		.attr("font-family", "sans-serif")
		.attr("font-size", 10)
	.selectAll("text")
	.data(nodes)
	.enter().append("text")
		.attr("x", d => d.x0 < width / 2 ? (textAlign === "outside" ? d.x1 - 20 : d.x1 + 6) : (textAlign === "outside" ? d.x0 + 20 : d.x0 - 6))
		.attr("y", d => (d.y1 + d.y0) / 2)
		.attr("dy", "0.35em")
		.attr("text-anchor", d => d.x0 < width / 2 ? (textAlign === "outside" ? "end" : "start") : (textAlign === "outside" ? "start" : "end"))
		.text(d => d.name)
		.call(wrap, 0);

function format(d){
	const format = d3.format(",.0f");
	return data.units ? `${format(d)} ${data.units}`: format;
}
