//Variables from R: textColor

const fontFamily = "sans-serif";
const fontScale = 15;
rotate = () => 0;
const padding = 0;

const textToGroup = {};
data.map(d => (textToGroup[d.text.replace(/[^A-Za-z0-9]+/g, "")] = d.group));

const uniqueGroups = Array.from(new Set(data.map(d => d.group)));

const range = textColor === "group" ? d3.range(0, 1, 1 / (uniqueGroups.length - 1)).concat([1])
  : textColor === "word" ? d3.range(0, 1, 1 / (data.length - 1)).concat([1])
  : [1];
const colors = range.map(d3.interpolateSpectral);
color = d3.scaleOrdinal(colors);

const cloud = d3.layout.cloud()
  .size([width, height])
  .words(data.map(d => Object.create(d)))
  .padding(padding)
  .rotate(rotate)
  .font(fontFamily)
  .fontSize(d => Math.sqrt(d.value) * fontScale)
  .on("word", ({size, x, y, rotate, text}) => {
    svg.append("text")
      .attr("font-size", size)
	  .style("fill", textColor === "group" ? color(textToGroup[text.replace(/[^A-Za-z0-9]+/g, "")])
	      : textColor === "word" ? color(text)
	      : "#000")
      .attr("transform", `translate(${x},${y}) rotate(${rotate})`)
      .text(text);
  });

cloud.start();
cloud.stop();
