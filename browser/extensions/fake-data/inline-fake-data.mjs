#!/usr/bin/env node
// --experimental-modules may be required for older Node.js versions
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const templatePath = path.resolve(__dirname, "fake-data.template.json");
const outputPath = path.resolve(__dirname, "fake-data.hate");
const jsDir = __dirname;

const template = JSON.parse(fs.readFileSync(templatePath, "utf8"));
const callbacks = template.fake_data.custom_callbacks;
const customGenerators = template.fake_data.custom_generators || [];

const jsFiles = fs.readdirSync(jsDir).filter((f) => f.endsWith(".js"));

for (const file of jsFiles) {
  const key = path.basename(file, ".js");
  const jsCode = fs.readFileSync(path.join(jsDir, file), "utf8");
  if (Object.prototype.hasOwnProperty.call(callbacks, key)) {
    callbacks[key] = jsCode;
  } else {
    customGenerators.push({ callback: jsCode, label: key });
  }
}

template.fake_data.custom_generators = customGenerators;

const hateTemplate = `HATE:{{fake_data}}`;

fs.writeFileSync(
  outputPath,
  hateTemplate.replace("{{fake_data}}", JSON.stringify(template)),
  "utf8"
);
console.log("fake-data.hate generated successfully.");
