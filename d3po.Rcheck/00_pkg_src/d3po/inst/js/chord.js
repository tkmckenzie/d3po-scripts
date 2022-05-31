//Variables from R: edgeColor, colorScheme, divergentColorScheme

const outerRadius = Math.min(width, height) * 0.45;
const innerRadius = outerRadius * 0.9;
const bandWidth = (outerRadius - innerRadius) / 2;

function getGradID(d){return "linkGrad-" + d.source.index + "-" + d.target.index;}
function between(x, min, max){return x >= min && x <= max;}

chord = d3.chord()
	.padAngle(0.05)
	.sortSubgroups(d3.descending)
	.sortChords(d3.descending);

arc = d3.arc()
	.innerRadius(innerRadius)
	.outerRadius(outerRadius);

label_arc = d3.arc()
  .innerRadius(outerRadius)
  .outerRadius(outerRadius);

ribbon = d3.ribbon()
	.radius(innerRadius);

const range = divergentColorScheme ? d3.range(0, 1, 1 / (data.labels.length - 1)).concat([1])
  : d3.range(0, 1, 1 / (data.labels.length));
const colors = range.map(colorScheme);
color = d3.scaleOrdinal(colors)
  .domain(data.labels);

svg.attr("viewBox", [-width / 2, -height / 2, width, height])
  .attr("font-size", 10)
  .attr("font-family", "sans-serif");

const chords = chord(data.matrix);

const group = svg.append("g")
	.selectAll("g")
	.data(chords.groups)
	.enter().append("g");

group.append("path")
	.attr("fill", d => color(d.index))
	.attr("stroke", d => d3.rgb(color(d.index)).darker())
	.attr("d", arc);

svg.selectAll(".donutArcSlices")
  .data(chords.groups)
  .enter().append("path")
  .attr("class", "donutArcSlices")
  .attr("d", arc)
  .style("fill", function(d, i) {return color(i);})
  .each(function(d, i){
    var firstArcSection = /(^.+?)L/;
    var newArc = firstArcSection.exec(d3.select(this).attr("d"))[1];
    newArc = newArc.replace(/,/g , " ");
	
	if (between((d.endAngle + d.startAngle) / 2, 90 * Math.PI / 180, 270 * Math.PI / 180)){
		var startLoc = /M(.*?)A/;
		var middleLoc = /A(.*?)0 0 1/;
		var endLoc = /0 0 1 (.*?)$/;
		var newStart = endLoc.exec(newArc)[1];
        var newEnd = startLoc.exec(newArc)[1];
        var middleSec = middleLoc.exec(newArc)[1];
		
		newArc = "M" + newStart + "A" + middleSec + "0 0 0 " + newEnd;
	}
    
    svg.append("path")
      .attr("class", "hiddenDonutArcs")
      .attr("id", "arcID_" + i)
      .attr("d", newArc)
      .attr("fill", "none");
  });
  
group.append("text")
  .attr("dy", d => between((d.endAngle + d.startAngle) / 2, 90 * Math.PI / 180, 270 * Math.PI / 180) ? 18 : -11)
  .append("textPath")
    .attr("startOffset","50%")
    .attr("text-anchor","middle")
    .attr("xlink:href", function(d, i){return "#arcID_" + i;})
  .text(function(d) {return data.labels[d.index];});

link = svg.append("g")
		.attr("fill-opacity", 0.67)
	.selectAll("path")
	.data(chords)
	.enter().append("g")
	  .style("mix-blend-mode", "multiply");

if (edgeColor === "path"){
  const gradient = link.append("linearGradient")
	  	.attr("id", d => (d.uid = getGradID(d)))
		  .attr("gradientUnits", "userSpaceOnUse")
	  	.attr("x1", function(d,i) {
        return innerRadius*Math.cos((d.source.endAngle-d.source.startAngle)/2 +
        d.source.startAngle-Math.PI/2);
      })
		  .attr("y1", function(d,i) {
        return innerRadius*Math.sin((d.source.endAngle-d.source.startAngle)/2 + 
        d.source.startAngle-Math.PI/2);
      })
		  .attr("x2", function(d,i) {
        return innerRadius*Math.cos((d.target.endAngle-d.target.startAngle)/2 + 
        d.target.startAngle-Math.PI/2);
      })
		  .attr("y2", function(d,i) {
        return innerRadius*Math.sin((d.target.endAngle-d.target.startAngle)/2 + 
        d.target.startAngle-Math.PI/2);
      });
  
  gradient.append("stop")
	  	.attr("offset", "0%")
		  .attr("stop-color", d => color(d.source.index));
  
  gradient.append("stop")
	  	.attr("offset", "100%")
		  .attr("stop-color", d => color(d.target.index));
}

link.append("path")
		.attr("d", ribbon)
		.attr("fill", d => edgeColor === "none" ? "#aaa"
			: edgeColor === "path" ? "url(#" + d.uid + ")"
			: edgeColor === "input" ? color(d.source.index)
			: color(d.target.index))
		.attr("stroke", d => edgeColor === "none" ? "#aaa"
			: edgeColor === "path" ? "url(#" + d.uid + ")"
			: edgeColor === "input" ? color(d.source.index)
			: color(d.target.index));
