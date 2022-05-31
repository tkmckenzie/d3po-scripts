//Variables from R: textColor, colorScheme, divergentColorScheme, legendFontSize

const fontFamily = "sans-serif";
const fontScale = 15;
rotate = () => 0;
const padding = 0;

const textToGroup = {};
//data.map(d => (d.text = d.group + "::" + d.text.replace(/[^A-Za-z0-9]+/g, "")));
data.map(d => (d.text = d.group + "::" + d.text));

const uniqueGroups = Array.from(new Set(data.map(d => d.group)));

//textColor === "group" ? d3.range(0, 1, 1 / (uniqueGroups.length - 1)).concat([1])
//: textColor === "word" ? d3.range(0, 1, 1 / (data.length - 1)).concat([1])
const range = textColor === "group" ?
    (divergentColorScheme && uniqueGroups.length > 1) ? d3.range(0, 1, 1 / (uniqueGroups.length - 1)).concat([1])
      : d3.range(0, 1, 1 / (uniqueGroups.length))
  : textColor === "word" ? d3.range(0, 1, 1 / (data.length))
  : [1];
const colors = range.map(colorScheme);
color = d3.scaleOrdinal(colors);

const cloud = d3.layout.cloud()
  .size([width, textColor == "group" ? height * 0.8 : height])
  .words(data.map(d => Object.create(d)))
  .padding(padding)
  .rotate(rotate)
  .font(fontFamily)
  .fontSize(d => Math.sqrt(d.value) * fontScale)
  .on("word", ({size, x, y, rotate, text}) => {
    svg.append("text")
      .attr("font-size", size)
	  .style("fill", textColor === "group" ? color(text.split("::")[0])
	      : textColor === "word" ? color(text)
	      : "#000")
      .attr("transform", `translate(${x},${y}) rotate(${rotate})`)
      .text(text.split("::")[1])
      .attr("text-anchor", "middle")
      .style("alignment-baseline", "middle");
  });

if (textColor == "group"){
  svg.selectAll("mylabels")
    .data(uniqueGroups)
    .enter().append("text")
      .attr("x", function(d, i) {return((i + 0.5) * width / uniqueGroups.length);})
      .attr("y", height * 0.9)
      .style("fill", d => color(d))
      .text(d => d)
      .attr("font", fontFamily)
      .attr("font-size", legendFontSize)
      .attr("text-anchor", "middle")
      .style("alignment-baseline", "middle");
}

cloud.start();
cloud.stop();
